<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const name = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const showPassword = ref(false)
const showConfirm = ref(false)
const agree = ref(false)
</script>
<template>
  <div dir="rtl" class="min-h-screen relative flex items-center justify-center py-12 px-4">

    <!-- Background image -->
    <img src="https://i.pinimg.com/1200x/97/c0/77/97c077228459ba50ef898ed05a34f6fd.jpg"
      class="absolute inset-0 w-full h-full object-cover object-center" alt="" />

    <!-- Form card -->
    <div class="relative z-10 bg-white rounded-2x2 shadow-2xl w-full max-w-md px-10 py-10">

      <!-- Logo -->
      <button @click="router.push('/')" class="flex items-center gap-2 mb-6">
        <img src="https://img.icons8.com/ios/50/C9A84C/world-map.png" class="w-5 h-5" alt="logo" />
        <span class="text-base font-bold text-[#1A3C5E]">فسحني</span>
      </button>

      <h1 class="text-2xl font-bold text-[#1A3C5E] mb-1">إنشاء حساب مجاني</h1>
      <p class="text-gray-400 text-sm mb-6">انضم إلينا واستكشف أجمل وجهات مصر.</p>

      <!-- Social buttons -->
      <div class="flex gap-3 mb-5">
        <button class="flex-1 border border-gray-200 rounded-lg py-2 text-sm text-gray-600 hover:bg-gray-50 transition-colors">iOS</button>
        <button class="flex-1 border border-gray-200 rounded-lg py-2 flex items-center justify-center hover:bg-gray-50 transition-colors">
          <svg class="w-4 h-4 fill-[#1877F2]" viewBox="0 0 24 24"><path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
        </button>
        <button class="flex-1 border border-gray-200 rounded-lg py-2 flex items-center justify-center hover:bg-gray-50 transition-colors">
          <svg class="w-4 h-4" viewBox="0 0 24 24"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/></svg>
        </button>
      </div>

      <!-- Divider -->
      <div class="flex items-center gap-3 mb-5">
        <div class="flex-1 h-px bg-gray-100"></div>
        <span class="text-xs text-gray-400">أو سجل عبر البريد</span>
        <div class="flex-1 h-px bg-gray-100"></div>
      </div>

      <!-- Name -->
      <div class="mb-3">
        <label class="block text-sm font-medium text-gray-700 mb-1">الاسم </label>
        <input v-model="name" type="text" placeholder="الاسم "
          class="w-full border border-gray-200 rounded-lg px-4 py-2.5 text-sm text-right focus:outline-none focus:border-[#C9A84C] placeholder:text-gray-300" />
      </div>

      <!-- Email -->
      <div class="mb-3">
        <label class="block text-sm font-medium text-gray-700 mb-1">البريد الإلكتروني</label>
        <div class="relative">
          <input v-model="email" type="email" placeholder="example@domain.com"
            class="w-full border border-gray-200 rounded-lg px-4 py-2.5 pl-10 text-sm text-right focus:outline-none focus:border-[#C9A84C] placeholder:text-gray-300" />
          <div class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-300">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
          </div>
        </div>
      </div>

      <!-- Password -->
      <div class="mb-3">
        <label class="block text-sm font-medium text-gray-700 mb-1">كلمة المرور</label>
        <div class="relative">
          <input v-model="password" :type="showPassword ? 'text' : 'password'" placeholder="••••••••"
            class="w-full border border-gray-200 rounded-lg px-4 py-2.5 pl-10 text-sm text-right focus:outline-none focus:border-[#C9A84C] placeholder:text-gray-300" />
          <button @click="showPassword = !showPassword" class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-300 hover:text-gray-500">
            <svg v-if="!showPassword" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
            <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
          </button>
        </div>
      </div>

      <!-- Confirm Password -->
      <div class="mb-4">
        <label class="block text-sm font-medium text-gray-700 mb-1">تأكيد كلمة المرور</label>
        <div class="relative">
          <input v-model="confirmPassword" :type="showConfirm ? 'text' : 'password'" placeholder="••••••••"
            class="w-full border border-gray-200 rounded-lg px-4 py-2.5 pl-10 text-sm text-right focus:outline-none focus:border-[#C9A84C] placeholder:text-gray-300"
            :class="confirmPassword && confirmPassword !== password ? 'border-[#C94B4B]' : ''" />
          <button @click="showConfirm = !showConfirm" class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-300 hover:text-gray-500">
            <svg v-if="!showConfirm" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
            <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
          </button>
        </div>
        <p v-if="confirmPassword && confirmPassword !== password" class="text-xs text-[#C94B4B] mt-1 text-right">كلمة المرور غير متطابقة</p>
      </div>

      <!-- Terms -->
      <div class="flex items-center justify-end gap-2 mb-5">
        <label for="agree" class="text-sm text-gray-400 cursor-pointer">
          أوافق على <button class="text-[#C9A84C] hover:underline">الشروط والأحكام</button>
        </label>
        <input id="agree" v-model="agree" type="checkbox" class="w-4 h-4 accent-[#C9A84C] cursor-pointer" />
      </div>

      <!-- Submit -->
      <button @click="router.push('/home')" class="w-full bg-[#C9A84C] hover:bg-[#b8963f] text-white py-3 rounded-lg font-semibold transition-colors text-sm flex items-center justify-center gap-2">
        إنشاء الحساب
        <svg class="w-4 h-4 rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
      </button>

      <p class="text-center text-sm text-gray-400 mt-5">
        لديك حساب بالفعل؟
        <button @click="router.push('/')" class="text-[#C9A84C] font-semibold hover:underline mr-1">تسجيل الدخول</button>
      </p>
    </div>

  </div>
</template>