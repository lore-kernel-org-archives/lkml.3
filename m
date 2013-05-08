Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3EHT4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:56:12 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62692 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3EHT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:56:10 -0400
Message-ID: <518AADD4.1000309@opensuse.org>
Date: Wed, 08 May 2013 15:56:04 -0400
From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x52/0x60()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

With the current linus tree, I get on resume from sleep.


   479.632697] ------------[ cut here ]------------
[  479.632703] WARNING: at arch/x86/kernel/smp.c:123 
native_smp_send_reschedule+0x52/0x60()
[  479.632740] Modules linked in: intel_powerclamp kvm_intel kvm 
crc32_pclmul snd_hda_codec_hdmi ghash_clmulni_intel aesni_intel 
glue_helper snd_hda_codec_realtek lrw gf128mul ablk_helper cryptd arc4 
aes_x86_64 iwldvm coretemp iTCO_wdt iTCO_vendor_support snd_hda_intel 
mac80211 dell_wmi sparse_keymap snd_hda_codec microcode uvcvideo 
dell_laptop snd_hwdep videobuf2_core dcdbas videodev snd_pcm btusb 
sr_mod lpc_ich bluetooth iwlwifi pcspkr i2c_i801 videobuf2_vmalloc cdrom 
videobuf2_memops snd_timer mfd_core atl1c cfg80211 snd rfkill soundcore 
snd_page_alloc battery ac sg btrfs libcrc32c xor raid6_pq crc32c_intel 
i915 nouveau ttm drm_kms_helper mxm_wmi drm i2c_algo_bit video thermal 
wmi button processor thermal_sys
[  479.632743] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 
3.9.0-666-desktop-11572-g5af43c2 #2
[  479.632744] Hardware name: Dell Inc.          Dell System XPS 
15Z/00WW5M, BIOS A12 09/07/2012
[  479.632747]  0000000000000009 ffff880234379de0 ffffffff814cda1f 
ffff880234379e18
[  479.632749]  ffffffff810377cc 0000000000000001 00000001000751d5 
ffff8802343b4000
[  479.632751]  0000000000000001 0000000000000000 ffff880234379e28 
ffffffff810378a5
[  479.632751] Call Trace:
[  479.632757]  [<ffffffff814cda1f>] dump_stack+0x19/0x1b
[  479.632759]  [<ffffffff810377cc>] warn_slowpath_common+0x5c/0x80
[  479.632761]  [<ffffffff810378a5>] warn_slowpath_null+0x15/0x20
[  479.632763]  [<ffffffff81021c32>] native_smp_send_reschedule+0x52/0x60
[  479.632766]  [<ffffffff810686b6>] wake_up_nohz_cpu+0x26/0xa0
[  479.632769]  [<ffffffff81047aa8>] add_timer_on+0x88/0x130
[  479.632772]  [<ffffffff8101b733>] mce_start_timer.isra.18+0x63/0x70
[  479.632773]  [<ffffffff8101b785>] __mcheck_cpu_init_timer+0x45/0x50
[  479.632776]  [<ffffffff814c2446>] mcheck_cpu_init+0x34a/0x3d1
[  479.632779]  [<ffffffff814c0a6e>] identify_cpu+0x35f/0x379
[  479.632781]  [<ffffffff814c0a9c>] identify_secondary_cpu+0x14/0x1b
[  479.632783]  [<ffffffff814c2879>] smp_store_cpu_info+0x38/0x3a
[  479.632785]  [<ffffffff814c2e9f>] start_secondary+0x13d/0x259
[  479.632786] ---[ end trace 7697d1f3de2e3933 ]---
[  479.635028] Intel pstate controlling: cpu 1
[  479.635074] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x28
[  479.635077] CPU1 is up
[  479.635089] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  479.645637] CPU2 microcode updated early to revision 0x28, date = 
2012-04-24
[  479.646137] CPU2: Thermal monitoring handled by SMI
[  479.646141] ------------[ cut here ]------------
[  479.646147] WARNING: at arch/x86/kernel/smp.c:123 
native_smp_send_reschedule+0x52/0x60()
[  479.646176] Modules linked in: intel_powerclamp kvm_intel kvm 
crc32_pclmul snd_hda_codec_hdmi ghash_clmulni_intel aesni_intel 
glue_helper snd_hda_codec_realtek lrw gf128mul ablk_helper cryptd arc4 
aes_x86_64 iwldvm coretemp iTCO_wdt iTCO_vendor_support snd_hda_intel 
mac80211 dell_wmi sparse_keymap snd_hda_codec microcode uvcvideo 
dell_laptop snd_hwdep videobuf2_core dcdbas videodev snd_pcm btusb 
sr_mod lpc_ich bluetooth iwlwifi pcspkr i2c_i801 videobuf2_vmalloc cdrom 
videobuf2_memops snd_timer mfd_core atl1c cfg80211 snd rfkill soundcore 
snd_page_alloc battery ac sg btrfs libcrc32c xor raid6_pq crc32c_intel 
i915 nouveau ttm drm_kms_helper mxm_wmi drm i2c_algo_bit video thermal 
wmi button processor thermal_sys
[  479.646178] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W 
3.9.0-666-desktop-11572-g5af43c2 #2
[  479.646179] Hardware name: Dell Inc.          Dell System XPS 
15Z/00WW5M, BIOS A12 09/07/2012
[  479.646181]  0000000000000009 ffff88023437bde0 ffffffff814cda1f 
ffff88023437be18
[  479.646182]  ffffffff810377cc 0000000000000002 00000001000751d2 
ffff880233c8c000
[  479.646184]  0000000000000002 0000000000000000 ffff88023437be28 
ffffffff810378a5
[  479.646184] Call Trace:
[  479.646189]  [<ffffffff814cda1f>] dump_stack+0x19/0x1b
[  479.646191]  [<ffffffff810377cc>] warn_slowpath_common+0x5c/0x80
[  479.646192]  [<ffffffff810378a5>] warn_slowpath_null+0x15/0x20
[  479.646194]  [<ffffffff81021c32>] native_smp_send_reschedule+0x52/0x60
[  479.646196]  [<ffffffff810686b6>] wake_up_nohz_cpu+0x26/0xa0
[  479.646198]  [<ffffffff81047aa8>] add_timer_on+0x88/0x130
[  479.646200]  [<ffffffff8101b733>] mce_start_timer.isra.18+0x63/0x70
[  479.646202]  [<ffffffff8101b785>] __mcheck_cpu_init_timer+0x45/0x50
[  479.646204]  [<ffffffff814c2446>] mcheck_cpu_init+0x34a/0x3d1
[  479.646206]  [<ffffffff814c0a6e>] identify_cpu+0x35f/0x379
[  479.646207]  [<ffffffff814c0a9c>] identify_secondary_cpu+0x14/0x1b
[  479.646209]  [<ffffffff814c2879>] smp_store_cpu_info+0x38/0x3a
[  479.646211]  [<ffffffff814c2e9f>] start_secondary+0x13d/0x259
[  479.646212] ---[ end trace 7697d1f3de2e3934 ]---
[  479.648456] Intel pstate controlling: cpu 2
[  479.648492] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x28
[  479.648495] CPU2 is up
[  479.648505] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  479.659554] CPU3: Thermal monitoring handled by SMI
[  479.659559] ------------[ cut here ]------------
[  479.659565] WARNING: at arch/x86/kernel/smp.c:123 
native_smp_send_reschedule+0x52/0x60()
[  479.659593] Modules linked in: intel_powerclamp kvm_intel kvm 
crc32_pclmul snd_hda_codec_hdmi ghash_clmulni_intel aesni_intel 
glue_helper snd_hda_codec_realtek lrw gf128mul ablk_helper cryptd arc4 
aes_x86_64 iwldvm coretemp iTCO_wdt iTCO_vendor_support snd_hda_intel 
mac80211 dell_wmi sparse_keymap snd_hda_codec microcode uvcvideo 
dell_laptop snd_hwdep videobuf2_core dcdbas videodev snd_pcm btusb 
sr_mod lpc_ich bluetooth iwlwifi pcspkr i2c_i801 videobuf2_vmalloc cdrom 
videobuf2_memops snd_timer mfd_core atl1c cfg80211 snd rfkill soundcore 
snd_page_alloc battery ac sg btrfs libcrc32c xor raid6_pq crc32c_intel 
i915 nouveau ttm drm_kms_helper mxm_wmi drm i2c_algo_bit video thermal 
wmi button processor thermal_sys
[  479.659595] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W 
3.9.0-666-desktop-11572-g5af43c2 #2
[  479.659596] Hardware name: Dell Inc.          Dell System XPS 
15Z/00WW5M, BIOS A12 09/07/2012
[  479.659598]  0000000000000009 ffff88023437dde0 ffffffff814cda1f 
ffff88023437de18
[  479.659599]  ffffffff810377cc 0000000000000003 00000001000751cf 
ffff880233d00000
[  479.659601]  0000000000000003 0000000000000000 ffff88023437de28 
ffffffff810378a5
[  479.659601] Call Trace:
[  479.659605]  [<ffffffff814cda1f>] dump_stack+0x19/0x1b
[  479.659607]  [<ffffffff810377cc>] warn_slowpath_common+0x5c/0x80
[  479.659609]  [<ffffffff810378a5>] warn_slowpath_null+0x15/0x20
[  479.659611]  [<ffffffff81021c32>] native_smp_send_reschedule+0x52/0x60
[  479.659613]  [<ffffffff810686b6>] wake_up_nohz_cpu+0x26/0xa0
[  479.659615]  [<ffffffff81047aa8>] add_timer_on+0x88/0x130
[  479.659617]  [<ffffffff8101b733>] mce_start_timer.isra.18+0x63/0x70
[  479.659619]  [<ffffffff8101b785>] __mcheck_cpu_init_timer+0x45/0x50
[  479.659621]  [<ffffffff814c2446>] mcheck_cpu_init+0x34a/0x3d1
[  479.659623]  [<ffffffff814c0a6e>] identify_cpu+0x35f/0x379
[  479.659624]  [<ffffffff814c0a9c>] identify_secondary_cpu+0x14/0x1b
[  479.659626]  [<ffffffff814c2879>] smp_store_cpu_info+0x38/0x3a
[  479.659627]  [<ffffffff814c2e9f>] start_secondary+0x13d/0x259
[  479.659628] ---[ end trace 7697d1f3de2e3935 ]---

Cool if someone can take a look what's going on ,
