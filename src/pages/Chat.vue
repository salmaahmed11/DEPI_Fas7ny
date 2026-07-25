<script setup>
import { ref, nextTick, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

/* ---------------- Sidebar: conversation history ---------------- */
const conversations = ref([
  { id: 1, title: 'رحلة الأقصر ٧ أيام', active: true },
  { id: 2, title: 'استكشاف أهرامات الجيزة', active: false },
  { id: 3, title: 'مطاعم القاهرة القديمة', active: false },
])
const selectConversation = (c) => {
  conversations.value.forEach((x) => (x.active = x.id === c.id))
}
const newChat = () => {
  const id = Date.now()
  conversations.value.unshift({ id, title: 'محادثة جديدة', active: true })
  conversations.value.forEach((x) => (x.active = x.id === id))
  messages.value = []
}

/* ---------------- Hotel data for bento cards ---------------- */
const hotelPool = [
  { id: 101, name: 'فندق شتاينبرجر', rating: 4.5, reviews: '800', image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=80', badge: null },
  { id: 102, name: 'هيلتون الأقصر ريزورت', rating: 4.7, reviews: '950', image: 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=500&q=80', badge: { label: 'إطلالة النيل', bg: '#416084', color: '#fff' } },
  { id: 103, name: 'فندق وينتر بالاس', rating: 4.9, reviews: '1,200', image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500&q=80', badge: { label: 'الأعلى تقييماً', bg: '#C9A84C', color: '#503D00' } },
]

const goToHotel = (hotel) => {
  router.push(`/hotel/${encodeURIComponent('الأقصر')}/${hotel.id}`)
}

/* ---------------- Messages ---------------- */
const now = () => new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })

const messages = ref([
  { role: 'user', text: 'أبحث عن أفضل الفنادق للإقامة في الأقصر لمدة ٧ أيام، هل يمكنك مساعدتي؟', time: '10:30 AM' },
  {
    role: 'ai',
    text: 'بالطبع! لقد قمت بتحليل الخيارات المتاحة في الأقصر بناءً على تقييمات المسافرين والموقع التاريخي. إليك ٣ خيارات فنادق تناسب رحلتك:',
    hotels: hotelPool,
    time: '10:31 AM',
  },
])

const typing = ref(false)
const chatEnd = ref(null)
const scrollDown = () => nextTick(() => chatEnd.value?.scrollIntoView({ behavior: 'smooth' }))

const quickReplies = [
  'ما هي أفضل المطاعم هناك؟',
  'أريد جدول رحلات سياحية',
  'ابحث عن فنادق أرخص',
]

const canned = {
  'مطاعم': 'إليك بعض أفضل المطاعم المحلية القريبة من فندقك، تشمل مأكولات مصرية أصيلة وإطلالات على النيل. هل تفضل مطاعم فاخرة أم أسعار معقولة؟',
  'رحلات': 'يمكنني تجهيز جدول رحلات يومي متكامل يجمع بين المعابد الأثرية وجولات النيل. هل تفضل رحلة نشطة أم هادئة الإيقاع؟',
  'أرخص': 'إليك خيارات فنادق ذات تقييم جيد وأسعار أقل من ١٠٠٠ ج.م لليلة. أخبرني إذا كنت تفضل موقعاً محدداً في المدينة.',
}

const inputText = ref('')

const sendMessage = (text) => {
  const value = (text || inputText.value).trim()
  if (!value) return
  messages.value.push({ role: 'user', text: value, time: now() })
  inputText.value = ''
  scrollDown()

  typing.value = true
  scrollDown()
  setTimeout(() => {
    typing.value = false
    const key = Object.keys(canned).find((k) => value.includes(k))
    messages.value.push({
      role: 'ai',
      text: key ? canned[key] : 'تمام، سأجهز لك بعض الاقتراحات المناسبة بناءً على طلبك. هل يمكنك إخباري بالميزانية التقريبية والمدة؟',
      time: now(),
    })
    scrollDown()
  }, 1100)
}
</script>

<template>
  <div dir="rtl" class="h-screen w-full flex bg-[#F9F9F7] overflow-hidden">

    <!-- Main chat area -->
    <div class="flex-1 flex flex-col h-full min-w-0">

      <!-- Header -->
      <header class="h-20 bg-white border-b border-[#D0C5B2] flex items-center justify-between px-8 shrink-0">
        <button @click="router.back()" class="w-12 h-12 rounded-full bg-[#F5F2E8] border border-[#C9A84C] flex items-center justify-center">
          <svg class="w-4 h-4 text-[#C9A84C]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/></svg>
        </button>
        <div class="flex items-center gap-4">
          <div class="text-right">
            <h1 class="text-lg font-bold text-[#1A1C1B]">دليل الذكاء الاصطناعي</h1>
            <div class="flex items-center justify-end gap-1.5">
              <span class="text-xs text-[#7E7665]">متاح دائماً</span>
              <span class="w-2 h-2 rounded-full bg-[#10B981]"></span>
            </div>
          </div>
          <button class="w-8 h-8 rounded-xl flex items-center justify-center hover:bg-[#F4F4F2]">
            <svg class="w-4.5 h-4.5 text-[#7E7665]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
          </button>
          <button class="w-8 h-8 rounded-xl flex items-center justify-center hover:bg-[#F4F4F2]">
            <svg class="w-4 h-4 text-[#7E7665]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01"/></svg>
          </button>
        </div>
      </header>

      <!-- Messages -->
      <div class="flex-1 overflow-y-auto px-8 py-8 flex flex-col gap-8">

        <template v-for="(m, i) in messages" :key="i">

          <!-- User bubble -->
          <div v-if="m.role === 'user'" class="flex flex-col items-start gap-1 max-w-2xl">
            <div class="bg-[#416084] text-white rounded-2xl rounded-tl-none px-6 py-4 shadow-sm">
              <p class="text-base text-right">{{ m.text }}</p>
            </div>
            <span class="text-[10px] text-[#1A1C1B]/50 px-1">{{ m.time }}</span>
          </div>

          <!-- AI message -->
          <div v-else class="flex items-start justify-end gap-4 w-full">
            <div class="flex flex-col items-end gap-3 max-w-4xl flex-1">
              <div class="bg-white border border-[#D0C5B2] rounded-2xl rounded-tr-none px-6 py-4 shadow-sm w-full">
                <p class="text-base text-[#1A1C1B] text-right leading-6">{{ m.text }}</p>
              </div>

              <!-- Bento hotel cards -->
              <div v-if="m.hotels" class="grid grid-cols-1 sm:grid-cols-3 gap-4 w-full">
                <div v-for="hotel in m.hotels" :key="hotel.id"
                  class="bg-white border border-[#D0C5B2] rounded-xl overflow-hidden flex flex-col">
                  <div class="relative h-32">
                    <img :src="hotel.image" class="w-full h-full object-cover" :alt="hotel.name" />
                    <span v-if="hotel.badge" class="absolute top-2 right-2 text-[10px] font-semibold px-2 py-1 rounded-full"
                      :style="{ background: hotel.badge.bg, color: hotel.badge.color }">{{ hotel.badge.label }}</span>
                  </div>
                  <div class="p-4 flex flex-col gap-1">
                    <h3 class="text-base font-bold text-[#1A1C1B] text-right">{{ hotel.name }}</h3>
                    <div class="flex items-center justify-end gap-1 text-xs text-[#7E7665]">
                      <span>{{ hotel.rating }} ({{ hotel.reviews }} تقييم)</span>
                      <svg class="w-3 h-3 text-[#C9A84C]" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                    </div>
                    <button @click="goToHotel(hotel)"
                      class="mt-2 border border-[#C9A84C] text-[#C9A84C] text-xs font-semibold py-2 rounded-lg hover:bg-[#C9A84C]/5 transition-colors">
                      عرض التفاصيل
                    </button>
                  </div>
                </div>
              </div>

              <span class="text-[10px] text-[#1A1C1B]/50 px-1">{{ m.time }}</span>
            </div>
            <div class="w-10 h-10 rounded-full bg-[#C9A84C]/10 border border-[#C9A84C] flex items-center justify-center shrink-0">
              <svg class="w-4.5 h-4.5 text-[#C9A84C]" fill="currentColor" viewBox="0 0 20 20"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"/></svg>
            </div>
          </div>
        </template>

        <!-- Typing indicator -->
        <div v-if="typing" class="flex items-center justify-end gap-2">
          <div class="bg-white border border-[#D0C5B2] rounded-full px-6 py-2 flex items-center gap-1">
            <span v-for="n in 3" :key="n" class="w-1.5 h-1.5 rounded-full bg-[#D0C5B2] animate-bounce" :style="{ animationDelay: (n * 0.15) + 's' }"></span>
          </div>
          <div class="w-10 h-10 rounded-full bg-[#C9A84C]/10 border border-[#C9A84C] opacity-50 flex items-center justify-center shrink-0">
            <svg class="w-4.5 h-4.5 text-[#C9A84C]" fill="currentColor" viewBox="0 0 20 20"><path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z"/></svg>
          </div>
        </div>

        <div ref="chatEnd"></div>
      </div>

      <!-- Footer: suggestions + input -->
      <footer class="bg-[#F9F9F7] border-t border-[#D0C5B2] px-8 py-6 flex flex-col gap-6 shrink-0">
        <div class="flex items-center justify-end gap-4 flex-wrap">
          <button v-for="q in quickReplies" :key="q" @click="sendMessage(q)"
            class="bg-[#C9A84C]/10 border border-[#C9A84C]/20 text-[#C9A84C] text-sm font-semibold px-6 py-2 rounded-full hover:bg-[#C9A84C]/15 transition-colors">
            {{ q }}
          </button>
        </div>

        <div class="flex items-center gap-4">
          <button @click="sendMessage()"
            class="w-14 h-14 rounded-full bg-[#C9A84C] hover:bg-[#b8963f] flex items-center justify-center shrink-0 shadow-[0_10px_15px_-3px_rgba(201,168,76,0.2),0_4px_6px_-4px_rgba(201,168,76,0.2)] transition-colors">
            <svg class="w-5 h-5 text-[#503D00] -rotate-90" fill="currentColor" viewBox="0 0 20 20"><path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z"/></svg>
          </button>
          <div class="flex-1 flex items-center gap-4 bg-[#F4F4F2] border border-[#D0C5B2] rounded-2xl px-6 py-4">
            <button class="text-[#7E7665] shrink-0">
              <svg class="w-4 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18.5a4 4 0 004-4V6a3 3 0 10-6 0v8a2 2 0 004 0V7"/></svg>
            </button>
            <input v-model="inputText" @keyup.enter="sendMessage()" type="text" placeholder="اكتب سؤالك هنا..."
              class="flex-1 bg-transparent text-base text-right focus:outline-none placeholder:text-[#7E7665]/50" />
            <button class="text-[#7E7665] shrink-0">
              <svg class="w-4.5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21.44 11.05l-9.19 9.19a5 5 0 01-7.07-7.07l9.19-9.19a3.5 3.5 0 014.95 4.95l-9.2 9.19a2 2 0 01-2.83-2.83l8.49-8.48"/></svg>
            </button>
          </div>
        </div>
      </footer>
    </div>

    <!-- Sidebar: chat history -->
    <aside class="hidden lg:flex flex-col w-80 h-full bg-[#F4F4F2] border-l border-[#D0C5B2] shrink-0">
      <div class="p-6 flex flex-col gap-6">
        <div class="flex items-center justify-between">
          <button @click="newChat" class="w-10 h-10 rounded-xl bg-[#C9A84C] hover:bg-[#b8963f] flex items-center justify-center transition-colors">
            <svg class="w-5 h-5 text-[#503D00]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
          </button>
          <span class="text-3xl font-bold text-[#C9A84C]">فسحني</span>
        </div>

        <div class="flex flex-col gap-4">
          <h4 class="text-xs font-semibold tracking-wider uppercase text-[#7E7665] text-right px-2">سجل المحادثات</h4>
          <nav class="flex flex-col gap-2">
            <button v-for="c in conversations" :key="c.id" @click="selectConversation(c)"
              :class="c.active ? 'bg-[#C9A84C] text-[#503D00] font-bold' : 'text-[#4D4637] hover:bg-white/60'"
              class="flex items-center justify-between px-4 py-4 rounded-xl transition-colors text-right">
              <svg class="w-4.5 h-4.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="c.active ? 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z' : 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z'"/></svg>
              <span class="truncate">{{ c.title }}</span>
            </button>
          </nav>
        </div>
      </div>

      <div class="mt-auto border-t border-[#D0C5B2] p-6 flex flex-col gap-2">
        <button @click="router.push('/help')" class="flex items-center justify-between px-4 py-2 rounded-xl hover:bg-white/60 transition-colors">
          <svg class="w-5 h-5 text-[#4D4637]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
          <span class="text-base font-medium text-[#4D4637]">حسابي</span>
        </button>
        <button @click="router.push('/help')" class="flex items-center justify-between px-4 py-2 rounded-xl hover:bg-white/60 transition-colors">
          <svg class="w-5 h-5 text-[#4D4637]" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
          <span class="text-base font-medium text-[#4D4637]">الإعدادات</span>
        </button>
      </div>
    </aside>
  </div>
</template>

<style scoped>
.animate-bounce {
  animation: chat-bounce 1.2s infinite;
}
@keyframes chat-bounce {
  0%, 80%, 100% { transform: translateY(0); opacity: 0.5; }
  40% { transform: translateY(-4px); opacity: 1; }
}
</style>