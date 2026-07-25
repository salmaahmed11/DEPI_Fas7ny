<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import Navbar from '../components/Navbar.vue'

const router = useRouter()
const route = useRoute()
const cityName = computed(() => route.query.city || route.query.q || 'الأقصر')

/* =========================================================================
   DATA
   ========================================================================= */
const allHotels = ref([
  {
    id: 1, name: 'سونستا سانت جورج الأقصر', address: 'كورنيش النيل، الأقصر', distanceLabel: 'يبعد ٠.٥ كم عن معبد الأقصر',
    rating: 5, reviewCount: '٤٢٠', price: 3650, originalPrice: 4200, priceNote: null, stars: 5, category: 'hotel',
    tags: ['فطور عالمي', 'سبا متكامل', 'مسبح خارجي'], amenities: { wifi: true, parking: true, view: true },
    image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=700&q=80', featured: true, source: 'google',
  },
  {
    id: 2, name: 'فندق إيزيس كورنيش', address: 'كورنيش النيل، الأقصر', distanceLabel: '٣ نجوم • إطلالة جانبية على النيل',
    rating: 4.2, reviewCount: '٣٦٠', price: 1450, priceNote: 'شامل الضرائب', stars: 3, category: 'hotel',
    tags: ['مسبح', 'مكيف', 'واي فاي'], amenities: { wifi: true, parking: false, view: true },
    image: 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?w=500&q=80', featured: false,
  },
  {
    id: 3, name: 'نُزل ماريوت التقليدي', address: 'قريب جداً من معبد الكرنك', distanceLabel: 'بيت ضيافة • قريب جداً من معبد الكرنك',
    rating: 4.5, reviewCount: '٢١٠', price: 900, priceNote: 'أفضل سعر متاح', stars: 3, category: 'guesthouse',
    tags: ['إفطار', 'حديقة'], amenities: { wifi: true, parking: true, view: false },
    image: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500&q=80', featured: false,
  },
  {
    id: 4, name: 'فندق نيل فيو بوتيك', address: 'وسط الأقصر', distanceLabel: '٤ نجوم • تصميم عصري',
    rating: 4.4, reviewCount: '٥٥٠', price: 2800, priceNote: 'الحجز مرن', stars: 4, category: 'hotel',
    tags: ['تصميم عصري', 'مطعم'], amenities: { wifi: true, parking: true, view: true },
    image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=80', featured: false,
  },
  {
    id: 5, name: 'موفنبيك جزيرة النخيل', address: 'جزيرة البلينا، الأقصر', distanceLabel: '٥ نجوم • منتجع متكامل',
    rating: 4.7, reviewCount: '٦٧٠', price: 1600, priceNote: null, stars: 5, category: 'resort',
    tags: ['مسبح', 'شاطئ خاص'], amenities: { wifi: true, parking: true, view: true },
    image: 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=500&q=80', featured: false,
  },
  {
    id: 6, name: 'أولد كتراكت أسوان ستايل', address: 'كورنيش الأقصر', distanceLabel: '٥ نجوم • تراثي فاخر',
    rating: 4.9, reviewCount: '٨١٠', price: 2200, priceNote: null, stars: 5, category: 'hotel',
    tags: ['تراثي', 'سبا'], amenities: { wifi: true, parking: false, view: true },
    image: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=500&q=80', featured: false,
  },
])

/* =========================================================================
   SEARCH + QUICK FILTER CHIPS
   ========================================================================= */
const searchQuery = ref(`فنادق ${cityName.value} قريبة من معابد`)

const quickChips = ref([
  { id: 'near', label: `قريب من معبد ${cityName.value}`, active: true, primary: true },
  { id: 'view', label: 'إطلالة نيلية', active: false },
  { id: 'pool', label: 'حمامات سباحة', active: false },
  { id: 'breakfast', label: 'فطور مجاني', active: false },
  { id: 'stars4', label: '+٤ نجوم', active: false },
])
const toggleChip = (chip) => (chip.active = !chip.active)

/* =========================================================================
   SIDEBAR FILTERS
   ========================================================================= */
const category = ref('hotel')
const minRating = ref(0)
const priceMin = ref(500)
const priceMax = ref(5000)
const landmark = ref('معبد الأقصر')
const amenityFilters = ref({ wifi: true, parking: false, view: true })

const filteredHotels = computed(() =>
  allHotels.value.filter((h) => {
    if (category.value && h.category !== category.value) return false
    if (minRating.value && h.stars < minRating.value) return false
    if (h.price < priceMin.value || h.price > priceMax.value) return false
    if (amenityFilters.value.wifi && !h.amenities.wifi) return false
    if (amenityFilters.value.parking && !h.amenities.parking) return false
    if (amenityFilters.value.view && !h.amenities.view) return false
    if (quickChips.value.find((c) => c.id === 'stars4' && c.active) && h.stars < 4) return false
    if (quickChips.value.find((c) => c.id === 'view' && c.active) && !h.amenities.view) return false
    if (quickChips.value.find((c) => c.id === 'pool' && c.active) && !h.tags.some((t) => t.includes('مسبح'))) return false
    return true
  })
)

const featured = computed(() => filteredHotels.value.find((h) => h.featured) || filteredHotels.value[0])
const regularList = computed(() => filteredHotels.value.filter((h) => h.id !== featured.value?.id))

const visibleCount = ref(3)
const visibleRegular = computed(() => regularList.value.slice(0, visibleCount.value))
const loadMore = () => (visibleCount.value += 3)

const clearAll = () => {
  category.value = 'hotel'
  minRating.value = 0
  priceMin.value = 500
  priceMax.value = 5000
  amenityFilters.value = { wifi: false, parking: false, view: false }
  quickChips.value.forEach((c) => (c.active = c.id === 'near'))
}

const viewMode = ref('list') // 'list' | 'map'
const goToHotel = (hotel) => router.push(`/hotel/${encodeURIComponent(cityName.value)}/${hotel.id}`)
const goToMap = () => router.push({ path: '/map', query: { city: cityName.value } })

/* ---------------- AI suggestion ---------------- */
const aiSuggestion = `فنادق على كورنيش ${cityName.value} أقرب للمعابد وأحسن في التقييم`
const applySuggestion = () => {
  searchQuery.value = aiSuggestion
  quickChips.value.forEach((c) => (c.active = c.id === 'near' || c.id === 'stars4'))
}
</script>

<template>
  <div dir="rtl" class="min-h-screen bg-[#F9F9F7]">
    <Navbar />

    <!-- Search header -->
    <div class="sticky top-18 z-20 bg-white border-b border-[#D0C5B2] px-6 py-8 flex flex-col items-center gap-6">
      <div class="relative w-full max-w-6xl">
        <input v-model="searchQuery" type="text"
          class="w-full bg-[#F9F9F7] border-2 border-[#755B00] rounded-xl py-4 pr-6 pl-14 text-lg text-right focus:outline-none" />
        <button class="absolute left-5 top-1/2 -translate-y-1/2 text-[#755B00]">
          <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
        </button>
        <button class="absolute right-5 top-1/2 -translate-y-1/2 text-[#7E7665]">
          <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h18M6 8h12M9 12h6M11 16h2"/></svg>
        </button>
      </div>

      <div class="flex items-center justify-center gap-3 flex-wrap">
        <button v-for="chip in quickChips" :key="chip.id" @click="toggleChip(chip)"
          :class="chip.active
            ? 'bg-[#C9A84C] border-[#755B00] text-[#503D00]'
            : 'bg-[#EEEEEC] border-[#D0C5B2] text-[#1A1C1B] hover:bg-[#E4E4E0]'"
          class="border rounded-full px-4 py-2 text-sm font-medium flex items-center gap-1.5 transition-colors">
          {{ chip.label }}
          <svg v-if="chip.active" class="w-2.5 h-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12"/></svg>
        </button>
      </div>
    </div>

    <!-- AI suggestion bar -->
    <div class="bg-[#FFE08F]/30 border-b border-[#755B00]/20 py-3 px-6 flex items-center justify-center gap-3 text-sm">
      <button @click="applySuggestion" class="font-semibold text-[#241A00] underline">اعرض الاقتراح</button>
      <span class="text-[#241A00]">—</span>
      <span class="font-semibold text-[#241A00]">{{ aiSuggestion }}</span>
      <span class="text-[#241A00]">رحلة AI اقترح:</span>
      <svg class="w-5 h-4.5 text-[#755B00]" fill="currentColor" viewBox="0 0 20 20"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"/></svg>
    </div>

    <!-- Main content -->
    <div class="max-w-360 mx-auto px-6 py-8 grid grid-cols-1 lg:grid-cols-[300px_1fr] gap-8 items-start">

      <!-- Filters sidebar -->
      <aside class="w-full flex flex-col gap-8 order-2 lg:order-1">
        <div class="flex items-center justify-between">
          <button @click="clearAll" class="text-sm font-semibold text-[#755B00]">مسح الكل</button>
          <h2 class="text-2xl font-semibold text-[#1A1C1B]">تصفية النتائج</h2>
        </div>

        <!-- Map preview -->
        <button @click="goToMap" class="relative h-42 border border-[#D0C5B2] rounded-xl overflow-hidden">
          <div class="absolute inset-0 opacity-60" :style="{ background: `linear-gradient(rgba(255,255,255,.5),rgba(255,255,255,.5)), url('${featured?.image}')`, backgroundBlendMode: 'saturation', backgroundSize: 'cover' }"></div>
          <div class="absolute inset-0 bg-[#1A1C1B]/20 flex items-center justify-center">
            <span class="bg-[#F9F9F7] shadow-lg rounded-lg px-4 py-2 text-sm font-semibold text-[#1A1C1B]">عرض على الخريطة</span>
          </div>
        </button>

        <!-- Category -->
        <div class="flex flex-col gap-3">
          <h3 class="text-base font-bold text-[#1A1C1B] text-right">فئة المكان</h3>
          <label v-for="opt in [{v:'hotel',l:'فنادق'},{v:'guesthouse',l:'بيوت ضيافة تراثية'},{v:'resort',l:'منتجعات'}]" :key="opt.v"
            class="flex items-center justify-end gap-2 cursor-pointer">
            <span class="text-base text-[#1A1C1B]">{{ opt.l }}</span>
            <input type="radio" :value="opt.v" v-model="category" class="w-5 h-5 accent-[#755B00]" />
          </label>
        </div>

        <!-- Rating -->
        <div class="flex flex-col gap-3">
          <h3 class="text-base font-bold text-[#1A1C1B] text-right">التقييم</h3>
          <div class="flex items-center justify-end gap-1">
            <span class="text-sm text-[#7E7665] ml-2">+{{ minRating || 0 }} نجوم</span>
            <button v-for="n in 5" :key="n" @click="minRating = minRating === n ? 0 : n">
              <svg class="w-5 h-5" :class="n <= minRating ? 'text-[#755B00]' : 'text-[#D0C5B2]'" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
            </button>
          </div>
        </div>

        <!-- Price -->
        <div class="flex flex-col gap-3">
          <h3 class="text-base font-bold text-[#1A1C1B] text-right">السعر / ليلة (EGP)</h3>
          <input v-model="priceMax" type="range" min="500" max="5000" step="100" class="w-full accent-[#755B00]" />
          <div class="flex items-center justify-between text-sm text-[#7E7665]">
            <span>{{ Number(priceMax).toLocaleString() }}+ ج.م</span>
            <span>٥٠٠ ج.م</span>
          </div>
        </div>

        <!-- Distance -->
        <div class="flex flex-col gap-3">
          <h3 class="text-base font-bold text-[#1A1C1B] text-right">المسافة من المعالم</h3>
          <select v-model="landmark" class="w-full bg-[#F9F9F7] border border-[#D0C5B2] rounded-lg px-3 py-2.5 text-right focus:outline-none">
            <option>معبد الأقصر</option>
            <option>معابد الكرنك</option>
            <option>وادي الملوك</option>
          </select>
        </div>

        <!-- Amenities -->
        <div class="flex flex-col gap-3">
          <h3 class="text-base font-bold text-[#1A1C1B] text-right">المرافق المطلوبة</h3>
          <label class="flex items-center justify-end gap-2 cursor-pointer">
            <span class="text-base text-[#1A1C1B]">واي فاي مجاني</span>
            <input type="checkbox" v-model="amenityFilters.wifi" class="w-5 h-5 rounded accent-[#755B00]" />
          </label>
          <label class="flex items-center justify-end gap-2 cursor-pointer">
            <span class="text-base text-[#1A1C1B]">موقف سيارات</span>
            <input type="checkbox" v-model="amenityFilters.parking" class="w-5 h-5 rounded accent-[#755B00]" />
          </label>
          <label class="flex items-center justify-end gap-2 cursor-pointer">
            <span class="text-base text-[#1A1C1B]">إطلالة مباشرة</span>
            <input type="checkbox" v-model="amenityFilters.view" class="w-5 h-5 rounded accent-[#755B00]" />
          </label>
        </div>
      </aside>

      <!-- Results -->
      <div class="flex flex-col gap-6 order-1 lg:order-2 min-w-0">

        <!-- Results header -->
        <div class="flex items-center justify-between">
          <div class="flex items-center bg-[#EEEEEC] rounded-lg p-1 gap-1">
            <button @click="viewMode = 'list'" :class="viewMode === 'list' ? 'bg-white shadow-sm text-[#1A1C1B]' : 'text-[#7E7665]'" class="px-4 py-1.5 rounded-md text-sm font-semibold">قائمة</button>
            <button @click="goToMap" :class="viewMode === 'map' ? 'bg-white shadow-sm text-[#1A1C1B]' : 'text-[#7E7665]'" class="px-4 py-1.5 rounded-md text-sm font-semibold">خريطة</button>
          </div>
          <div class="flex items-center gap-2">
            <h1 class="text-2xl font-semibold text-[#1A1C1B]">{{ filteredHotels.length }} فندق في {{ cityName }}</h1>
            <button @click="clearAll" class="text-sm font-semibold text-[#755B00]">مسح الكل</button>
          </div>
        </div>

        <p v-if="!filteredHotels.length" class="text-center text-[#7E7665] py-16">لا توجد نتائج مطابقة لهذه الفلاتر. جرّب تعديل خيارات البحث.</p>

        <!-- Featured result -->
        <div v-if="featured" class="bg-white border-t-2 border-x border-b border-[#755B00] rounded-2xl overflow-hidden pt-2">
          <div class="flex flex-col md:flex-row items-stretch">
            <div class="flex-1 p-6 flex flex-col justify-between gap-4">
              <div class="flex flex-col gap-2">
                <div class="flex items-center justify-between">
                  <div class="flex items-center gap-1">
                    <svg v-for="n in 5" :key="n" class="w-3.5 h-3.5" :class="n <= featured.rating ? 'text-[#755B00]' : 'text-[#D0C5B2]'" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                    <span class="text-sm text-[#7E7665] mr-1">{{ featured.reviewCount }} تقييم</span>
                  </div>
                  <h3 class="text-2xl font-semibold text-[#1A1C1B]">{{ featured.name }}</h3>
                </div>
                <div class="flex items-center justify-end gap-1 text-base text-[#7E7665]">
                  <span>{{ featured.address }} - {{ featured.distanceLabel }}</span>
                  <svg class="w-4 h-4 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd"/></svg>
                </div>
                <div class="flex items-center justify-end gap-4 pt-2">
                  <span v-for="tag in featured.tags" :key="tag" class="bg-[#EEEEEC] text-sm font-semibold text-[#1A1C1B] px-4 py-1.5 rounded">{{ tag }}</span>
                </div>
              </div>

              <div class="flex items-center justify-between">
                <button @click="goToHotel(featured)" class="bg-[#755B00] hover:bg-[#5f4a00] text-white font-semibold px-8 py-2.5 rounded-xl transition-colors">احجز الآن</button>
                <div class="flex items-center gap-2 text-[#C9A84C] font-medium text-lg">google</div>
                <div class="text-right">
                  <span v-if="featured.originalPrice" class="text-sm text-[#D0C5B2] line-through ml-2">{{ featured.originalPrice.toLocaleString() }} ج.م</span>
                  <span class="text-2xl font-semibold text-[#755B00]">{{ featured.price.toLocaleString() }} ج.م</span>
                  <span class="text-sm text-[#1A1C1B]"> / ليلة</span>
                </div>
              </div>
            </div>
            <div class="relative w-full md:w-72 h-56 md:h-auto shrink-0">
              <img :src="featured.image" class="w-full h-full object-cover" :alt="featured.name" />
              <span class="absolute top-4 right-4 bg-[#755B00] text-white text-[10px] font-semibold uppercase px-3 py-1.5 rounded-full">مُختار بواسطة رحلة</span>
            </div>
          </div>
        </div>

        <!-- Regular results -->
        <div class="flex flex-col gap-4">
          <div v-for="hotel in visibleRegular" :key="hotel.id" @click="goToHotel(hotel)"
            class="bg-white border border-[#D0C5B2] rounded-xl flex items-center gap-4 p-4 cursor-pointer hover:shadow-sm transition-shadow">
            <img :src="hotel.image" class="w-30 h-30 object-cover rounded-lg shrink-0" :alt="hotel.name" />
            <div class="flex-1 flex flex-col gap-1">
              <h4 class="text-lg text-[#1A1C1B] text-right">{{ hotel.name }}</h4>
              <p class="text-sm font-medium text-[#7E7665] text-right">{{ hotel.distanceLabel }}</p>
            </div>
            <div class="text-left shrink-0">
              <p class="text-lg font-semibold text-[#755B00]">{{ hotel.price.toLocaleString() }} ج.م</p>
              <p v-if="hotel.priceNote" class="text-[10px] text-[#7E7665]">{{ hotel.priceNote }}</p>
            </div>
          </div>
        </div>

        <!-- Load more -->
        <div v-if="visibleCount < regularList.length" class="flex justify-center pt-2">
          <button @click="loadMore"
            class="border-2 border-[#755B00] text-[#755B00] font-semibold px-12 py-4 rounded-xl flex items-center gap-3 hover:bg-[#755B00]/5 transition-colors">
            <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
            تحميل المزيد من النتائج
          </button>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer class="bg-[#0F172A] border-t border-[#1E293B] py-12 mt-8">
      <div class="max-w-7xl mx-auto px-6 flex flex-col items-center gap-8">
        <span class="text-2xl font-bold text-[#EAB308]">فسحني</span>
        <nav class="flex items-center gap-8 flex-wrap justify-center">
          <a href="#" class="text-xs text-[#94A3B8] hover:text-white">Sustainable Travel</a>
          <a href="#" class="text-xs text-[#94A3B8] hover:text-white">Contact Guide</a>
          <a href="#" class="text-xs text-[#94A3B8] hover:text-white">Terms of Service</a>
          <a href="#" class="text-xs text-[#94A3B8] hover:text-white">Privacy Policy</a>
        </nav>
        <p class="text-xs text-[#94A3B8]/60">© 2024 فسحني مصر. سحر لا يخبو.</p>
      </div>
    </footer>
  </div>
</template>