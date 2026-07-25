<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '../components/Navbar.vue'

const router = useRouter()

const newLocal = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩']
/* ---------------- Helpers ---------------- */
const arabicDigits = newLocal
const toArabicDigits = (n) => String(n).replace(/[0-9]/g, (d) => arabicDigits[d])
const formatEGP = (n) => `${toArabicDigits(Math.round(n).toLocaleString('en-US'))} ج.م`

/* ---------------- Toast feedback ---------------- */
const toastMessage = ref('')
let toastTimer = null
const showToast = (msg) => {
  toastMessage.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => (toastMessage.value = ''), 2500)
}

/* ---------------- Wizard steps ---------------- */
const steps = [
  { id: 1, label: 'الوجهة والمدة' },
  { id: 2, label: 'التفضيلات' },
  { id: 3, label: 'مراجعة الخطة' },
]
const currentStep = ref(1)
const maxReachedStep = ref(1)

const goToStep = (n) => {
  if (n <= maxReachedStep.value) currentStep.value = n
}
const goToPrevStep = () => {
  if (currentStep.value > 1) currentStep.value -= 1
}
const goToNextStep = () => {
  if (currentStep.value === 1 && selectedCities.value.length === 0) {
    showToast('اختر مدينة واحدة على الأقل للمتابعة')
    return
  }
  if (currentStep.value < steps.length) {
    currentStep.value += 1
    maxReachedStep.value = Math.max(maxReachedStep.value, currentStep.value)
  }
}

/* ---------------- Step 1: destination & duration ---------------- */
const selectedCities = ref(['أسوان', 'الأقصر', 'القاهرة'])
const newCityInput = ref('')
const addCity = () => {
  const value = newCityInput.value.trim()
  if (value && !selectedCities.value.includes(value)) {
    selectedCities.value.push(value)
    showToast(`تمت إضافة ${value}`)
  }
  newCityInput.value = ''
}
const removeCity = (city) => {
  selectedCities.value = selectedCities.value.filter((c) => c !== city)
  showToast(`تم حذف ${city}`)
}

const numDays = ref(7)
const decreaseDays = () => {
  if (numDays.value > 1) numDays.value -= 1
}
const increaseDays = () => {
  if (numDays.value < 21) numDays.value += 1
}

const tripStartDate = ref('١٥ أكتوبر ٢٠٢٤')
const dateInput = ref('2024-10-15')
const onDateChange = () => {
  const d = new Date(dateInput.value)
  if (!isNaN(d)) {
    tripStartDate.value = d.toLocaleDateString('ar-EG', { year: 'numeric', month: 'long', day: 'numeric' })
  }
}

/* ---------------- Step 2: preferences ---------------- */
const tripTypes = [
  { id: 'beach', label: 'شواطئ وغوص' },
  { id: 'historic', label: 'تاريخي' },
  { id: 'fun', label: 'ترفيهي' },
  { id: 'family', label: 'عائلي' },
  { id: 'adventure', label: 'مغامرة' },
  { id: 'relax', label: 'استجمام' },
]
const selectedTripType = ref('beach')
const tripTypeLabel = computed(() => tripTypes.find((t) => t.id === selectedTripType.value)?.label || '')

const accommodationOptions = [
  { id: 'hotel5', label: 'فندق ٥ نجوم', pricePerNight: 2200 },
  { id: 'apartment', label: 'شقة مفروشة', pricePerNight: 1400 },
]
const selectedAccommodation = ref('apartment')
const accommodationLabel = computed(() => accommodationOptions.find((a) => a.id === selectedAccommodation.value)?.label || '')
const accommodationPricePerNight = computed(() => accommodationOptions.find((a) => a.id === selectedAccommodation.value)?.pricePerNight || 0)

const dailyBudget = ref(1200)

const transportOptions = [
  { id: 'bus', label: 'أوتوبيس سياحي', flatPrice: 900 },
  { id: 'car', label: 'تأجير سيارة', flatPrice: 1500 },
  { id: 'train', label: 'قطار', flatPrice: 700 },
]
const selectedTransport = ref('car')
const transportLabel = computed(() => transportOptions.find((t) => t.id === selectedTransport.value)?.label || '')
const transportPrice = computed(() => transportOptions.find((t) => t.id === selectedTransport.value)?.flatPrice || 0)

const foodTagOptions = ['أكل شعبي', 'نباتي', 'مأكولات بحرية', 'مشويات', 'حلويات شرقية', 'مأكولات دولية']
const selectedFoodTags = ref(['أكل شعبي', 'نباتي', 'مأكولات بحرية'])
const toggleFoodTag = (tag) => {
  selectedFoodTags.value = selectedFoodTags.value.includes(tag)
    ? selectedFoodTags.value.filter((t) => t !== tag)
    : [...selectedFoodTags.value, tag]
}

const isGenerating = ref(false)
const generatePlan = async () => {
  isGenerating.value = true
  // TODO: replace with real API call, e.g.
  // days.value = await api.post('/trip-plans/generate', { cities: selectedCities.value, numDays: numDays.value, tripType: selectedTripType.value, accommodation: selectedAccommodation.value, dailyBudget: dailyBudget.value, transport: selectedTransport.value, foodTags: selectedFoodTags.value })
  await new Promise((resolve) => setTimeout(resolve, 900))
  isGenerating.value = false
  showToast('تم تحديث الخطة بناءً على اختياراتك')
}

/* ---------------- Step 3: day-by-day itinerary ---------------- */
const days = ref([
  {
    num: 1,
    title: 'اليوم الأول: القاهرة - عبق التاريخ',
    subtitle: 'المتحف القومي للحضارة، مجمع الأديان، النيل',
    accommodation: 'Cairo Marriott Hotel & Omar Khayyam Casino',
    timeline: [
      { time: '٨:٠٠ ص', aiTip: true, category: 'food', title: 'إفطار في مقهى الفيشاوي', desc: 'ابدأ يومك في خان الخليلي بأشهر مقهى تاريخي. جرب الشاي بالنعناع والفطير المشلتت.', photos: '١٢ صورة من فسحني', duration: '٤٥ دقيقة', priceValue: 150, img: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=300&q=80' },
      { time: '١٠:٠٠ ص', aiTip: false, category: 'activity', title: 'زيارة المتحف القومي للحضارة (NMEC)', desc: 'جولة في قاعة المومياوات الملكية وتعرف على تطور الحضارة المصرية عبر العصور.', photos: '٤٥ صورة من فسحني', duration: '٣ ساعات', priceValue: 200, img: 'https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=300&q=80' },
      { time: '٧:٠٠ م', aiTip: false, category: 'food', title: 'عشاء في "Nile Kitchen"', desc: 'تجربة عشاء فاخرة على مركب في النيل مع إطلالة بانورامية على أضواء القاهرة.', photos: '٨ صور من فسحني', duration: '٢ ساعة', priceValue: 600, img: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300&q=80' },
    ],
  },
  {
    num: 2,
    title: 'اليوم الثاني: الأقصر - مدينة المائة باب',
    subtitle: 'وادي الملوك، معبد حتشبسوت، معبد الأقصر',
    accommodation: 'Luxor Nile Palace Hotel',
    timeline: [
      { time: '٧:٠٠ ص', aiTip: true, category: 'activity', title: 'جولة في وادي الملوك', desc: 'زيارة مقابر الفراعنة المنحوتة في الصخر، بما في ذلك مقبرة توت عنخ آمون.', photos: '٣٠ صورة من فسحني', duration: '٣ ساعات', priceValue: 250, img: 'https://images.unsplash.com/photo-1568402102990-bc541580b59f?w=300&q=80' },
      { time: '١١:٣٠ ص', aiTip: false, category: 'activity', title: 'معبد حتشبسوت', desc: 'استكشاف المعبد الجنائزي المهيب المنحوت في الجبل، أحد أروع الآثار المصرية القديمة.', photos: '٢٢ صورة من فسحني', duration: 'ساعة ونصف', priceValue: 140, img: 'https://images.unsplash.com/photo-1553913861-c0fddf2619ee?w=300&q=80' },
      { time: '٦:٠٠ م', aiTip: false, category: 'activity', title: 'غروب الشمس عند معبد الأقصر', desc: 'نزهة مسائية بين أعمدة معبد الأقصر مع إضاءة ذهبية ساحرة عند الغروب.', photos: '١٨ صورة من فسحني', duration: 'ساعة', priceValue: 100, img: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=300&q=80' },
    ],
  },
  {
    num: 3,
    title: 'اليوم الثالث: رحلة المنطاد وحياة القرية',
    subtitle: 'منطاد الهواء الساخن، جزيرة الموز، عشاء شعبي',
    accommodation: 'Luxor Nile Palace Hotel',
    timeline: [
      { time: '٥:٠٠ ص', aiTip: true, category: 'activity', title: 'رحلة منطاد الهواء الساخن', desc: 'شاهد شروق الشمس على معابد الأقصر ووادي الملوك من ارتفاع شاهق، تجربة لا تُنسى.', photos: '٦٠ صورة من فسحني', duration: 'ساعة', priceValue: 1500, img: 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?w=300&q=80' },
      { time: '١١:٠٠ ص', aiTip: false, category: 'activity', title: 'جزيرة الموز', desc: 'جولة بالمركب الشراعي (فلوكة) على النيل وزيارة مزارع الموز والحدائق الاستوائية.', photos: '١٥ صورة من فسحني', duration: 'ساعتان', priceValue: 180, img: 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=300&q=80' },
      { time: '٧:٣٠ م', aiTip: false, category: 'food', title: 'عشاء شعبي في قرية محلية', desc: 'تجربة أصيلة لتذوق الأكل الشعبي المصري وسط عائلة نوبية مضيافة.', photos: '١٠ صور من فسحني', duration: 'ساعتان', priceValue: 220, img: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=300&q=80' },
    ],
  },
])

const initialDayCount = computed(() => Math.min(3, numDays.value))
const extraDaysCount = computed(() => Math.max(0, numDays.value - initialDayCount.value))
const showAllDays = ref(false)
const visibleDays = computed(() =>
  showAllDays.value ? days.value.slice(0, numDays.value) : days.value.slice(0, initialDayCount.value)
)

const revealRemainingDays = () => {
  showAllDays.value = !showAllDays.value
  if (showAllDays.value && days.value.length < numDays.value) {
    // TODO: fetch days beyond day 3 from backend, e.g. api.get(`/trip-plans/${planId}/days`)
    for (let n = days.value.length + 1; n <= numDays.value; n++) {
      days.value.push({
        num: n,
        title: `اليوم ${toArabicDigits(n)}`,
        subtitle: 'تفاصيل هذا اليوم قيد التحضير...',
        accommodation: null,
        timeline: [],
      })
    }
  }
}

const expandedDay = ref(1)
const loadingDay = ref(null)
const toggleDay = async (day) => {
  if (expandedDay.value === day.num) {
    expandedDay.value = 0
    return
  }
  expandedDay.value = day.num
  if (day.timeline.length === 0) {
    loadingDay.value = day.num
    // TODO: fetch this day's real itinerary from backend
    await new Promise((resolve) => setTimeout(resolve, 600))
    loadingDay.value = null
  }
}

/* ---------------- Editing an activity ---------------- */
const editingActivity = ref(null) // { dayNum, idx }
const editForm = ref({ title: '', desc: '', time: '', priceValue: 0 })

const startEditActivity = (day, item, idx) => {
  editingActivity.value = { dayNum: day.num, idx }
  editForm.value = { title: item.title, desc: item.desc, time: item.time, priceValue: item.priceValue }
}
const cancelEditActivity = () => {
  editingActivity.value = null
}
const saveEditActivity = (day, idx) => {
  const item = day.timeline[idx]
  item.title = editForm.value.title
  item.desc = editForm.value.desc
  item.time = editForm.value.time
  item.priceValue = Number(editForm.value.priceValue) || 0
  editingActivity.value = null
  // TODO: persist activity edit to backend, e.g. api.patch(`/trip-plans/${planId}/days/${day.num}/items/${idx}`, item)
  showToast('تم تحديث النشاط')
}

const bookAccommodation = (day) => {
  showToast('جاري تحويلك لحجز الإقامة...')
  router.push('/book-trip')
}

/* ---------------- Cost calculations (real, based on selections) ---------------- */
const nights = computed(() => Math.max(0, numDays.value - 1))

const accommodationTotal = computed(() => accommodationPricePerNight.value * nights.value)
const transportTotal = computed(() => transportPrice.value)

const loadedTimelineItems = computed(() => days.value.flatMap((d) => d.timeline))
const foodTotal = computed(() =>
  loadedTimelineItems.value.filter((i) => i.category === 'food').reduce((sum, i) => sum + i.priceValue, 0)
)
const activitiesTotal = computed(() =>
  loadedTimelineItems.value.filter((i) => i.category === 'activity').reduce((sum, i) => sum + i.priceValue, 0)
)

const budgetStats = computed(() => [
  { label: 'الطعام', value: formatEGP(foodTotal.value) },
  { label: 'المواصلات', value: formatEGP(transportTotal.value) },
  { label: 'الأنشطة', value: formatEGP(activitiesTotal.value) },
  { label: 'الإقامة', value: formatEGP(accommodationTotal.value) },
])

const estimatedTotalValue = computed(
  () => accommodationTotal.value + transportTotal.value + foodTotal.value + activitiesTotal.value
)
const estimatedTotal = computed(() => formatEGP(estimatedTotalValue.value))

const plannedBudgetValue = computed(() => dailyBudget.value * numDays.value)
const budgetUsedPercent = computed(() => {
  if (plannedBudgetValue.value === 0) return 0
  return Math.min(100, Math.round((estimatedTotalValue.value / plannedBudgetValue.value) * 100))
})

/* ---------------- Header actions ---------------- */
const isSaved = ref(false)
const savePlan = () => {
  // TODO: persist trip plan to backend / user account
  isSaved.value = !isSaved.value
  showToast(isSaved.value ? 'تم حفظ المسار' : 'تم إلغاء الحفظ')
}

const shareItinerary = async () => {
  const url = window.location.href
  if (navigator.share) {
    try {
      await navigator.share({ title: 'خطة رحلتي في مصر', url })
    } catch (e) {
      /* user cancelled share, ignore */
    }
  } else if (navigator.clipboard) {
    await navigator.clipboard.writeText(url)
    showToast('تم نسخ الرابط')
  }
}

const downloadItinerary = () => {
  // TODO: replace with real PDF export endpoint, e.g. window.open(`/api/trip-plans/${planId}/export`)
  showToast('جاري تجهيز ملف الخطة...')
  window.print()
}

/* ---------------- Booking ---------------- */
const confirmBooking = () => {
  showToast('جاري تحويلك لصفحة الدفع...')
  router.push('/payment')
}
</script>

<template>
  <div dir="rtl" class="min-h-screen bg-[#FAFAF8] pb-28">
    <Navbar />

    <!-- Toast -->
    <Transition name="fade">
      <div v-if="toastMessage"
        class="fixed top-20 left-1/2 -translate-x-1/2 z-50 bg-[#1A3C5E] text-white text-sm px-5 py-3 rounded-full shadow-lg">
        {{ toastMessage }}
      </div>
    </Transition>

    <!-- Page Header -->
    <div class="pt-18">
      <div class="bg-[#F5ECD7] border-b border-[#D0C5B2] py-12 px-6">
        <div class="max-w-348 mx-auto text-right">
          <p class="text-sm font-semibold text-[#C9A84C] mb-2 flex items-center gap-1.5 justify-end">
            <span>خطط رحلتك</span>
            <svg class="w-3 h-3 -scale-x-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
            <button @click="router.push('/')" class="text-[#7E7665] font-medium hover:text-[#1A3C5E]">الرئيسية</button>
          </p>
          <h1 class="text-[40px] leading-12 font-bold text-[#1A3C5E] mb-2">مساعد رحلة الذكي</h1>
          <p class="text-lg text-[#4D4637] mb-6">يعمل خطتك الكاملة في ثوان — من الطيران للفطار.</p>

          <!-- Planning mode switcher -->
          <div class="flex justify-center">
            <div class="inline-flex items-center bg-white border border-[#D0C5B2] rounded-full p-1.5 shadow-sm">
              <button @click="router.push('/book-trip')"
                class="flex items-center gap-2 px-5 py-2.5 rounded-full text-sm font-semibold text-[#4D4637] hover:text-[#1A3C5E] transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/></svg>
                حجز يدوي
              </button>
              <button type="button" disabled
                class="flex items-center gap-2 bg-linear-to-l from-[#C9A84C] to-[#dcbf6d] text-white shadow px-5 py-2.5 rounded-full text-sm font-semibold cursor-default">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"/></svg>
                خطط بالذكاء الاصطناعي
                <span class="text-[9px] bg-white/25 px-1.5 py-0.5 rounded-full font-bold">AI</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Step Indicator -->
      <div class="max-w-348 mx-auto px-6 -mt-8.25 relative z-10">
        <div class="bg-white border border-[#D0C5B2] shadow-sm rounded-xl flex flex-col md:flex-row items-center justify-between gap-4 py-4 px-4">
          <button @click="goToPrevStep" :disabled="currentStep === 1"
            class="flex items-center gap-1.5 text-sm font-semibold px-3 py-2 rounded-lg transition-colors shrink-0"
            :class="currentStep === 1 ? 'text-[#D0C5B2] cursor-not-allowed' : 'text-[#1A3C5E] hover:bg-[#F4F4F2]'">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
            السابق
          </button>

          <div class="flex items-center justify-center gap-8 md:gap-12 overflow-x-auto">
            <template v-for="(step, i) in steps" :key="step.id">
              <button @click="goToStep(step.id)" :disabled="step.id > maxReachedStep"
                class="flex items-center gap-3 shrink-0" :class="step.id > maxReachedStep ? 'cursor-not-allowed opacity-60' : ''">
                <span :class="step.id === currentStep ? 'text-[#1A3C5E] font-bold' : 'text-[#7E7665]'" class="text-base">
                  {{ step.label }}
                </span>
                <div v-if="step.id < currentStep"
                  class="w-8 h-8 rounded-full bg-[#755B00] border-2 border-[#755B00] flex items-center justify-center">
                  <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
                </div>
                <div v-else-if="step.id === currentStep"
                  class="w-8 h-8 rounded-full bg-[#C9A84C] border-2 border-[#C9A84C] flex items-center justify-center text-white font-bold text-base">
                  {{ step.id }}
                </div>
                <div v-else
                  class="w-8 h-8 rounded-full border-2 border-[#D0C5B2] flex items-center justify-center text-[#7E7665] font-bold text-base">
                  {{ step.id }}
                </div>
              </button>
              <div v-if="i < steps.length - 1" class="w-12 h-0.5 shrink-0"
                :class="step.id < currentStep ? 'bg-[#755B00]' : 'bg-[#D0C5B2]'"></div>
            </template>
          </div>

          <button @click="goToNextStep" :disabled="currentStep === steps.length"
            class="flex items-center gap-1.5 text-sm font-semibold px-3 py-2 rounded-lg transition-colors shrink-0"
            :class="currentStep === steps.length ? 'text-[#D0C5B2] cursor-not-allowed' : 'text-white bg-[#C9A84C] hover:bg-[#b8963f]'">
            التالي
            <svg class="w-4 h-4 -scale-x-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
          </button>
        </div>
      </div>
    </div>

    <div class="max-w-348 mx-auto px-6 py-10">

      <!-- ============ STEP 1: destination & duration ============ -->
      <div v-if="currentStep === 1" class="max-w-2xl mx-auto bg-white border border-[#D0C5B2] rounded-2xl p-8 flex flex-col gap-8">
        <div class="flex flex-col gap-4">
          <h3 class="text-2xl font-semibold text-[#1A3C5E] text-right">المدن اللي هتزورها</h3>
          <div class="flex items-center gap-2 flex-wrap justify-end">
            <span v-for="city in selectedCities" :key="city"
              class="flex items-center gap-2 bg-[#F4F4F2] border border-[#D0C5B2] text-[#1A1C1B] px-4 py-2 rounded-lg text-base">
              <button @click="removeCity(city)" class="text-[#C9A84C]">
                <svg class="w-2.5 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
              </button>
              {{ city }}
            </span>
            <span v-if="selectedCities.length === 0" class="text-sm text-[#7E7665]">لم تختر أي مدينة بعد</span>
          </div>
          <div class="flex items-center gap-2">
            <button @click="addCity" class="bg-[#C9A84C] text-white text-sm px-5 py-2.5 rounded-lg shrink-0">إضافة</button>
            <input v-model="newCityInput" @keyup.enter="addCity" type="text" placeholder="اكتب اسم مدينة..."
              class="flex-1 border border-[#D0C5B2] rounded-lg px-3 py-2.5 text-sm text-right focus:outline-none focus:border-[#C9A84C]" />
          </div>
        </div>

        <div class="flex flex-col gap-4">
          <h3 class="text-2xl font-semibold text-[#1A3C5E] text-right">مدة الرحلة</h3>
          <div class="flex items-center justify-center gap-6">
            <button @click="increaseDays" class="w-11 h-11 rounded-full border border-[#D0C5B2] text-[#1A3C5E] text-xl flex items-center justify-center hover:bg-[#F4F4F2]">+</button>
            <span class="text-2xl font-bold text-[#1A3C5E] w-24 text-center">{{ toArabicDigits(numDays) }} أيام</span>
            <button @click="decreaseDays" class="w-11 h-11 rounded-full border border-[#D0C5B2] text-[#1A3C5E] text-xl flex items-center justify-center hover:bg-[#F4F4F2]">-</button>
          </div>
        </div>

        <div class="flex flex-col gap-4">
          <h3 class="text-2xl font-semibold text-[#1A3C5E] text-right">تاريخ البدء</h3>
          <input v-model="dateInput" @change="onDateChange" type="date"
            class="w-full border border-[#D0C5B2] rounded-lg px-4 py-3 text-base text-right focus:outline-none focus:border-[#C9A84C]" />
        </div>

        <button @click="goToNextStep"
          class="w-full bg-[#C9A84C] hover:bg-[#b8963f] text-white font-semibold py-3.5 rounded-xl transition-colors">
          التالي: التفضيلات
        </button>
      </div>

      <!-- ============ STEP 2: preferences ============ -->
      <div v-else-if="currentStep === 2" class="max-w-2xl mx-auto bg-white border border-[#D0C5B2] rounded-2xl p-8 flex flex-col gap-8">

        <div class="flex flex-col gap-4">
          <h3 class="text-2xl font-semibold text-[#1A3C5E] text-right">نوع الرحلة</h3>
          <div class="grid grid-cols-2 gap-3">
            <button v-for="type in tripTypes" :key="type.id" @click="selectedTripType = type.id"
              :class="selectedTripType === type.id
                ? 'border-2 border-[#C9A84C] bg-[#C9A84C]/10 text-[#503D00] font-bold'
                : 'border border-[#D0C5B2] text-[#1A1C1B]'"
              class="flex flex-col items-center justify-center gap-2 rounded-xl py-4 text-sm transition-colors">
              <svg class="w-5 h-5" :class="selectedTripType === type.id ? 'text-[#C9A84C]' : 'text-[#7E7665]'" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v18m9-9H3"/></svg>
              {{ type.label }}
            </button>
          </div>
        </div>

        <div class="flex flex-col gap-4">
          <h3 class="text-2xl font-semibold text-[#1A3C5E] text-right">مكان الإقامة المفضل</h3>
          <div class="flex flex-col gap-2">
            <button v-for="opt in accommodationOptions" :key="opt.id" @click="selectedAccommodation = opt.id"
              :class="selectedAccommodation === opt.id
                ? 'border-2 border-[#C9A84C] bg-[#C9A84C]/10'
                : 'border border-[#D0C5B2]'"
              class="w-full flex items-center justify-between px-4 py-3 rounded-lg cursor-pointer transition-colors">
              <span class="w-5 h-5 rounded-full border flex items-center justify-center shrink-0"
                :class="selectedAccommodation === opt.id ? 'border-[#C9A84C] bg-[#C9A84C]' : 'border-[#D0C5B2] bg-white'">
                <span v-if="selectedAccommodation === opt.id" class="w-2 h-2 rounded-full bg-white"></span>
              </span>
              <span :class="selectedAccommodation === opt.id ? 'font-semibold text-[#1A3C5E]' : 'text-[#1A1C1B]'">{{ opt.label }}</span>
            </button>
          </div>
        </div>

        <div class="flex flex-col gap-4">
          <div class="flex items-center justify-between">
            <span class="font-bold text-[#C9A84C]">{{ toArabicDigits(Number(dailyBudget).toLocaleString('en-US')) }} ج.م</span>
            <h3 class="text-2xl font-semibold text-[#1A3C5E]">الميزانية اليومية</h3>
          </div>
          <input type="range" min="500" max="10000" step="100" v-model="dailyBudget"
            class="w-full accent-[#C9A84C]" />
          <div class="flex items-center justify-between text-xs text-[#7E7665]">
            <span>١٠,٠٠٠ ج.م+</span>
            <span>٥٠٠ ج.م</span>
          </div>
        </div>

        <div class="flex flex-col gap-4">
          <h3 class="text-2xl font-semibold text-[#1A3C5E] text-right">وسيلة المواصلات</h3>
          <div class="flex items-center gap-2 flex-wrap justify-end">
            <button v-for="t in transportOptions" :key="t.id" @click="selectedTransport = t.id"
              :class="selectedTransport === t.id
                ? 'bg-[#C9A84C] border-2 border-[#C9A84C] text-white font-semibold shadow'
                : 'border border-[#D0C5B2] text-[#7E7665]'"
              class="px-4 py-2.5 rounded-full text-base transition-colors">
              {{ t.label }}
            </button>
          </div>
        </div>

        <div class="flex flex-col gap-4">
          <h3 class="text-2xl font-semibold text-[#1A3C5E] text-right">تفضيلات الطعام</h3>
          <div class="flex items-center gap-2 flex-wrap justify-end">
            <button v-for="tag in foodTagOptions" :key="tag" @click="toggleFoodTag(tag)"
              :class="selectedFoodTags.includes(tag)
                ? 'bg-[#B4D4FE]/40 border-[#B4D4FE] text-[#1A3C5E]'
                : 'bg-transparent border-[#D0C5B2] text-[#7E7665]'"
              class="border text-xs font-semibold px-3 py-1.5 rounded-full transition-colors">
              {{ tag }}
            </button>
          </div>
        </div>

        <button @click="goToNextStep(); generatePlan()" :disabled="isGenerating"
          class="w-full bg-[#C9A84C] hover:bg-[#b8963f] disabled:opacity-70 text-white font-semibold py-3.5 rounded-xl flex items-center justify-center gap-3 transition-colors">
          <svg v-if="isGenerating" class="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"/></svg>
          <template v-else>
            بناء الخطة بالذكاء الاصطناعي
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"/></svg>
          </template>
        </button>
      </div>

      <!-- ============ STEP 3: review ============ -->
      <div v-else class="flex flex-col lg:flex-row gap-8 items-start">

        <!-- Plan Content -->
        <div class="flex-1 w-full flex flex-col gap-8 order-2 lg:order-1">

          <!-- Plan Header Actions -->
          <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <div class="flex items-center gap-2 flex-wrap">
              <button @click="savePlan"
                :class="isSaved ? 'bg-[#755B00]' : 'bg-[#1A3C5E] hover:bg-[#152f4a]'"
                class="flex items-center gap-2 text-white px-4 py-3 rounded-lg text-base transition-colors">
                {{ isSaved ? 'تم حفظ المسار' : 'حفظ المسار' }}
                <svg v-if="!isSaved" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-6 0V4a1 1 0 011-1h4a1 1 0 011 1v3m-6 0h6"/></svg>
                <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
              </button>
              <button @click="downloadItinerary" title="تحميل الخطة"
                class="border border-[#D0C5B2] text-[#1A3C5E] w-11 h-11 rounded-lg flex items-center justify-center hover:bg-[#F4F4F2] transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H8a2 2 0 01-2-2V5a2 2 0 012-2h4l6 6v9a2 2 0 01-2 2z"/></svg>
              </button>
              <button @click="shareItinerary" title="مشاركة الخطة"
                class="border border-[#D0C5B2] text-[#1A3C5E] w-11 h-11 rounded-lg flex items-center justify-center hover:bg-[#F4F4F2] transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"/></svg>
              </button>
              <button @click="router.push('/community')"
                class="flex items-center gap-2 border border-[#C9A84C] text-[#C9A84C] px-4 py-3 rounded-lg text-base hover:bg-[#C9A84C]/10 transition-colors">
                شوف لحظات من فسحني
                <svg class="w-3.5 h-3.5 -scale-x-100" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
              </button>
            </div>
            <div class="text-right">
              <h2 class="text-[32px] leading-10.5 font-semibold text-[#1A3C5E]">خطتك لـ {{ toArabicDigits(numDays) }} أيام في مصر</h2>
              <p class="text-base text-[#7E7665]">تاريخ البدء المتوقع: {{ tripStartDate }}</p>
            </div>
          </div>

          <!-- Budget Summary Card -->
          <div class="bg-white border border-[#D0C5B2] rounded-2xl flex flex-col md:flex-row items-center justify-center gap-8 px-8 py-6">
            <div class="flex flex-col items-center gap-1 md:border-l md:border-[#D0C5B2]/30 md:pl-8 shrink-0">
              <div class="relative w-24 h-24">
                <svg class="w-24 h-24 -rotate-90" viewBox="0 0 96 96">
                  <circle cx="48" cy="48" r="40" fill="none" stroke="#E8E4DC" stroke-width="8" />
                  <circle cx="48" cy="48" r="40" fill="none" stroke="#C9A84C" stroke-width="8"
                    stroke-linecap="round"
                    :stroke-dasharray="`${2 * Math.PI * 40}`"
                    :stroke-dashoffset="`${2 * Math.PI * 40 * (1 - budgetUsedPercent / 100)}`" />
                </svg>
                <div class="absolute inset-0 flex flex-col items-center justify-center">
                  <span class="text-sm font-bold text-[#1A1C1B]">%{{ toArabicDigits(budgetUsedPercent) }}</span>
                  <span class="text-[10px] text-[#7E7665]">الميزانية</span>
                </div>
              </div>
              <p class="text-xs text-[#7E7665] text-center mt-2 w-40">من إجمالي ميزانيتك المحددة ({{ formatEGP(plannedBudgetValue) }})</p>
            </div>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 flex-1 w-full">
              <div v-for="stat in budgetStats" :key="stat.label" class="bg-[#F4F4F2] rounded-xl py-8 px-4 flex flex-col items-end gap-1">
                <span class="text-xs text-[#7E7665]">{{ stat.label }}</span>
                <span class="text-xl text-[#1A3C5E]">{{ stat.value }}</span>
              </div>
            </div>
          </div>

          <!-- Day-by-Day Accordion -->
          <div class="w-full flex flex-col gap-4">
            <div v-for="day in visibleDays" :key="day.num"
              :class="expandedDay === day.num ? 'bg-white shadow-sm' : 'bg-white/80'"
              class="border border-[#D0C5B2] rounded-2xl overflow-hidden transition-colors">

              <button @click="toggleDay(day)" class="w-full flex items-center justify-between px-6 py-6"
                :class="expandedDay === day.num ? 'bg-[#F4F4F2]' : ''">
                <svg :class="expandedDay === day.num ? '' : 'rotate-180'"
                  class="w-3 h-2 transition-transform" :style="{ color: expandedDay === day.num ? '#1A3C5E' : '#7E7665' }"
                  fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M19 9l-7 7-7-7"/></svg>
                <div class="flex items-center gap-4">
                  <div class="text-right">
                    <p :class="expandedDay === day.num ? 'text-[#1A3C5E]' : 'text-[#7E7665]'" class="font-normal">{{ day.title }}</p>
                    <p :class="expandedDay === day.num ? 'text-[#7E7665]' : 'text-[#7E7665]/60'" class="text-sm">{{ day.subtitle }}</p>
                  </div>
                  <div class="w-12 h-12 rounded-full flex items-center justify-center font-semibold"
                    :class="expandedDay === day.num ? 'bg-[#C9A84C]/20 text-[#C9A84C]' : 'bg-[#EEEEEC] text-[#7E7665]'">
                    {{ toArabicDigits(day.num) }}
                  </div>
                </div>
              </button>

              <div v-if="expandedDay === day.num" class="p-6 flex flex-col gap-6">

                <div v-if="loadingDay === day.num" class="flex items-center justify-center gap-2 py-10 text-[#7E7665] text-sm">
                  <svg class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"/></svg>
                  جاري تحضير تفاصيل اليوم...
                </div>

                <template v-else>
                  <div v-if="day.timeline.length === 0" class="text-center text-sm text-[#7E7665] py-10">
                    لا توجد تفاصيل لهذا اليوم بعد.
                  </div>

                  <div v-for="(item, idx) in day.timeline" :key="idx" class="flex items-start gap-6">
                    <!-- Card / edit form -->
                    <div class="flex-1 pb-6">
                      <div v-if="editingActivity && editingActivity.dayNum === day.num && editingActivity.idx === idx"
                        class="bg-[#F9F9F7] border-2 border-[#C9A84C] rounded-xl p-4 flex flex-col gap-3">
                        <input v-model="editForm.title" type="text" placeholder="عنوان النشاط"
                          class="border border-[#D0C5B2] rounded-lg px-3 py-2 text-sm text-right focus:outline-none focus:border-[#C9A84C]" />
                        <textarea v-model="editForm.desc" rows="2" placeholder="الوصف"
                          class="border border-[#D0C5B2] rounded-lg px-3 py-2 text-sm text-right focus:outline-none focus:border-[#C9A84C] resize-none"></textarea>
                        <div class="flex items-center gap-3">
                          <div class="flex-1">
                            <label class="text-xs text-[#7E7665] block mb-1 text-right">الوقت</label>
                            <input v-model="editForm.time" type="text"
                              class="w-full border border-[#D0C5B2] rounded-lg px-3 py-2 text-sm text-right focus:outline-none focus:border-[#C9A84C]" />
                          </div>
                          <div class="flex-1">
                            <label class="text-xs text-[#7E7665] block mb-1 text-right">السعر (ج.م)</label>
                            <input v-model="editForm.priceValue" type="number" min="0"
                              class="w-full border border-[#D0C5B2] rounded-lg px-3 py-2 text-sm text-right focus:outline-none focus:border-[#C9A84C]" />
                          </div>
                        </div>
                        <div class="flex items-center gap-2 justify-end">
                          <button @click="cancelEditActivity" class="text-sm text-[#7E7665] px-4 py-2">إلغاء</button>
                          <button @click="saveEditActivity(day, idx)" class="bg-[#C9A84C] text-white text-sm font-semibold px-5 py-2 rounded-lg">حفظ التعديل</button>
                        </div>
                      </div>

                      <div v-else class="bg-[#F9F9F7] border border-[#D0C5B2] rounded-xl flex items-center gap-4 p-4">
                        <div class="flex-1 flex flex-col gap-1">
                          <div class="flex items-center justify-between">
                            <button @click="startEditActivity(day, item, idx)" class="flex items-center gap-1 text-[10px] text-[#7E7665] hover:text-[#1A3C5E]">
                              عدّل الخطة
                              <svg class="w-2 h-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                            </button>
                            <span v-if="item.aiTip" class="text-xs text-[#C9A84C] font-medium">نصيحة AI</span>
                          </div>
                          <h4 class="font-bold text-[#1A3C5E]">{{ item.title }}</h4>
                          <p class="text-sm text-[#4D4637]">{{ item.desc }}</p>
                          <div class="flex items-center gap-4 justify-end mt-1">
                            <span class="text-xs text-[#7E7665]">{{ formatEGP(item.priceValue) }}</span>
                            <span class="text-xs text-[#7E7665]">{{ item.duration }}</span>
                            <span class="text-xs text-[#C9A84C]">{{ item.photos }}</span>
                          </div>
                        </div>
                        <img :src="item.img" class="w-24 h-24 object-cover rounded-lg shrink-0" alt="" />
                      </div>
                    </div>
                    <!-- Timeline rail -->
                    <div class="flex flex-col items-center gap-2 pt-1 shrink-0 w-12">
                      <span class="text-sm font-bold text-[#C9A84C] whitespace-nowrap">{{ item.time }}</span>
                      <div class="flex-1 w-px bg-[#D0C5B2]"></div>
                      <div v-if="idx !== day.timeline.length - 1" class="w-2 h-2 rounded-full bg-[#C9A84C]"></div>
                    </div>
                  </div>

                  <!-- Accommodation highlight -->
                  <div v-if="day.accommodation" class="border-t border-dashed border-[#D0C5B2] pt-4 flex items-center justify-between flex-wrap gap-3">
                    <button @click="bookAccommodation(day)" class="border border-[#C9A84C] text-[#C9A84C] text-sm font-bold px-3 py-1.5 rounded-lg hover:bg-[#C9A84C] hover:text-white transition-colors">حجز الآن</button>
                    <div class="flex items-center gap-3">
                      <div class="text-right">
                        <p class="text-xs text-[#7E7665]">الإقامة المقترحة لليلة {{ toArabicDigits(day.num) }}</p>
                        <p class="font-bold text-[#1A3C5E]">{{ day.accommodation }}</p>
                      </div>
                    </div>
                  </div>
                </template>
              </div>
            </div>

            <!-- Expand remaining days -->
            <button v-if="extraDaysCount > 0 && !showAllDays" @click="revealRemainingDays" class="flex items-center justify-center gap-2 py-4 text-[#C9A84C] font-bold text-base">
              عرض باقي أيام الرحلة ({{ toArabicDigits(extraDaysCount) }} أيام أخرى)
              <svg class="w-3 h-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M19 9l-7 7-7-7"/></svg>
            </button>
            <button v-else-if="extraDaysCount > 0 && showAllDays" @click="showAllDays = false" class="flex items-center justify-center gap-2 py-4 text-[#C9A84C] font-bold text-base">
              إخفاء الأيام الإضافية
              <svg class="w-3 h-2 rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M19 9l-7 7-7-7"/></svg>
            </button>
          </div>
        </div>

        <!-- Aside: selections summary -->
        <aside class="w-full lg:w-90 bg-white border border-[#D0C5B2] rounded-xl p-6 flex flex-col gap-6 order-1 lg:order-2 lg:sticky lg:top-24">
          <div class="flex flex-col gap-3">
            <div class="flex items-center justify-between">
              <button @click="goToStep(1)" class="text-sm font-semibold text-[#C9A84C] hover:underline">تعديل</button>
              <h3 class="text-lg font-semibold text-[#1A3C5E]">الوجهة والمدة</h3>
            </div>
            <p class="text-sm text-[#4D4637] text-right">{{ selectedCities.join('، ') || 'لا توجد مدن محددة' }}</p>
            <p class="text-sm text-[#7E7665] text-right">{{ toArabicDigits(numDays) }} أيام • يبدأ {{ tripStartDate }}</p>
          </div>

          <div class="border-t border-[#D0C5B2]"></div>

          <div class="flex flex-col gap-3">
            <div class="flex items-center justify-between">
              <button @click="goToStep(2)" class="text-sm font-semibold text-[#C9A84C] hover:underline">تعديل</button>
              <h3 class="text-lg font-semibold text-[#1A3C5E]">التفضيلات</h3>
            </div>
            <div class="text-sm text-[#4D4637] text-right flex flex-col gap-1">
              <p>نوع الرحلة: {{ tripTypeLabel }}</p>
              <p>الإقامة: {{ accommodationLabel }}</p>
              <p>المواصلات: {{ transportLabel }}</p>
              <p>الميزانية اليومية: {{ formatEGP(dailyBudget) }}</p>
              <p v-if="selectedFoodTags.length">الطعام: {{ selectedFoodTags.join('، ') }}</p>
            </div>
          </div>

          <button @click="generatePlan" :disabled="isGenerating"
            class="w-full bg-[#C9A84C] hover:bg-[#b8963f] disabled:opacity-70 text-[#1A3C5E] font-semibold py-3 rounded-xl flex items-center justify-center gap-2 transition-colors">
            <svg v-if="isGenerating" class="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"/></svg>
            <template v-else>
              تحديث الخطة بالذكاء الاصطناعي
              <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"/></svg>
            </template>
          </button>
        </aside>
      </div>
    </div>

    <!-- Bottom Sticky Booking Bar (only visible when reviewing) -->
    <div v-if="currentStep === 3" class="fixed bottom-0 left-0 right-0 bg-white border-t border-[#D0C5B2] shadow-[0_-10px_30px_rgba(0,0,0,0.05)] px-6 py-4 z-40">
      <div class="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
        <div class="flex items-center gap-4">
          <button @click="confirmBooking"
            class="bg-[#C9A84C] hover:bg-[#b8963f] text-[#1A3C5E] font-semibold px-8 py-3 rounded-xl shadow-lg shadow-[#C9A84C]/30 transition-colors">
            احجز الرحلة بالكامل
          </button>
          <button @click="goToStep(1)" class="flex items-center gap-2 border border-[#C9A84C] text-[#C9A84C] font-bold px-6 py-3 rounded-xl hover:bg-[#C9A84C]/10 transition-colors">
            تعديل التواريخ
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
          </button>
        </div>
        <div class="flex items-center gap-8">
          <div class="text-right">
            <div class="flex items-center gap-1 justify-end text-xs text-[#4D4637]">
              <span>بناءً على تفضيلاتك</span>
              <svg class="w-2.5 h-2.5 text-[#C9A84C]" fill="currentColor" viewBox="0 0 20 20"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"/></svg>
            </div>
            <p class="text-[10px] text-[#7E7665]">تشمل الإقامة، الأنشطة، والمواصلات المحددة</p>
          </div>
          <span class="w-px h-10 bg-[#D0C5B2]"></span>
          <div class="text-right">
            <p class="text-xs text-[#7E7665]">التكلفة الإجمالية التقديرية</p>
            <p class="text-2xl text-[#1A3C5E]">{{ estimatedTotal }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>