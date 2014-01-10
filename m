Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaAJI3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:29:49 -0500
Received: from mout.web.de ([212.227.17.11]:52318 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaAJI3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:29:44 -0500
Message-ID: <52CFAF75.1050200@web.de>
Date: Fri, 10 Jan 2014 09:29:41 +0100
From: =?ISO-8859-1?Q?Axel_H=FCbl?= <axel.huebl@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: [Asus Taichi31] 2nd Backside Screen Backlight
References: <52CF4BDA.8030701@web.de>
In-Reply-To: <52CF4BDA.8030701@web.de>
X-Enigmail-Version: 1.6
OpenPGP: id=F1132F65
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050901080903020008090504"
X-Provags-ID: V03:K0:J5NEbOBQm9ZBwHHzfO/FX39f0Qrxx1eEUnw1XpRp6CATbDEA23/
 /VFemgs3ldUZGDx1m2lBztKk5WQz02Zc0m4yisHS89uLOlWxlN5A4gHOLj3qB/YfxuRABsn
 c6Tr9HmHxdZyMONXPY6BGysvpVM7EzbVFEg8PvEFFmXZGRlkOzYkSivJQVCPQ999h44SPzI
 HdzQYnordvElAW+dSB6SQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050901080903020008090504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I found the matching mailing list now:
  I will post it directly again to linux-acpi

Sorry for the spam in the first place, that's still kind of new for me.


Best
Axel

On 10.01.2014 02:24, Axel H=FCbl wrote:
> [1.] [Asus Taichi31] 2nd Backside Screen Backlight
>=20
> [2.] The backlight on my Taichi31=B4s 2nd screen (that is the=20
> touchscreen on the backside working like a tablet) is nearly black=20
> (but as far as I can test working). The only problem seems to be=20
> adequate LED brightness.
>=20
> Triaged by Christopher M. Penalver (penalvch)=20
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1267646
>=20
> [3.]
>=20
> [4.] Linux version 3.13.0-1-generic (buildd@toyol) (gcc version
> 4.8.2 (Ubuntu/Linaro 4.8.2-12ubuntu2) ) #16-Ubuntu SMP Tue Jan 7
> 19:44:06 UTC 2014
>=20
> [5.]
>=20
> [6.]
>=20
> [7.] Description: Ubuntu Trusty Tahr (development branch) Release:
> 14.04
>=20
> [7.1.] If some fields are empty or look unusual you may have an old
> version. Compare to the current minimal requirements in
> Documentation/Changes.
>=20
> Linux ubuntu 3.13.0-1-generic #16-Ubuntu SMP Tue Jan 7 19:44:06
> UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>=20
> Gnu C                  4.8 Gnu make               3.81 binutils
> 2.24 util-linux             2.20.1 mount                  support=20
> module-init-tools      15 e2fsprogs              1.42.9 jfsutils
> 1.1.15 reiserfsprogs          3.6.24 xfsprogs               3.1.9=20
> pcmciautils            018 PPP                    2.4.5 Linux C
> Library        2.18 Dynamic linker (ldd)   2.18 Procps
> 3.3.9 Net-tools              1.60 Kbd                    1.15.5=20
> Sh-utils               8.21 wireless-tools         30 Modules
> Loaded         intel_rapl x86_pkg_temp_thermal intel_powerclamp
> joydev coretemp dm_crypt kvm arc4 iwldvm uvcvideo videobuf2_vmalloc
> snd_hda_codec_hdmi crct10dif_pclmul mac80211 videobuf2_memops
> crc32_pclmul videobuf2_core ghash_clmulni_intel=20
> snd_hda_codec_realtek asix snd_hda_intel asus_nb_wmi cryptd
> asus_wmi snd_hda_codec videodev usbnet sparse_keymap mii
> hid_multitouch snd_hwdep snd_pcm dm_multipath iwlwifi scsi_dh
> snd_page_alloc parport_pc snd_seq_midi snd_seq_midi_event ppdev
> snd_rawmidi cfg80211 lp bnep microcode snd_seq btusb psmouse rfcomm
> mei_me parport serio_raw snd_seq_device mei bluetooth mac_hid
> snd_timer lpc_ich snd soundcore squashfs overlayfs nls_iso8859_1
> dm_mirror dm_region_hash dm_log usbhid hid usb_storage i915
> i2c_algo_bit drm_kms_helper ahci drm libahci wmi video
>=20
>=20
> [7.2.]
>=20
>=20
> processor	: 0 vendor_id	: GenuineIntel cpu family	: 6 model		: 58=20
> model name	: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz stepping	: 9=20
> microcode	: 0x15 cpu MHz		: 800.000 cache size	: 3072 KB physical
> id	: 0 siblings	: 4 core id		: 0 cpu cores	: 2 apicid		: 0 initial
> apicid	: 0 fpu		: yes fpu_exception	: yes cpuid level	: 13 wp		:
> yes flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
> nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2
> x2apic popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm ida
> arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept
> vpid fsgsbase smep erms bogomips	: 3392.03 clflush size	: 64=20
> cache_alignment	: 64 address sizes	: 36 bits physical, 48 bits
> virtual power management:
>=20
> processor	: 1 vendor_id	: GenuineIntel cpu family	: 6 model		: 58=20
> model name	: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz stepping	: 9=20
> microcode	: 0x15 cpu MHz		: 800.000 cache size	: 3072 KB physical
> id	: 0 siblings	: 4 core id		: 1 cpu cores	: 2 apicid		: 2 initial
> apicid	: 2 fpu		: yes fpu_exception	: yes cpuid level	: 13 wp		:
> yes flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
> nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2
> x2apic popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm ida
> arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept
> vpid fsgsbase smep erms bogomips	: 3392.03 clflush size	: 64=20
> cache_alignment	: 64 address sizes	: 36 bits physical, 48 bits
> virtual power management:
>=20
> processor	: 2 vendor_id	: GenuineIntel cpu family	: 6 model		: 58=20
> model name	: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz stepping	: 9=20
> microcode	: 0x15 cpu MHz		: 800.000 cache size	: 3072 KB physical
> id	: 0 siblings	: 4 core id		: 0 cpu cores	: 2 apicid		: 1 initial
> apicid	: 1 fpu		: yes fpu_exception	: yes cpuid level	: 13 wp		:
> yes flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
> nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2
> x2apic popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm ida
> arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept
> vpid fsgsbase smep erms bogomips	: 3392.03 clflush size	: 64=20
> cache_alignment	: 64 address sizes	: 36 bits physical, 48 bits
> virtual power management:
>=20
> processor	: 3 vendor_id	: GenuineIntel cpu family	: 6 model		: 58=20
> model name	: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz stepping	: 9=20
> microcode	: 0x15 cpu MHz		: 800.000 cache size	: 3072 KB physical
> id	: 0 siblings	: 4 core id		: 1 cpu cores	: 2 apicid		: 3 initial
> apicid	: 3 fpu		: yes fpu_exception	: yes cpuid level	: 13 wp		:
> yes flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good
> nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64
> monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2
> x2apic popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm ida
> arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept
> vpid fsgsbase smep erms bogomips	: 3392.03 clflush size	: 64=20
> cache_alignment	: 64 address sizes	: 36 bits physical, 48 bits
> virtual power management:
>=20
>=20
> [7.3.] Module information (from /proc/modules):
>=20
>=20
> intel_rapl 18773 0 - Live 0x0000000000000000 x86_pkg_temp_thermal
> 14162 0 - Live 0x0000000000000000 intel_powerclamp 14705 0 - Live
> 0x0000000000000000 joydev 17381 0 - Live 0x0000000000000000=20
> coretemp 13435 0 - Live 0x0000000000000000 dm_crypt 23177 0 - Live
> 0x0000000000000000 kvm 451485 0 - Live 0x0000000000000000 arc4
> 12608 2 - Live 0x0000000000000000 iwldvm 232285 0 - Live
> 0x0000000000000000 uvcvideo 80885 0 - Live 0x0000000000000000=20
> videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000=20
> snd_hda_codec_hdmi 46207 1 - Live 0x0000000000000000=20
> crct10dif_pclmul 14289 0 - Live 0x0000000000000000 mac80211 626584
> 1 iwldvm, Live 0x0000000000000000 videobuf2_memops 13362 1
> videobuf2_vmalloc, Live 0x0000000000000000 crc32_pclmul 13113 0 -
> Live 0x0000000000000000 videobuf2_core 40664 1 uvcvideo, Live
> 0x0000000000000000 ghash_clmulni_intel 13259 0 - Live
> 0x0000000000000000 snd_hda_codec_realtek 61234 1 - Live
> 0x0000000000000000 asix 38914 0 - Live 0x0000000000000000=20
> snd_hda_intel 52355 3 - Live 0x0000000000000000 asus_nb_wmi 16990 0
> - Live 0x0000000000000000 cryptd 20359 1 ghash_clmulni_intel, Live
> 0x0000000000000000 asus_wmi 24191 1 asus_nb_wmi, Live
> 0x0000000000000000 snd_hda_codec 192906 3=20
> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live=20
> 0x0000000000000000 videodev 134688 2 uvcvideo,videobuf2_core, Live
> 0x0000000000000000 usbnet 43918 1 asix, Live 0x0000000000000000=20
> sparse_keymap 13948 1 asus_wmi, Live 0x0000000000000000 mii 13934 2
> asix,usbnet, Live 0x0000000000000000 hid_multitouch 17407 0 - Live
> 0x0000000000000000 snd_hwdep 13602 1 snd_hda_codec, Live
> 0x0000000000000000 snd_pcm 102099 3
> snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live=20
> 0x0000000000000000 dm_multipath 22873 0 - Live 0x0000000000000000=20
> iwlwifi 169932 1 iwldvm, Live 0x0000000000000000 scsi_dh 14882 1
> dm_multipath, Live 0x0000000000000000 snd_page_alloc 18710 2
> snd_hda_intel,snd_pcm, Live 0x0000000000000000 parport_pc 32701 0 -
> Live 0x0000000000000000 snd_seq_midi 13324 0 - Live
> 0x0000000000000000 snd_seq_midi_event 14899 1 snd_seq_midi, Live
> 0x0000000000000000 ppdev 17671 0 - Live 0x0000000000000000=20
> snd_rawmidi 30144 1 snd_seq_midi, Live 0x0000000000000000 cfg80211
> 490477 3 iwldvm,mac80211,iwlwifi, Live 0x0000000000000000 lp 17759
> 0 - Live 0x0000000000000000 bnep 19624 2 - Live 0x0000000000000000=20
> microcode 23656 0 - Live 0x0000000000000000 snd_seq 61560 2
> snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000 btusb
> 32412 0 - Live 0x0000000000000000 psmouse 101945 0 - Live
> 0x0000000000000000 rfcomm 69160 0 - Live 0x0000000000000000 mei_me
> 18581 0 - Live 0x0000000000000000 parport 42348 3
> parport_pc,ppdev,lp, Live 0x0000000000000000 serio_raw 13462 0 -
> Live 0x0000000000000000 snd_seq_device 14497 3
> snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000 mei 77820
> 1 mei_me, Live 0x0000000000000000 bluetooth 395423 11
> bnep,btusb,rfcomm, Live 0x0000000000000000 mac_hid 13205 0 - Live
> 0x0000000000000000 snd_timer 29482 2 snd_pcm,snd_seq, Live
> 0x0000000000000000 lpc_ich 21080 0 - Live 0x0000000000000000 snd
> 69238 17=20
> snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,sn=
d_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer=
,
>
>=20
Live 0x0000000000000000
> soundcore 12680 1 snd, Live 0x0000000000000000 squashfs 48362 1 -
> Live 0x0000000000000000 overlayfs 27916 1 - Live
> 0x0000000000000000 nls_iso8859_1 12713 1 - Live 0x0000000000000000=20
> dm_mirror 22135 0 - Live 0x0000000000000000 dm_region_hash 20862 1
> dm_mirror, Live 0x0000000000000000 dm_log 18411 2
> dm_mirror,dm_region_hash, Live 0x0000000000000000 usbhid 52616 0 -
> Live 0x0000000000000000 hid 106148 2 hid_multitouch,usbhid, Live
> 0x0000000000000000 usb_storage 62209 1 - Live 0x0000000000000000=20
> i915 783268 3 - Live 0x0000000000000000 i2c_algo_bit 13413 1 i915,
> Live 0x0000000000000000 drm_kms_helper 52758 1 i915, Live
> 0x0000000000000000 ahci 25819 0 - Live 0x0000000000000000 drm
> 302631 4 i915,drm_kms_helper, Live 0x0000000000000000 libahci 32168
> 1 ahci, Live 0x0000000000000000 wmi 19177 1 asus_wmi, Live
> 0x0000000000000000 video 19421 2 asus_wmi,i915, Live
> 0x0000000000000000
>=20
>=20
> [7.4.] Loaded driver and hardware information (/proc/ioports,
> /proc/iomem)
>=20
>=20
>=20
> $ cat /proc/ioports 0000-0cf7 : PCI Bus 0000:00 0000-001f : dma1=20
> 0020-0021 : pic1 0040-0043 : timer0 0050-0053 : timer1 0060-0060 :
> keyboard 0062-0062 : EC data 0064-0064 : keyboard 0066-0066 : EC
> cmd 0070-0077 : rtc0 0080-008f : dma page reg 00a0-00a1 : pic2=20
> 00c0-00df : dma2 00f0-00ff : fpu 03f8-03ff : serial 0400-0403 :
> ACPI PM1a_EVT_BLK 0404-0405 : ACPI PM1a_CNT_BLK 0408-040b : ACPI
> PM_TMR 0410-0415 : ACPI CPU throttle 0420-042f : ACPI GPE0_BLK=20
> 0430-0433 : iTCO_wdt 0450-0450 : ACPI PM2_CNT_BLK 0454-0457 : pnp
> 00:06 0458-047f : pnp 00:04 0460-047f : iTCO_wdt 04d0-04d1 : pnp
> 00:07 0500-057f : pnp 00:04 0680-069f : pnp 00:04 0cf8-0cff : PCI
> conf1 0d00-ffff : PCI Bus 0000:00 1000-100f : pnp 00:04 164e-164f :
> pnp 00:04 f000-f03f : 0000:00:02.0 f040-f05f : 0000:00:1f.3=20
> f060-f07f : 0000:00:1f.2 f060-f07f : ahci f080-f083 : 0000:00:1f.2=20
> f080-f083 : ahci f090-f097 : 0000:00:1f.2 f090-f097 : ahci=20
> f0a0-f0a3 : 0000:00:1f.2 f0a0-f0a3 : ahci f0b0-f0b7 : 0000:00:1f.2=20
> f0b0-f0b7 : ahci ffff-ffff : pnp 00:04 ffff-ffff : pnp 00:04
>=20
> $ cat /proc/iomem 00000000-00000fff : reserved 00001000-0009efff :
> System RAM 0009f000-0009ffff : reserved 000a0000-000bffff : PCI Bus
> 0000:00 000c0000-000cefff : Video ROM 000d0000-000d3fff : PCI Bus
> 0000:00 000d4000-000d7fff : PCI Bus 0000:00 000d8000-000dbfff : PCI
> Bus 0000:00 000dc000-000dffff : PCI Bus 0000:00 000f0000-000fffff :
> System ROM 00100000-1fffffff : System RAM 01000000-0171b134 :
> Kernel code 0171b135-01d1bf3f : Kernel data 01e72000-01fd8fff :
> Kernel bss 20000000-201fffff : reserved 20000000-201fffff : pnp
> 00:0c 20200000-40003fff : System RAM 40004000-40004fff : reserved=20
> 40004000-40004fff : pnp 00:0c 40005000-d97cafff : System RAM=20
> d97cb000-d9dcbfff : ACPI Non-volatile Storage d9dcc000-d9dcefff :
> reserved d9dcf000-d9de5fff : System RAM d9de6000-d9debfff :
> reserved d9dec000-d9dedfff : System RAM d9dee000-d9df3fff :
> reserved d9df4000-d9f4cfff : System RAM d9f4d000-d9f50fff :
> reserved d9f51000-d9f8ffff : System RAM d9f90000-d9f96fff :
> reserved d9f97000-d9f98fff : System RAM d9f99000-d9fb7fff :
> reserved d9fb8000-d9fbafff : System RAM d9fbb000-d9fbcfff :
> reserved d9fbd000-d9fd3fff : System RAM d9fd4000-d9fd9fff :
> reserved d9fda000-d9fe1fff : System RAM d9fe2000-d9fe2fff :
> reserved d9fe3000-d9ff1fff : System RAM d9ff2000-d9ff2fff :
> reserved d9ff3000-d9ffdfff : System RAM d9ffe000-da002fff :
> reserved da003000-da021fff : System RAM da022000-da023fff :
> reserved da024000-da038fff : System RAM da039000-da039fff :
> reserved da03a000-da04bfff : System RAM da04c000-da071fff :
> reserved da072000-da085fff : System RAM da086000-da086fff :
> reserved da087000-da087fff : System RAM da088000-da089fff :
> reserved da08a000-da08afff : System RAM da08b000-da08ffff :
> reserved da090000-da0a6fff : System RAM da0a7000-da64afff :
> reserved da64b000-da8cafff : ACPI Non-volatile Storage=20
> da8cb000-da8cffff : ACPI Tables da8d0000-da8d0fff : System RAM=20
> da8d1000-da913fff : ACPI Non-volatile Storage da914000-dad28fff :
> System RAM dad29000-daff3fff : reserved daff4000-daffffff : System
> RAM db000000-dbbfffff : RAM buffer dbc00000-dfdfffff : reserved=20
> dbe00000-dfdfffff : Graphics Stolen Memory dfe00000-feafffff : PCI
> Bus 0000:00 dfe00000-dfe00fff : pnp 00:0b dfe08000-dfe0ffff :
> 0000:00:04.0 e0000000-efffffff : 0000:00:02.0 e0000000-e01d4fff :
> BOOTFB f7800000-f7bfffff : 0000:00:02.0 f7c00000-f7cfffff : PCI Bus
> 0000:02 f7c00000-f7c01fff : 0000:02:00.0 f7c00000-f7c01fff :
> iwlwifi f7d00000-f7d0ffff : 0000:00:14.0 f7d00000-f7d0ffff :
> xhci_hcd f7d18000-f7d1bfff : 0000:00:1b.0 f7d18000-f7d1bfff : ICH
> HD audio f7d1c000-f7d1cfff : 0000:00:1f.6 f7d1d000-f7d1d0ff :
> 0000:00:1f.3 f7d1e000-f7d1e7ff : 0000:00:1f.2 f7d1e000-f7d1e7ff :
> ahci f7d1f000-f7d1f3ff : 0000:00:1d.0 f7d1f000-f7d1f3ff : ehci_hcd=20
> f7d20000-f7d203ff : 0000:00:1a.0 f7d20000-f7d203ff : ehci_hcd=20
> f7d23000-f7d2300f : 0000:00:16.0 f7d23000-f7d2300f : mei_me=20
> f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f] f8000000-fbffffff
> : reserved f8000000-fbffffff : pnp 00:0b fec00000-fec00fff :
> reserved fec00000-fec003ff : IOAPIC 0 fed00000-fed03fff : reserved=20
> fed00000-fed003ff : HPET 0 fed10000-fed17fff : pnp 00:0b=20
> fed18000-fed18fff : pnp 00:0b fed19000-fed19fff : pnp 00:0b=20
> fed1c000-fed1ffff : reserved fed1c000-fed1ffff : pnp 00:0b=20
> fed1f410-fed1f414 : iTCO_wdt fed20000-fed3ffff : pnp 00:0b=20
> fed40000-fed44fff : pnp 00:00 fed45000-fed8ffff : pnp 00:0b=20
> fed90000-fed93fff : pnp 00:0b fee00000-fee00fff : Local APIC=20
> fee00000-fee00fff : reserved ff000000-ffffffff : reserved=20
> ff000000-ffffffff : pnp 00:0b 100000000-11f1fffff : System RAM=20
> 11f200000-11fffffff : RAM buffer
>=20
>=20
> [7.5.] PCI information ('lspci -vvv' as root)
>=20
>=20
> 00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM=20
> Controller (rev 09) Subsystem: ASUSTeK Computer Inc. Device 10cd=20
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF-
> FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort+ >SERR-
> <PERR- INTx- Latency: 0 Capabilities: [e0] Vendor Specific
> Information: Len=3D0c <?>
>=20
> 00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core=20
> processor Graphics Controller (rev 09) (prog-if 00 [VGA
> controller]) Subsystem: ASUSTeK Computer Inc. Device 10cd Control:
> I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=20
> Stepping- SERR- FastB2B- DisINTx+ Status: Cap+ 66MHz- UDF- FastB2B+
> ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-=20
> Latency: 0 Interrupt: pin A routed to IRQ 42 Region 0: Memory at
> f7800000 (64-bit, non-prefetchable) [size=3D4M] Region 2: Memory at
> e0000000 (64-bit, prefetchable) [size=3D256M] Region 4: I/O ports at
> f000 [size=3D64] Expansion ROM at <unassigned> [disabled]=20
> Capabilities: [90] MSI: Enable+ Count=3D1/1 Maskable- 64bit- Address:
> fee0f00c  Data: 41a1 Capabilities: [d0] Power Management version 2=20
> Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst- PME-Enable-
> DSel=3D0 DScale=3D0 PME- Capabilities: [a4] PCI Advanced Features=20
> AFCap: TP+ FLR+ AFCtrl: FLR- AFStatus: TP- Kernel driver in use:
> i915
>=20
> 00:04.0 Signal processing controller: Intel Corporation 3rd Gen
> Core Processor Thermal Subsystem (rev 09) Subsystem: ASUSTeK
> Computer Inc. Device 10cd Control: I/O- Mem+ BusMaster+ SpecCycle-
> MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-=20
> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-=20
> <TAbort- <MAbort- >SERR- <PERR- INTx- Latency: 0 Interrupt: pin A
> routed to IRQ 11 Region 0: Memory at dfe08000 (64-bit,
> non-prefetchable) [size=3D32K] Capabilities: [90] MSI: Enable-
> Count=3D1/1 Maskable- 64bit- Address: 00000000  Data: 0000=20
> Capabilities: [d0] Power Management version 3 Flags: PMEClk- DSI-
> D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0
> NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME- Capabilities: [e0]
> Vendor Specific Information: Len=3D0c <?>
>=20
> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series
> Chipset Family USB xHCI Host Controller (rev 04) (prog-if 30
> [XHCI]) Subsystem: ASUSTeK Computer Inc. Device 201f Control: I/O-
> Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR- FastB2B- DisINTx+ Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
> DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-=20
> Latency: 0 Interrupt: pin A routed to IRQ 40 Region 0: Memory at
> f7d00000 (64-bit, non-prefetchable) [size=3D64K] Capabilities: [70]
> Power Management version 2 Flags: PMEClk- DSI- D1- D2-
> AuxCurrent=3D375mA PME(D0-,D1-,D2-,D3hot+,D3cold+) Status: D0
> NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME- Capabilities: [80] MSI:=

> Enable+ Count=3D1/8 Maskable- 64bit+ Address: 00000000fee0500c  Data:
> 4171 Kernel driver in use: xhci_hcd
>=20
> 00:16.0 Communication controller: Intel Corporation 7 Series/C210=20
> Series Chipset Family MEI Controller #1 (rev 04) Subsystem: ASUSTeK
> Computer Inc. Device 10cd Control: I/O- Mem+ BusMaster+ SpecCycle-
> MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+=20
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-=20
> <TAbort- <MAbort- >SERR- <PERR- INTx- Latency: 0 Interrupt: pin A
> routed to IRQ 43 Region 0: Memory at f7d23000 (64-bit,
> non-prefetchable) [size=3D16] Capabilities: [50] Power Management
> version 3 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA=20
> PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0 NoSoftRst+ PME-Enable-
> DSel=3D0 DScale=3D0 PME- Capabilities: [8c] MSI: Enable+ Count=3D1/1
> Maskable- 64bit+ Address: 00000000fee0f00c  Data: 41b1 Kernel
> driver in use: mei_me
>=20
> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series
> Chipset Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20
> [EHCI]) Subsystem: ASUSTeK Computer Inc. Device 10cd Control: I/O-
> Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
> DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-=20
> Latency: 0 Interrupt: pin A routed to IRQ 16 Region 0: Memory at
> f7d20000 (32-bit, non-prefetchable) [size=3D1K] Capabilities: [50]
> Power Management version 2 Flags: PMEClk- DSI- D1- D2-
> AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0
> NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME- Capabilities: [58]
> Debug port: BAR=3D1 offset=3D00a0 Capabilities: [98] PCI Advanced
> Features AFCap: TP+ FLR+ AFCtrl: FLR- AFStatus: TP- Kernel driver
> in use: ehci-pci
>=20
> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series
> Chipset Family High Definition Audio Controller (rev 04) Subsystem:
> ASUSTeK Computer Inc. Device 10cd Control: I/O- Mem+ BusMaster+
> SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> DisINTx+ Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- Latency: 0, Cache
> Line Size: 64 bytes Interrupt: pin A routed to IRQ 45 Region 0:
> Memory at f7d18000 (64-bit, non-prefetchable) [size=3D16K]=20
> Capabilities: [50] Power Management version 2 Flags: PMEClk- DSI-
> D1- D2- AuxCurrent=3D55mA PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0
> NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME- Capabilities: [60] MSI:=

> Enable+ Count=3D1/1 Maskable- 64bit+ Address: 00000000fee0f00c  Data:
> 41e1 Capabilities: [70] Express (v1) Root Complex Integrated
> Endpoint, MSI 00 DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency
> L0s <64ns, L1 <1us ExtTag- RBE- FLReset+ DevCtl:	Report errors:
> Correctable- Non-Fatal- Fatal- Unsupported- RlxdOrd- ExtTag-
> PhantFunc- AuxPwr- NoSnoop- MaxPayload 128 bytes, MaxReadReq 128
> bytes DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend- LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown,
> Latency L0 <64ns, L1 <1us ClockPM- Surprise- LLActRep- BwNot-=20
> LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk- ExtSynch-
> ClockPM- AutWidDis- BWInt- AutBWInt- LnkSta:	Speed unknown, Width
> x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt- Capabilities:
> [100 v1] Virtual Channel Caps:	LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D=
1=20
> Arb:	Fixed- WRR32- WRR64- WRR128- Ctrl:	ArbSelect=3DFixed Status:
> InProgress- VC0:	Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans-=20
> Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256- Ctrl:	Enable+
> ID=3D0 ArbSelect=3DFixed TC/VC=3D01 Status:	NegoPending- InProgress- VC=
1:
> Caps:	PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopTrans- Arb:	Fixed- WRR32-=

> WRR64- WRR128- TWRR128- WRR256- Ctrl:	Enable+ ID=3D1 ArbSelect=3DFixed
> TC/VC=3D22 Status:	NegoPending- InProgress- Capabilities: [130 v1]
> Root Complex Link Desc:	PortNumber=3D0f ComponentID=3D00
> EltType=3DConfig Link0:	Desc:	TargetPort=3D00 TargetComponent=3D00
> AssocRCRB- LinkType=3DMemMapped LinkValid+ Addr:	00000000fed1c000=20
> Kernel driver in use: snd_hda_intel
>=20
> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset=20
> Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal
> decode]) Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV-
> VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx- Status: Cap+
> 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort-
> >SERR- <PERR- INTx- Latency: 0, Cache Line Size: 64 bytes Bus:
> primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0 I/O beh=
ind
> bridge: 0000f000-00000fff Memory behind bridge: fff00000-000fffff=20
> Prefetchable memory behind bridge:
> 00000000fff00000-00000000000fffff Secondary status: 66MHz- FastB2B-
> ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-=20
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-=20
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn- Capabilities:
> [40] Express (v2) Root Port (Slot+), MSI 00 DevCap:	MaxPayload 128
> bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us ExtTag- RBE+
> FLReset- DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported- RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-=20
> MaxPayload 128 bytes, MaxReadReq 128 bytes DevSta:	CorrErr-
> UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend- LnkCap:	Port #1,
> Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <16us=20
> ClockPM- Surprise- LLActRep+ BwNot- LnkCtl:	ASPM L0s L1 Enabled;
> RCB 64 bytes Disabled- Retrain- CommClk- ExtSynch- ClockPM-
> AutWidDis- BWInt- AutBWInt- LnkSta:	Speed 2.5GT/s, Width x0, TrErr-
> Train- SlotClk+ DLActive- BWMgmt- ABWMgmt- SltCap:	AttnBtn-
> PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise- Slot #0,
> PowerLimit 10.000W; Interlock- NoCompl+ SltCtl:	Enable: AttnBtn-
> PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg- Control: AttnInd
> Unknown, PwrInd Unknown, Power- Interlock- SltSta:	Status: AttnBtn-
> PowerFlt- MRL- CmdCplt- PresDet- Interlock- Changed: MRL- PresDet-
> LinkState- RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
> PMEIntEna- CRSVisible- RootCap: CRSVisible- RootSta: PME ReqID
> 0000, PMEStatus- PMEPending- DevCap2: Completion Timeout: Range BC,
> TimeoutDis+ ARIFwd- DevCtl2: Completion Timeout: 50us to 50ms,
> TimeoutDis- ARIFwd- LnkCtl2: Target Link Speed: 5GT/s,
> EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB Transmit
> Margin: Normal Operating Range, EnterModifiedCompliance-=20
> ComplianceSOS- Compliance De-emphasis: -6dB LnkSta2: Current
> De-emphasis Level: -3.5dB, EqualizationComplete-,=20
> EqualizationPhase1- EqualizationPhase2-, EqualizationPhase3-,
> LinkEqualizationRequest- Capabilities: [80] MSI: Enable- Count=3D1/1
> Maskable- 64bit- Address: 00000000  Data: 0000 Capabilities: [90]
> Subsystem: ASUSTeK Computer Inc. Device 10cd Capabilities: [a0]
> Power Management version 2 Flags: PMEClk- DSI- D1- D2-
> AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0
> NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME- Kernel driver in use:
> pcieport
>=20
> 00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset=20
> Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal
> decode]) Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV-
> VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx- Status: Cap+
> 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort-
> >SERR- <PERR- INTx- Latency: 0, Cache Line Size: 64 bytes Bus:
> primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0 I/O beh=
ind
> bridge: 0000f000-00000fff Memory behind bridge: f7c00000-f7cfffff=20
> Prefetchable memory behind bridge:
> 00000000fff00000-00000000000fffff Secondary status: 66MHz- FastB2B-
> ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-=20
> BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-=20
> PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn- Capabilities:
> [40] Express (v2) Root Port (Slot+), MSI 00 DevCap:	MaxPayload 128
> bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us ExtTag- RBE+
> FLReset- DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported- RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-=20
> MaxPayload 128 bytes, MaxReadReq 128 bytes DevSta:	CorrErr-
> UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend- LnkCap:	Port #2,
> Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us=20
> ClockPM- Surprise- LLActRep+ BwNot- LnkCtl:	ASPM Disabled; RCB 64
> bytes Disabled- Retrain- CommClk+ ExtSynch- ClockPM- AutWidDis-
> BWInt- AutBWInt- LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive+ BWMgmt+ ABWMgmt- SltCap:	AttnBtn- PwrCtrl- MRL-
> AttnInd- PwrInd- HotPlug- Surprise- Slot #1, PowerLimit 10.000W;
> Interlock- NoCompl+ SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq- LinkChg- Control: AttnInd Unknown, PwrInd Unknown,
> Power- Interlock- SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock- Changed: MRL- PresDet- LinkState+ RootCtl:
> ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=20
> RootCap: CRSVisible- RootSta: PME ReqID 0000, PMEStatus-
> PMEPending- DevCap2: Completion Timeout: Range BC, TimeoutDis+
> ARIFwd- DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
> ARIFwd- LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> SpeedDis-, Selectable De-emphasis: -6dB Transmit Margin: Normal
> Operating Range, EnterModifiedCompliance- ComplianceSOS- Compliance
> De-emphasis: -6dB LnkSta2: Current De-emphasis Level: -3.5dB,
> EqualizationComplete-, EqualizationPhase1- EqualizationPhase2-,
> EqualizationPhase3-, LinkEqualizationRequest- Capabilities: [80]
> MSI: Enable- Count=3D1/1 Maskable- 64bit- Address: 00000000  Data:
> 0000 Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device
> 10cd Capabilities: [a0] Power Management version 2 Flags: PMEClk-
> DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3cold+) Status:
> D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME- Kernel driver in
> use: pcieport
>=20
> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series
> Chipset Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20
> [EHCI]) Subsystem: ASUSTeK Computer Inc. Device 10cd Control: I/O-
> Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
> DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-=20
> Latency: 0 Interrupt: pin A routed to IRQ 23 Region 0: Memory at
> f7d1f000 (32-bit, non-prefetchable) [size=3D1K] Capabilities: [50]
> Power Management version 2 Flags: PMEClk- DSI- D1- D2-
> AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0
> NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME- Capabilities: [58]
> Debug port: BAR=3D1 offset=3D00a0 Capabilities: [98] PCI Advanced
> Features AFCap: TP+ FLR+ AFCtrl: FLR- AFStatus: TP- Kernel driver
> in use: ehci-pci
>=20
> 00:1f.0 ISA bridge: Intel Corporation QS77 Express Chipset LPC=20
> Controller (rev 04) Subsystem: ASUSTeK Computer Inc. Device 10cd=20
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF-
> FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx- Latency: 0 Capabilities: [e0] Vendor Specific
> Information: Len=3D0c <?> Kernel driver in use: lpc_ich
>=20
> 00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family=20
> 6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI
> 1.0]) Subsystem: ASUSTeK Computer Inc. Device 10cd Control: I/O+
> Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR- FastB2B- DisINTx+ Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr-
> DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-=20
> Latency: 0 Interrupt: pin B routed to IRQ 41 Region 0: I/O ports at
> f0b0 [size=3D8] Region 1: I/O ports at f0a0 [size=3D4] Region 2: I/O
> ports at f090 [size=3D8] Region 3: I/O ports at f080 [size=3D4] Region
> 4: I/O ports at f060 [size=3D32] Region 5: Memory at f7d1e000
> (32-bit, non-prefetchable) [size=3D2K] Capabilities: [80] MSI:
> Enable+ Count=3D1/1 Maskable- 64bit- Address: fee0a00c  Data: 4191=20
> Capabilities: [70] Power Management version 3 Flags: PMEClk- DSI-
> D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot+,D3cold-) Status: D0
> NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME- Capabilities: [a8] SATA=

> HBA v1.0 BAR4 Offset=3D00000004 Capabilities: [b0] PCI Advanced
> Features AFCap: TP+ FLR+ AFCtrl: FLR- AFStatus: TP- Kernel driver
> in use: ahci
>=20
> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset
> Family SMBus Controller (rev 04) Subsystem: ASUSTeK Computer Inc.
> Device 10cd Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV-
> VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx- Status: Cap-
> 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx- Interrupt: pin C routed to IRQ 10=20
> Region 0: Memory at f7d1d000 (64-bit, non-prefetchable) [size=3D256]=20
> Region 4: I/O ports at f040 [size=3D32]
>=20
> 00:1f.6 Signal processing controller: Intel Corporation 7
> Series/C210 Series Chipset Family Thermal Management Controller
> (rev 04) Subsystem: ASUSTeK Computer Inc. Device 10cd Control: I/O-
> Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
> SERR- FastB2B- DisINTx- Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
> DEVSEL=3Dfast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- Latency:
> 0 Interrupt: pin C routed to IRQ 10 Region 0: Memory at f7d1c000
> (64-bit, non-prefetchable) [size=3D4K] Capabilities: [50] Power
> Management version 3 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 NoSoftRst+ PME-Enable-
> DSel=3D0 DScale=3D0 PME-
>=20
> 02:00.0 Network controller: Intel Corporation Centrino Advanced-N
> 6235 (rev 24) Subsystem: Intel Corporation Centrino Advanced-N 6235
> AGN Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+ Status: Cap+ 66MHz- UDF-
> FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- <MAbort- >SERR-
> <PERR- INTx- Latency: 0, Cache Line Size: 64 bytes Interrupt: pin A
> routed to IRQ 44 Region 0: Memory at f7c00000 (64-bit,
> non-prefetchable) [size=3D8K] Capabilities: [c8] Power Management
> version 3 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA=20
> PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0 NoSoftRst- PME-Enable-
> DSel=3D0 DScale=3D0 PME- Capabilities: [d0] MSI: Enable+ Count=3D1/1
> Maskable- 64bit+ Address: 00000000fee0100c  Data: 41c1=20
> Capabilities: [e0] Express (v1) Endpoint, MSI 00 DevCap:	MaxPayload
> 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited ExtTag-
> AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ DevCtl:	Report errors:
> Correctable- Non-Fatal- Fatal- Unsupported- RlxdOrd+ ExtTag-
> PhantFunc- AuxPwr- NoSnoop+ FLReset- MaxPayload 128 bytes,
> MaxReadReq 128 bytes DevSta:	CorrErr+ UncorrErr- FatalErr-
> UnsuppReq+ AuxPwr+ TransPend- LnkCap:	Port #0, Speed 2.5GT/s, Width
> x1, ASPM L0s L1, Latency L0 <4us, L1 <32us ClockPM+ Surprise-
> LLActRep- BwNot- LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled-
> Retrain- CommClk+ ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-=20
> LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-=20
> BWMgmt- ABWMgmt- Capabilities: [100 v1] Advanced Error Reporting=20
> UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-=20
> MalfTLP- ECRC- UnsupReq- ACSViol- UEMsk:	DLP- SDES- TLP- FCP-
> CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq-
> ACSViol- UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol- CESta:	RxErr- BadTLP-
> BadDLLP- Rollover- Timeout- NonFatalErr+ CEMsk:	RxErr- BadTLP-
> BadDLLP- Rollover- Timeout- NonFatalErr+ AERCap:	First Error
> Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn- Capabilities: [140 v1]
> Device Serial Number c8-f7-33-ff-ff-eb-c7-97 Kernel driver in use:
> iwlwifi
>=20
>=20
> [7.6.] SCSI information (from /proc/scsi/scsi)
>=20
> Attached devices: Host: scsi0 Channel: 00 Id: 00 Lun: 00 Vendor:
> ATA      Model: SanDisk SD5SE212 Rev: 10.0 Type:   Direct-Access
> ANSI  SCSI revision: 05 Host: scsi6 Channel: 00 Id: 00 Lun: 00=20
> Vendor: JetFlash Model: Transcend 2GB    Rev: 8.07 Type:
> Direct-Access                    ANSI  SCSI revision: 02
>=20
>=20
> [7.7.] Other information that might be relevant to the problem=20
> (please look in /proc and include all information that you think to
> be relevant):
>=20
> Downstream report:=20
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1267646
>=20
> $ ls /proc/ 1     1133  12    141   1678  18    2107  2517  2561
> 2679  2855  2980 3100  33    3526  3747  45  56      buddyinfo
> execdomains  kmsg mtrr          swaps              vmstat 10
> 1138  1236  142   17    1810  23    2519  2564  2681  2864  3 3101
> 3314  3541  38    46  57      bus        fb kpagecount     net
> sys                zoneinfo 1020  1142  1286  143   1711  182
> 2341  2521  2576  2708  2866  30 3106  3381  3542  3807  47  69
> cgroups    filesystems kpageflags     pagetypeinfo  sysrq-trigger=20
> 1042  1143  13    144   1713  183   24    2525  2587  2714  2871
> 306 3124  3386  3549  39    48  7       cmdline    fs latency_stats
> partitions    sysvipc 1046  1149  1304  1476  1715  1833  2408
> 2539  2596  2727  2872  3081 3129  3394  3550  3939  49  701
> consoles   interrupts   loadavg sched_debug   timer_list 1092  1152
> 1314  1483  1716  1871  2425  2543  26    2735  2876  3082 3136  34
> 36    3971  5   8       cpuinfo    iomem        locks schedstat
> timer_stats 1098  1158  1335  1494  1729  19    2493  2547  2665
> 2756  2893  3083 3263  3415  3605  40    51  9       crypto
> ioports      mdstat scsi          tty 11    1183  1359  1496  1743
> 1953  2496  2548  2668  2797  29    3088 3271  3490  3629  41    52
> 90      devices    irq          meminfo self          uptime 1106
> 1187  139   15    1763  2     25    2553  2674  28    2903  3091=20
> 3283  35    3630  42    53  91      diskstats  kallsyms     misc=20
> slabinfo      version 1107  1190  14    1503  1766  20    2503
> 2554  2676  2842  2908  3097 3285  3509  37    43    54  acpi
> dma        kcore        modules softirqs      version_signature=20
> 1123  1191  140   16    1795  21    2505  2556  2677  2851  2968
> 31 3286  3515  3725  44    55  asound  driver     key-users
> mounts stat          vmallocinfo
>=20
>=20
> $ cat /var/log/Xorg.0.log [    19.201] X.Org X Server 1.14.5=20
> Release Date: 2013-12-12 [    19.201] X Protocol Version 11,
> Revision 0 [    19.201] Build Operating System: Linux
> 3.2.0-54-generic x86_64 Ubuntu [    19.201] Current Operating
> System: Linux ubuntu 3.13.0-1-generic #16-Ubuntu SMP Tue Jan 7
> 19:44:06 UTC 2014 x86_64 [    19.201] Kernel command line:
> BOOT_IMAGE=3D/casper/vmlinuz.efi file=3D/cdrom/preseed/ubuntu.seed
> boot=3Dcasper quiet splash -- [    19.201] Build Date: 15 December
> 2013  09:53:45PM [    19.201] xorg-server 2:1.14.5-1ubuntu2 (For
> technical support please see http://www.ubuntu.com/support) [
> 19.201] Current version of pixman: 0.30.2 [    19.201] 	Before
> reporting problems, check http://wiki.x.org to make sure that you
> have the latest version. [    19.201] Markers: (--) probed, (**)
> from config file, (=3D=3D) default setting, (++) from command line,
> (!!) notice, (II) informational, (WW) warning, (EE) error, (NI) not
> implemented, (??) unknown. [    19.201] (=3D=3D) Log file:
> "/var/log/Xorg.0.log", Time: Fri Jan 10 00:30:46 2014 [    19.202]
> (=3D=3D) Using system config directory "/usr/share/X11/xorg.conf.d" [
> 19.204] (=3D=3D) No Layout section.  Using the first Screen section. [
> 19.204] (=3D=3D) No screen section available. Using defaults. [
> 19.204] (**) |-->Screen "Default Screen Section" (0) [    19.204]
> (**) |   |-->Monitor "<default monitor>" [    19.204] (=3D=3D) No
> monitor specified for screen "Default Screen Section". Using a
> default monitor configuration. [    19.204] (=3D=3D) Automatically
> adding devices [    19.204] (=3D=3D) Automatically enabling devices [
> 19.204] (=3D=3D) Automatically adding GPU devices [    19.212] (WW) The=

> directory "/usr/share/fonts/X11/cyrillic" does not exist. [
> 19.212] 	Entry deleted from font path. [    19.213] (WW) The
> directory "/usr/share/fonts/X11/100dpi/" does not exist. [
> 19.213] 	Entry deleted from font path. [    19.213] (WW) The
> directory "/usr/share/fonts/X11/75dpi/" does not exist. [
> 19.213] 	Entry deleted from font path. [    19.213] (WW) The
> directory "/usr/share/fonts/X11/100dpi" does not exist. [
> 19.213] 	Entry deleted from font path. [    19.213] (WW) The
> directory "/usr/share/fonts/X11/75dpi" does not exist. [    19.213]
> Entry deleted from font path. [    19.213] (=3D=3D) FontPath set to:=20
> /usr/share/fonts/X11/misc, /usr/share/fonts/X11/Type1, built-ins [
> 19.213] (=3D=3D) ModulePath set to=20
> "/usr/lib/x86_64-linux-gnu/xorg/extra-modules,/usr/lib/xorg/extra-modul=
es,/usr/lib/xorg/modules"
>
>=20
[    19.213] (II) The server relies on udev to provide the list of
> input devices. If no devices become available, reconfigure udev or
> disable AutoAddDevices. [    19.213] (II) Loader magic:
> 0x7fe19f5f5d20 [    19.213] (II) Module ABI versions: [    19.213]
> X.Org ANSI C Emulation: 0.4 [    19.213] 	X.Org Video Driver: 14.1=20
> [    19.213] 	X.Org XInput driver : 19.1 [    19.213] 	X.Org Server
> Extension : 7.0 [    19.213] (II) xfree86: Adding drm device
> (/dev/dri/card0) [    19.214] (--) PCI:*(0:0:2:0)
> 8086:0166:1043:10cd rev 9, Mem @ 0xf7800000/4194304,
> 0xe0000000/268435456, I/O @ 0x0000f000/64 [    19.214] (II) Open
> ACPI successful (/var/run/acpid.socket) [    19.214] Initializing
> built-in extension Generic Event Extension [    19.214]
> Initializing built-in extension SHAPE [    19.214] Initializing
> built-in extension MIT-SHM [    19.214] Initializing built-in
> extension XInputExtension [    19.214] Initializing built-in
> extension XTEST [    19.214] Initializing built-in extension
> BIG-REQUESTS [    19.214] Initializing built-in extension SYNC [
> 19.214] Initializing built-in extension XKEYBOARD [    19.214]
> Initializing built-in extension XC-MISC [    19.214] Initializing
> built-in extension SECURITY [    19.214] Initializing built-in
> extension XINERAMA [    19.214] Initializing built-in extension
> XFIXES [    19.214] Initializing built-in extension RENDER [
> 19.214] Initializing built-in extension RANDR [    19.214]
> Initializing built-in extension COMPOSITE [    19.214] Initializing
> built-in extension DAMAGE [    19.214] Initializing built-in
> extension MIT-SCREEN-SAVER [    19.214] Initializing built-in
> extension DOUBLE-BUFFER [    19.214] Initializing built-in
> extension RECORD [    19.214] Initializing built-in extension DPMS=20
> [    19.214] Initializing built-in extension X-Resource [
> 19.214] Initializing built-in extension XVideo [    19.214]
> Initializing built-in extension XVideo-MotionCompensation [
> 19.214] Initializing built-in extension SELinux [    19.214]
> Initializing built-in extension XFree86-VidModeExtension [
> 19.214] Initializing built-in extension XFree86-DGA [    19.214]
> Initializing built-in extension XFree86-DRI [    19.214]
> Initializing built-in extension DRI2 [    19.214] (II) "glx" will
> be loaded by default. [    19.214] (WW) "xmir" is not to be loaded
> by default. Skipping. [    19.214] (II) LoadModule: "dri2" [
> 19.214] (II) Module "dri2" already built-in [    19.214] (II)
> LoadModule: "glamoregl" [    19.215] (II) Loading
> /usr/lib/xorg/modules/libglamoregl.so [    19.296] (II) Module
> glamoregl: vendor=3D"X.Org Foundation" [    19.296] 	compiled for
> 1.14.3, module version =3D 0.5.1 [    19.296] 	ABI class: X.Org ANSI
> C Emulation, version 0.4 [    19.296] (II) LoadModule: "glx" [
> 19.296] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so [
> 19.311] (II) Module glx: vendor=3D"X.Org Foundation" [    19.311]
> compiled for 1.14.5, module version =3D 1.0.0 [    19.311] 	ABI
> class: X.Org Server Extension, version 7.0 [    19.311] (=3D=3D) AIGLX
> enabled [    19.312] Loading extension GLX [    19.312] (=3D=3D)
> Matched intel as autoconfigured driver 0 [    19.312] (=3D=3D) Matched
> intel as autoconfigured driver 1 [    19.312] (=3D=3D) Matched vesa as
> autoconfigured driver 2 [    19.312] (=3D=3D) Matched modesetting as
> autoconfigured driver 3 [    19.312] (=3D=3D) Matched fbdev as
> autoconfigured driver 4 [    19.312] (=3D=3D) Assigned the driver to
> the xf86ConfigLayout [    19.312] (II) LoadModule: "intel" [
> 19.312] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so [
> 19.351] (II) Module intel: vendor=3D"X.Org Foundation" [    19.351]
> compiled for 1.14.5, module version =3D 2.99.907 [    19.351] 	Module
> class: X.Org Video Driver [    19.351] 	ABI class: X.Org Video
> Driver, version 14.1 [    19.351] (II) LoadModule: "vesa" [
> 19.351] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so [
> 19.352] (II) Module vesa: vendor=3D"X.Org Foundation" [    19.352]
> compiled for 1.14.3, module version =3D 2.3.3 [    19.352] 	Module
> class: X.Org Video Driver [    19.352] 	ABI class: X.Org Video
> Driver, version 14.1 [    19.352] (II) LoadModule: "modesetting" [
> 19.352] (II) Loading
> /usr/lib/xorg/modules/drivers/modesetting_drv.so [    19.356] (II)
> Module modesetting: vendor=3D"X.Org Foundation" [    19.356]
> compiled for 1.14.3, module version =3D 0.8.1 [    19.356] 	Module
> class: X.Org Video Driver [    19.356] 	ABI class: X.Org Video
> Driver, version 14.1 [    19.356] (II) LoadModule: "fbdev" [
> 19.356] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so [
> 19.356] (II) Module fbdev: vendor=3D"X.Org Foundation" [    19.356]
> compiled for 1.14.5, module version =3D 0.4.4 [    19.356] 	Module
> class: X.Org Video Driver [    19.356] 	ABI class: X.Org Video
> Driver, version 14.1 [    19.356] (II) intel: Driver for Intel(R)
> Integrated Graphics Chipsets: i810, i810-dc100, i810e, i815, i830M,
> 845G, 854, 852GM/855GM, 865G, 915G, E7221 (i915), 915GM, 945G,
> 945GM, 945GME, Pineview GM, Pineview G, 965G, G35, 965Q, 946GZ,
> 965GM, 965GME/GLE, G33, Q35, Q33, GM45, 4 Series, G45/G43, Q45/Q43,
> G41, B43 [    19.356] (II) intel: Driver for Intel(R) HD Graphics:
> 2000-5000 [    19.356] (II) intel: Driver for Intel(R) Iris(TM)
> Graphics: 5100 [    19.356] (II) intel: Driver for Intel(R)
> Iris(TM) Pro Graphics: 5200 [    19.356] (II) VESA: driver for VESA
> chipsets: vesa [    19.356] (II) modesetting: Driver for
> Modesetting Kernel Drivers: kms [    19.356] (II) FBDEV: driver for
> framebuffer: fbdev [    19.356] (++) using VT number 7
>=20
> [    19.373] (II) intel(0): SNA compiled: xserver-xorg-video-intel=20
> 2:2.99.907-0ubuntu1 (Maarten Lankhorst
> <maarten.lankhorst@ubuntu.com>) [    19.379] (WW) Falling back to
> old probe method for vesa [    19.379] (WW) Falling back to old
> probe method for modesetting [    19.379] (WW) Falling back to old
> probe method for fbdev [    19.379] (II) Loading sub module
> "fbdevhw" [    19.379] (II) LoadModule: "fbdevhw" [    19.380] (II)
> Loading /usr/lib/xorg/modules/libfbdevhw.so [    19.381] (II)
> Module fbdevhw: vendor=3D"X.Org Foundation" [    19.381] 	compiled
> for 1.14.5, module version =3D 0.0.2 [    19.381] 	ABI class: X.Org
> Video Driver, version 14.1 [    19.381] (--) intel(0): Integrated
> Graphics Chipset: Intel(R) HD Graphics 4000 [    19.381] (--)
> intel(0): CPU: x86-64, sse2, sse3, ssse3, sse4.1, sse4.2, avx [
> 19.381] (II) intel(0): Creating default Display subsection in=20
> Screen section "Default Screen Section" for depth/fbbpp 24/32 [
> 19.381] (=3D=3D) intel(0): Depth 24, (--) framebuffer bpp 32 [
> 19.381] (=3D=3D) intel(0): RGB weight 888 [    19.381] (=3D=3D) intel(0=
):
> Default visual is TrueColor [    19.382] (**) intel(0): Framebuffer
> tiled [    19.382] (**) intel(0): Pixmaps tiled [    19.382] (**)
> intel(0): "Tear free" disabled [    19.382] (**) intel(0): Forcing
> per-crtc-pixmaps? no [    19.384] (II) intel(0): Output eDP1 has no
> monitor section [    19.384] (--) intel(0): found backlight control
> interface acpi_video0 (type 'firmware') [    19.384] (II) intel(0):
> Output VGA1 has no monitor section [    19.384] (II) intel(0):
> Output HDMI1 has no monitor section [    19.384] (II) intel(0):
> Output DP1 has no monitor section [    19.384] (II) intel(0):
> Output HDMI2 has no monitor section [    19.384] (II) intel(0):
> Output DP2 has no monitor section [    19.384] (II) intel(0):
> Output VIRTUAL1 has no monitor section [    19.384] (--) intel(0):
> Output eDP1 using initial mode 1920x1080 on pipe 0 [    19.384]
> (--) intel(0): Output DP1 using initial mode 1920x1080 on pipe 1 [
> 19.384] (=3D=3D) intel(0): DPI set to (96, 96) [    19.384] (II)
> Loading sub module "dri2" [    19.384] (II) LoadModule: "dri2" [
> 19.384] (II) Module "dri2" already built-in [    19.384] (II)
> UnloadModule: "vesa" [    19.384] (II) Unloading vesa [    19.384]
> (II) UnloadModule: "modesetting" [    19.384] (II) Unloading
> modesetting [    19.384] (II) UnloadModule: "fbdev" [    19.384]
> (II) Unloading fbdev [    19.384] (II) UnloadSubModule: "fbdevhw" [
> 19.384] (II) Unloading fbdevhw [    19.384] (=3D=3D) Depth 24 pixmap
> format is 32 bpp [    19.391] (II) intel(0): SNA initialized with
> Ivybridge (gen7, gt2) backend [    19.391] (=3D=3D) intel(0): Backing
> store disabled [    19.391] (=3D=3D) intel(0): Silken mouse enabled [
> 19.391] (II) intel(0): HW Cursor enabled [    19.391] (II)
> intel(0): RandR 1.2 enabled, ignore the following RandR disabled
> message. [    19.391] (=3D=3D) intel(0): DPMS enabled [    19.391] (II)=

> intel(0): [DRI2] Setup complete [    19.391] (II) intel(0): [DRI2]
> DRI driver: i965 [    19.391] (II) intel(0): direct rendering: DRI2
> Enabled [    19.391] (=3D=3D) intel(0): hotplug detection: "enabled" [
> 19.391] (--) RandR disabled [    19.395] (II) SELinux: Disabled on
> system [    19.491] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer [
> 19.491] (II) AIGLX: enabled GLX_INTEL_swap_event [    19.491] (II)
> AIGLX: enabled GLX_ARB_create_context [    19.491] (II) AIGLX:
> enabled GLX_ARB_create_context_profile [    19.491] (II) AIGLX:
> enabled GLX_EXT_create_context_es2_profile [    19.491] (II) AIGLX:
> enabled GLX_SGI_swap_control and GLX_MESA_swap_control [    19.491]
> (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects [
> 19.492] (II) AIGLX: Loaded and initialized i965 [    19.492] (II)
> GLX: Initialized DRI2 GL provider for screen 0 [    19.494] (II)
> intel(0): switch to mode 1920x1080@60.0 on eDP1 using pipe 0,
> position (0, 0), rotation normal, reflection none [    19.504] (II)
> intel(0): switch to mode 1920x1080@60.0 on DP1 using pipe 1,
> position (0, 0), rotation normal, reflection none [    19.520] (II)
> intel(0): Setting screen physical size to 508 x 285 [    19.563]
> (II) XKB: generating xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 19.644] (II) config/udev: Adding input device Video Bus=20
> (/dev/input/event4) [    19.644] (**) Video Bus: Applying
> InputClass "evdev keyboard catchall" [    19.644] (II) LoadModule:
> "evdev" [    19.645] (II) Loading
> /usr/lib/xorg/modules/input/evdev_drv.so [    19.653] (II) Module
> evdev: vendor=3D"X.Org Foundation" [    19.653] 	compiled for 1.14.3,
> module version =3D 2.8.2 [    19.653] 	Module class: X.Org XInput
> Driver [    19.653] 	ABI class: X.Org XInput driver, version 19.1 [
> 19.653] (II) Using input driver 'evdev' for 'Video Bus' [
> 19.653] (**) Video Bus: always reports core events [    19.653]
> (**) evdev: Video Bus: Device: "/dev/input/event4" [    19.653]
> (--) evdev: Video Bus: Vendor 0 Product 0x6 [    19.653] (--)
> evdev: Video Bus: Found keys [    19.653] (II) evdev: Video Bus:
> Configuring as keyboard [    19.653] (**) Option "config_info"=20
> "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/i=
nput8/event4"
>
>=20
[    19.653] (II) XINPUT: Adding extended input device "Video Bus"
> (type: KEYBOARD, id 6) [    19.653] (**) Option "xkb_rules"
> "evdev" [    19.653] (**) Option "xkb_model" "pc105" [    19.653]
> (**) Option "xkb_layout" "us" [    19.653] (II) config/udev: Adding
> input device Power Button (/dev/input/event1) [    19.653] (**)
> Power Button: Applying InputClass "evdev keyboard catchall" [
> 19.653] (II) Using input driver 'evdev' for 'Power Button' [
> 19.653] (**) Power Button: always reports core events [    19.653]
> (**) evdev: Power Button: Device: "/dev/input/event1" [    19.653]
> (--) evdev: Power Button: Vendor 0 Product 0x1 [    19.653] (--)
> evdev: Power Button: Found keys [    19.653] (II) evdev: Power
> Button: Configuring as keyboard [    19.653] (**) Option
> "config_info"=20
> "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1/event1=
"
>
>=20
[    19.653] (II) XINPUT: Adding extended input device "Power Button"
> (type: KEYBOARD, id 7) [    19.653] (**) Option "xkb_rules"
> "evdev" [    19.653] (**) Option "xkb_model" "pc105" [    19.653]
> (**) Option "xkb_layout" "us" [    19.654] (II) config/udev: Adding
> input device Lid Switch (/dev/input/event0) [    19.654] (II) No
> input driver specified, ignoring this device. [    19.654] (II)
> This device may have been added with another device file. [
> 19.654] (II) config/udev: Adding input device Sleep Button=20
> (/dev/input/event2) [    19.654] (**) Sleep Button: Applying
> InputClass "evdev keyboard catchall" [    19.654] (II) Using input
> driver 'evdev' for 'Sleep Button' [    19.654] (**) Sleep Button:
> always reports core events [    19.654] (**) evdev: Sleep Button:
> Device: "/dev/input/event2" [    19.654] (--) evdev: Sleep Button:
> Vendor 0 Product 0x3 [    19.654] (--) evdev: Sleep Button: Found
> keys [    19.654] (II) evdev: Sleep Button: Configuring as
> keyboard [    19.654] (**) Option "config_info"=20
> "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2/event2=
"
>
>=20
[    19.654] (II) XINPUT: Adding extended input device "Sleep Button"
> (type: KEYBOARD, id 8) [    19.654] (**) Option "xkb_rules"
> "evdev" [    19.654] (**) Option "xkb_model" "pc105" [    19.654]
> (**) Option "xkb_layout" "us" [    19.654] (II) config/udev: Adding
> drm device (/dev/dri/card0) [    19.654] (II) config/udev: Ignoring
> already known drm device (/dev/dri/card0) [    19.655] (II)
> config/udev: Adding input device USB Camera (/dev/input/event8) [
> 19.655] (**) USB Camera: Applying InputClass "evdev keyboard=20
> catchall" [    19.655] (II) Using input driver 'evdev' for 'USB
> Camera' [    19.655] (**) USB Camera: always reports core events [
> 19.655] (**) evdev: USB Camera: Device: "/dev/input/event8" [
> 19.655] (--) evdev: USB Camera: Vendor 0x4f2 Product 0xb379 [
> 19.655] (--) evdev: USB Camera: Found keys [    19.655] (II) evdev:
> USB Camera: Configuring as keyboard [    19.655] (**) Option
> "config_info"=20
> "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/inp=
ut/input16/event8"
>
>=20
[    19.655] (II) XINPUT: Adding extended input device "USB Camera"
> (type: KEYBOARD, id 9) [    19.655] (**) Option "xkb_rules"
> "evdev" [    19.655] (**) Option "xkb_model" "pc105" [    19.655]
> (**) Option "xkb_layout" "us" [    19.655] (II) config/udev: Adding
> input device USB Camera (/dev/input/event9) [    19.655] (**) USB
> Camera: Applying InputClass "evdev keyboard catchall" [    19.655]
> (II) Using input driver 'evdev' for 'USB Camera' [    19.655] (**)
> USB Camera: always reports core events [    19.655] (**) evdev: USB
> Camera: Device: "/dev/input/event9" [    19.655] (--) evdev: USB
> Camera: Vendor 0x4f2 Product 0xb379 [    19.655] (--) evdev: USB
> Camera: Found keys [    19.655] (II) evdev: USB Camera: Configuring
> as keyboard [    19.655] (**) Option "config_info"=20
> "udev:/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.2/inp=
ut/input17/event9"
>
>=20
[    19.655] (II) XINPUT: Adding extended input device "USB Camera"
> (type: KEYBOARD, id 10) [    19.655] (**) Option "xkb_rules"
> "evdev" [    19.655] (**) Option "xkb_model" "pc105" [    19.655]
> (**) Option "xkb_layout" "us" [    19.655] (II) config/udev: Adding
> input device HDA Intel PCH Headphone (/dev/input/event7) [
> 19.655] (II) No input driver specified, ignoring this device. [
> 19.655] (II) This device may have been added with another device=20
> file. [    19.656] (II) config/udev: Adding input device HDA Intel
> PCH HDMI/DP,pcm=3D3 (/dev/input/event6) [    19.656] (II) No input
> driver specified, ignoring this device. [    19.656] (II) This
> device may have been added with another device file. [    19.656]
> (II) config/udev: Adding input device Asus WMI hotkeys=20
> (/dev/input/event5) [    19.656] (**) Asus WMI hotkeys: Applying
> InputClass "evdev keyboard catchall" [    19.656] (II) Using input
> driver 'evdev' for 'Asus WMI hotkeys' [    19.656] (**) Asus WMI
> hotkeys: always reports core events [    19.656] (**) evdev: Asus
> WMI hotkeys: Device: "/dev/input/event5" [    19.656] (--) evdev:
> Asus WMI hotkeys: Vendor 0 Product 0 [    19.656] (--) evdev: Asus
> WMI hotkeys: Found keys [    19.656] (II) evdev: Asus WMI hotkeys:
> Configuring as keyboard [    19.656] (**) Option "config_info"=20
> "udev:/sys/devices/platform/asus-nb-wmi/input/input13/event5" [
> 19.656] (II) XINPUT: Adding extended input device "Asus WMI=20
> hotkeys" (type: KEYBOARD, id 11) [    19.656] (**) Option
> "xkb_rules" "evdev" [    19.656] (**) Option "xkb_model" "pc105" [
> 19.656] (**) Option "xkb_layout" "us" [    19.656] (II)
> config/udev: Adding input device AT Translated Set 2 keyboard
> (/dev/input/event3) [    19.656] (**) AT Translated Set 2 keyboard:
> Applying InputClass "evdev keyboard catchall" [    19.656] (II)
> Using input driver 'evdev' for 'AT Translated Set 2 keyboard' [
> 19.656] (**) AT Translated Set 2 keyboard: always reports core
> events [    19.656] (**) evdev: AT Translated Set 2 keyboard:
> Device: "/dev/input/event3" [    19.656] (--) evdev: AT Translated
> Set 2 keyboard: Vendor 0x1 Product 0x1 [    19.656] (--) evdev: AT
> Translated Set 2 keyboard: Found keys [    19.656] (II) evdev: AT
> Translated Set 2 keyboard: Configuring as keyboard [    19.656]
> (**) Option "config_info"=20
> "udev:/sys/devices/platform/i8042/serio0/input/input3/event3" [
> 19.656] (II) XINPUT: Adding extended input device "AT Translated=20
> Set 2 keyboard" (type: KEYBOARD, id 12) [    19.656] (**) Option
> "xkb_rules" "evdev" [    19.656] (**) Option "xkb_model" "pc105" [
> 19.656] (**) Option "xkb_layout" "us" [    19.657] (II)
> config/udev: Adding input device ETPS/2 Elantech Touchpad
> (/dev/input/event10) [    19.657] (**) ETPS/2 Elantech Touchpad:
> Applying InputClass "evdev touchpad catchall" [    19.657] (**)
> ETPS/2 Elantech Touchpad: Applying InputClass "touchpad catchall" [
> 19.657] (**) ETPS/2 Elantech Touchpad: Applying InputClass "Default
> clickpad buttons" [    19.657] (II) LoadModule: "synaptics" [
> 19.657] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so [
> 19.658] (II) Module synaptics: vendor=3D"X.Org Foundation" [
> 19.658] 	compiled for 1.14.2, module version =3D 1.7.1 [    19.658]
> Module class: X.Org XInput Driver [    19.658] 	ABI class: X.Org
> XInput driver, version 19.1 [    19.658] (II) Using input driver
> 'synaptics' for 'ETPS/2 Elantech Touchpad' [    19.658] (**) ETPS/2
> Elantech Touchpad: always reports core events [    19.658] (**)
> Option "Device" "/dev/input/event10" [    19.684] (II) synaptics:
> ETPS/2 Elantech Touchpad: found clickpad property [    19.684] (--)
> synaptics: ETPS/2 Elantech Touchpad: x-axis range 0 - 3260 (res
> 32) [    19.684] (--) synaptics: ETPS/2 Elantech Touchpad: y-axis
> range 0 - 2119 (res 32) [    19.684] (--) synaptics: ETPS/2
> Elantech Touchpad: pressure range 0 - 255 [    19.684] (--)
> synaptics: ETPS/2 Elantech Touchpad: finger width range 0 - 15 [
> 19.684] (--) synaptics: ETPS/2 Elantech Touchpad: buttons: left=20
> double triple [    19.684] (--) synaptics: ETPS/2 Elantech
> Touchpad: Vendor 0x2 Product 0xe [    19.684] (**) Option
> "SoftButtonAreas" "50% 0 82% 0 0 0 0 0" [    19.684] (--)
> synaptics: ETPS/2 Elantech Touchpad: touchpad found [    19.684]
> (**) ETPS/2 Elantech Touchpad: always reports core events [
> 19.696] (**) Option "config_info"=20
> "udev:/sys/devices/platform/i8042/serio4/input/input12/event10" [
> 19.696] (II) XINPUT: Adding extended input device "ETPS/2 Elantech
> Touchpad" (type: TOUCHPAD, id 13) [    19.696] (**) synaptics:
> ETPS/2 Elantech Touchpad: (accel) MinSpeed is now constant
> deceleration 2.5 [    19.696] (**) synaptics: ETPS/2 Elantech
> Touchpad: (accel) MaxSpeed is now 1.75 [    19.696] (**) synaptics:
> ETPS/2 Elantech Touchpad: (accel) AccelFactor is now 0.051 [
> 19.696] (**) ETPS/2 Elantech Touchpad: (accel) keeping acceleration
> scheme 1 [    19.696] (**) ETPS/2 Elantech Touchpad: (accel)
> acceleration profile 1 [    19.696] (**) ETPS/2 Elantech Touchpad:
> (accel) acceleration factor: 2.000 [    19.696] (**) ETPS/2
> Elantech Touchpad: (accel) acceleration threshold: 4 [    19.696]
> (--) synaptics: ETPS/2 Elantech Touchpad: touchpad found [
> 19.696] (II) config/udev: Adding input device ETPS/2 Elantech=20
> Touchpad (/dev/input/mouse0) [    19.697] (**) ETPS/2 Elantech
> Touchpad: Ignoring device from InputClass "touchpad ignore
> duplicates" [    21.168] (II) intel(0): EDID vendor "CMN", prod id
> 4934 [    21.168] (II) intel(0): Printing DDC gathered Modelines: [
> 21.168] (II) intel(0): Modeline "1920x1080"x0.0  138.78  1920 1966
> 1996 2080  1080 1082 1086 1112 -hsync -vsync (66.7 kHz eP) [
> 21.168] (II) intel(0): Modeline "1920x1080"x0.0   92.52  1920 1966
> 1996 2080  1080 1082 1086 1112 -hsync -vsync (44.5 kHz e) [
> 23.798] (II) intel(0): resizing framebuffer to 3840x1080 [
> 23.798] (II) intel(0): switch to mode 1920x1080@60.0 on eDP1 using
> pipe 0, position (0, 0), rotation normal, reflection none [
> 23.824] (II) intel(0): switch to mode 1920x1080@60.0 on DP1 using=20
> pipe 1, position (0, 0), rotation normal, reflection none [
> 23.840] (II) intel(0): switch to mode 1920x1080@60.0 on DP1 using=20
> pipe 1, position (1920, 0), rotation normal, reflection none [
> 23.915] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.167] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.226] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.285] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.350] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.360] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.365] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.461] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.467] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 24.488] (II) XKB: reuse xkmfile=20
> /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm [
> 26.037] (II) XKB: generating xkmfile=20
> /var/lib/xkb/server-CB537B66032B0DBE0AE956F537017A59DB020654.xkm [
> 27.490] (II) config/udev: Adding input device N-trig DuoSense=20
> (/dev/input/mouse2) [    27.490] (II) No input driver specified,
> ignoring this device. [    27.490] (II) This device may have been
> added with another device file. [    27.490] (II) config/udev:
> Adding input device N-trig DuoSense Pen (/dev/input/event11) [
> 27.490] (**) N-trig DuoSense Pen: Applying InputClass "evdev tablet
> catchall" [    27.490] (II) Using input driver 'evdev' for 'N-trig
> DuoSense Pen' [    27.490] (**) N-trig DuoSense Pen: always reports
> core events [    27.490] (**) evdev: N-trig DuoSense Pen: Device:
> "/dev/input/event11" [    27.490] (--) evdev: N-trig DuoSense Pen:
> Vendor 0x1b96 Product 0x1001 [    27.490] (--) evdev: N-trig
> DuoSense Pen: Found 1 mouse buttons [    27.490] (--) evdev: N-trig
> DuoSense Pen: Found absolute axes [    27.490] (--) evdev: N-trig
> DuoSense Pen: Found x and y absolute axes [    27.490] (--) evdev:
> N-trig DuoSense Pen: Found absolute tablet. [    27.490] (II)
> evdev: N-trig DuoSense Pen: Configuring as tablet [    27.490] (**)
> evdev: N-trig DuoSense Pen: YAxisMapping: buttons 4 and 5 [
> 27.490] (**) evdev: N-trig DuoSense Pen: EmulateWheelButton: 4,=20
> EmulateWheelInertia: 10, EmulateWheelTimeout: 200 [    27.490] (**)
> Option "config_info"=20
> "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/inp=
ut/input18/event11"
>
>=20
[    27.490] (II) XINPUT: Adding extended input device "N-trig
> DuoSense Pen" (type: TABLET, id 14) [    27.490] (II) evdev: N-trig
> DuoSense Pen: initialized for absolute axes. [    27.490] (**)
> N-trig DuoSense Pen: (accel) keeping acceleration scheme 1 [
> 27.490] (**) N-trig DuoSense Pen: (accel) acceleration profile 0 [
> 27.490] (**) N-trig DuoSense Pen: (accel) acceleration factor:
> 2.000 [    27.490] (**) N-trig DuoSense Pen: (accel) acceleration
> threshold: 4 [    27.491] (II) config/udev: Adding input device
> N-trig DuoSense (/dev/input/event12) [    27.491] (**) N-trig
> DuoSense: Applying InputClass "evdev touchscreen catchall" [
> 27.491] (II) Using input driver 'evdev' for 'N-trig DuoSense' [
> 27.491] (**) N-trig DuoSense: always reports core events [
> 27.491] (**) evdev: N-trig DuoSense: Device: "/dev/input/event12" [
> 27.491] (II) evdev: N-trig DuoSense: Using mtdev for this device [
> 27.491] (--) evdev: N-trig DuoSense: Vendor 0x1b96 Product 0x1001 [
> 27.491] (--) evdev: N-trig DuoSense: Found absolute axes [
> 27.491] (--) evdev: N-trig DuoSense: Found absolute multitouch
> axes [    27.491] (II) evdev: N-trig DuoSense: No buttons found,
> faking one. [    27.491] (--) evdev: N-trig DuoSense: Found x and y
> absolute axes [    27.491] (--) evdev: N-trig DuoSense: Found
> absolute touchscreen [    27.491] (II) evdev: N-trig DuoSense:
> Configuring as touchscreen [    27.491] (**) evdev: N-trig
> DuoSense: YAxisMapping: buttons 4 and 5 [    27.491] (**) evdev:
> N-trig DuoSense: EmulateWheelButton: 4, EmulateWheelInertia: 10,
> EmulateWheelTimeout: 200 [    27.491] (**) Option "config_info"=20
> "udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/inp=
ut/input19/event12"
>
>=20
[    27.491] (II) XINPUT: Adding extended input device "N-trig
> DuoSense" (type: TOUCHSCREEN, id 15) [    27.491] (II) evdev:
> N-trig DuoSense: initialized for absolute axes. [    27.492] (**)
> N-trig DuoSense: (accel) keeping acceleration scheme 1 [    27.492]
> (**) N-trig DuoSense: (accel) acceleration profile 0 [    27.492]
> (**) N-trig DuoSense: (accel) acceleration factor: 2.000 [
> 27.492] (**) N-trig DuoSense: (accel) acceleration threshold: 4 [
> 27.493] (II) config/udev: Adding input device N-trig DuoSense Pen=20
> (/dev/input/mouse1) [    27.493] (II) No input driver specified,
> ignoring this device. [    27.493] (II) This device may have been
> added with another device file. [    46.716] (II) intel(0):
> resizing framebuffer to 1920x1080 [    46.716] (II) intel(0):
> switch to mode 1920x1080@60.0 on eDP1 using pipe 0, position (0,
> 0), rotation normal, reflection none [    46.728] (II) intel(0):
> switch to mode 1920x1080@60.0 on DP1 using pipe 1, position (0, 0),
> rotation normal, reflection none [    53.261] (II) intel(0): switch
> to mode 1920x1080@60.0 on DP1 using pipe 0, position (0, 0),
> rotation normal, reflection none [    59.921] (II) intel(0): switch
> to mode 1920x1080@60.0 on eDP1 using pipe 0, position (0, 0),
> rotation normal, reflection none [    84.991] (II) intel(0):
> resizing framebuffer to 3840x1080 [    84.991] (II) intel(0):
> switch to mode 1920x1080@60.0 on eDP1 using pipe 0, position (0,
> 0), rotation normal, reflection none [    85.024] (II) intel(0):
> switch to mode 1920x1080@60.0 on DP1 using pipe 1, position (1920,
> 0), rotation normal, reflection none [    90.409] (II) intel(0):
> resizing framebuffer to 1920x1080 [    90.410] (II) intel(0):
> switch to mode 1920x1080@60.0 on eDP1 using pipe 0, position (0,
> 0), rotation normal, reflection none [    90.424] (II) intel(0):
> switch to mode 1920x1080@60.0 on DP1 using pipe 1, position (0, 0),
> rotation normal, reflection none [   568.416] (II) intel(0): switch
> to mode 1920x1080@60.0 on eDP1 using pipe 0, position (0, 0),
> rotation normal, reflection none [   569.302] (II) intel(0): switch
> to mode 1920x1080@60.0 on DP1 using pipe 1, position (0, 0),
> rotation normal, reflection none (EE) [mi] EQ overflowing.
> Additional events will be discarded until existing events are
> processed. (EE) (EE) Backtrace: (EE) 0: /usr/bin/X
> (xorg_backtrace+0x3d) [0x7fe19f37491d] (EE) 1: /usr/bin/X
> (mieqEnqueue+0x22b) [0x7fe19f35688b] (EE) 2: /usr/bin/X
> (QueuePointerEvents+0x52) [0x7fe19f23da52] (EE) 3: /usr/bin/X
> (xf86PostMotionEvent+0xd6) [0x7fe19f273946] (EE) 4:
> /usr/lib/xorg/modules/input/synaptics_drv.so=20
> (0x7fe196246000+0x490f) [0x7fe19624a90f] (EE) 5:
> /usr/lib/xorg/modules/input/synaptics_drv.so=20
> (0x7fe196246000+0x6752) [0x7fe19624c752] (EE) 6: /usr/bin/X
> (0x7fe19f1d2000+0x91de8) [0x7fe19f263de8] (EE) 7: /usr/bin/X
> (0x7fe19f1d2000+0xba700) [0x7fe19f28c700] (EE) 8:
> /lib/x86_64-linux-gnu/libpthread.so.0 (0x7fe19e2cf000+0x10330)=20
> [0x7fe19e2df330] (EE) 9: /lib/x86_64-linux-gnu/libc.so.6
> (ioctl+0x7) [0x7fe19cfd2867] (EE) 10:
> /usr/lib/x86_64-linux-gnu/libdrm.so.2 (drmIoctl+0x34)=20
> [0x7fe19e0c63a4] (EE) 11:
> /usr/lib/xorg/modules/drivers/intel_drv.so (0x7fe198d06000+0x61226)
> [0x7fe198d67226] (EE) 12:
> /usr/lib/xorg/modules/drivers/intel_drv.so (0x7fe198d06000+0x61c8d)
> [0x7fe198d67c8d] (EE) 13: /usr/bin/X (xf86DPMSSet+0x6f)
> [0x7fe19f29a55f] (EE) 14: /usr/bin/X (xf86SaveScreen+0x4a)
> [0x7fe19f29a63a] (EE) 15: /usr/bin/X (dixSaveScreens+0x215)
> [0x7fe19f255415] (EE) 16: /usr/bin/X (mieqProcessInputEvents+0x166)
> [0x7fe19f356df6] (EE) 17: /usr/bin/X (ProcessInputEvents+0x9)
> [0x7fe19f263f49] (EE) 18: /usr/bin/X (0x7fe19f1d2000+0x54fa2)
> [0x7fe19f226fa2] (EE) 19: /usr/bin/X (0x7fe19f1d2000+0x447aa)
> [0x7fe19f2167aa] (EE) 20: /lib/x86_64-linux-gnu/libc.so.6
> (__libc_start_main+0xf5) [0x7fe19cf02ed5] (EE) 21: /usr/bin/X
> (0x7fe19f1d2000+0x44aef) [0x7fe19f216aef] (EE) (EE) [mi] These
> backtraces from mieqEnqueue may point to a culprit higher up the
> stack. (EE) [mi] mieq is *NOT* the cause.  It is a victim. [
> 569.470] [mi] EQ processing has resumed after 6 dropped events. [
> 569.471] [mi] This may be caused my a misbehaving driver=20
> monopolizing the server's resources. [  1299.469] (II) intel(0):
> switch to mode 1920x1080@60.0 on eDP1 using pipe 0, position (0,
> 0), rotation normal, reflection none [  1300.356] (II) intel(0):
> switch to mode 1920x1080@60.0 on DP1 using pipe 1, position (0, 0),
> rotation normal, reflection none [  2093.505] (II) intel(0): switch
> to mode 1920x1080@60.0 on eDP1 using pipe 0, position (0, 0),
> rotation normal, reflection none [  2094.390] (II) intel(0): switch
> to mode 1920x1080@60.0 on DP1 using pipe 1, position (0, 0),
> rotation normal, reflection none
>=20
>=20
> [X.] Other notes, patches, fixes, workarounds: N/A
>=20
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQJ8BAEBCgBmBQJSz691XxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRDMjAzN0EzNzlGM0JGMzFGQ0VFOTJDNENE
RDNGNjFFNUYxMTMyRjY1AAoJEN0/YeXxEy9lNr8P/0/xC/eNJbzZvD8iicyExO7I
r4v+ZXbDAf7xEogmbZoJCHoDrZ1m14MRzyRw46Pu+EggLBYjTO07OtP/UIJKB5sF
emhgqL6LebqcUI6ykFIR0VZpuTVShwVCEeMqy2gpqietEWy8GBEYeQOm4zfqQ8hg
FMgmauYQZrJro2aIAHa4Cy3H0aY1zBEEYZYShpDw0YGJcmR51C8ksRO22ER0ffm0
wAdEuQAIWd7DFhSShsKSuc/zIWfGQ910l6KvRPKIVu1KuGCVP15HZGvZ8DYjLXLv
lvGxQn3pvaGu1uk1E1+G0uYILfbTek6FJFNyoga/ctXx7MihSneUCsj1i5N+NFfk
CV8YtXNGfV4jmJGk+Qa4PC8YSWvuPNMQIvZ2HhR1M4C8oaixiwcffMt7xCCEK17n
b/6uyOZPA68FO4hAyHoDCR1yXS+mC0AB5ORwqIfdOzkYu68nJxB3eZ60c2f+bztz
cLfydDW+S4ZQxHJ4NxFMPN7I3dmd74/gV79l7Qz47zCVoyzCVRo/vzFaImtUPl//
oB8ubeyYxm/JST+nrb7ksZeKUQFhwJPDEFiMIfqJdXj2V0iPShfvxmtU5xN5F7iC
N6z7eA97dT+WE6MA5v0l/sIPy5LL/H7aAqEUbUJBFFYUnXsmeV6xav0ch8LxcA7w
G/8gd3OSWdxYKHd4UujH
=3DG4Fm
-----END PGP SIGNATURE-----


--------------ms050901080903020008090504
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKRTCC
BRowggQCoAMCAQICEG0Z6qcZT2ozIuYiMnqqcd4wDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
RW1haWwwHhcNMTEwNDI4MDAwMDAwWhcNMjAwNTMwMTA0ODM4WjCBkzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAJKEhFtLV5jUXi+LpOFAyKNTWF9mZfEyTvefMn1V0HhMVbdClOD5J3EHxcZppLkyxPFA
GpDMJ1Zifxe1cWmu5SAb5MtjXmDKokH2auGj/7jfH0htZUOMKi4rYzh337EXrMLaggLW1DJq
1GdvIBOPXDX65VSAr9hxCh03CgJQU2yVHakQFLSZlVkSMf8JotJM3FLb3uJAAVtIaN3FSrTg
7SQfOq9xXwfjrL8UO7AlcWg99A/WF1hGFYE8aIuLgw9teiFX5jSw2zJ+40rhpVJyZCaRTqWS
D//gsWD9Gm9oUZljjRqLpcxCm5t9ImPTqaD8zp6Q30QZ9FxbNboW86eb/8ECAwEAAaOCAUsw
ggFHMB8GA1UdIwQYMBaAFImCZ33EnSZwAEu0UEh83j2uBG59MB0GA1UdDgQWBBR6E04AdFvG
eGNkJ8Ev4qBbvHnFezAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADARBgNV
HSAECjAIMAYGBFUdIAAwWAYDVR0fBFEwTzBNoEugSYZHaHR0cDovL2NybC51c2VydHJ1c3Qu
Y29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwdAYI
KwYBBQUHAQEEaDBmMD0GCCsGAQUFBzAChjFodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVRO
QWRkVHJ1c3RDbGllbnRfQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1
c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCF1r54V1VtM39EUv5C1QaoAQOAivsNsv1Kv/av
QUn1G1rF0q0bc24+6SZ85kyYwTAo38v7QjyhJT4KddbQPTmGZtGhm7VNm2+vKGwdr+XqdFqo
2rHA8XV6L566k3nK/uKRHlZ0sviN0+BDchvtj/1gOSBH+4uvOmVIPJg9pSW/ve9g4EnlFsjr
P0OD8ODuDcHTzTNfm9C9YGqzO/761Mk6PB/tm/+bSTO+Qik5g+4zaS6CnUVNqGnagBsePdIa
XXxHmaWbCG0SmYbWXVcHG6cwvktJRLiQfsrReTjrtDP6oDpdJlieYVUYtCHVmdXgQ0BCML7q
peeU0rD+83X5f27nMIIFIzCCBAugAwIBAgIQJ3QU8LUx4O3UtD+MKZ9+RzANBgkqhkiG9w0B
AQUFADCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENP
TU9ETyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xMzA1
MTQwMDAwMDBaFw0xNDA1MTQyMzU5NTlaMCIxIDAeBgkqhkiG9w0BCQEWEWF4ZWwuaHVlYmxA
d2ViLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0lK/kxYlQPbZv9UNFwyN
V0CxKIc6MZ5zXDre+Rw6Uv24k6KmYYbRznS7Mi2o9IK7wCzyEY328mRqY6q36hXBrl1OTSuP
/s2rJ7U69/6JOJOBEQwJOUe6aZUhqocVAShU+C1agj/UTHNhHg4CcAD+nooNVUrwbbbe/CE2
hcNXWfNmuoHADdBVdyfcGaT+zwPvRh55RacezgxL6xTeVSx615TFf/PnM0pAO+Yjm7iFVKEw
MJyKE1v4gAyTYVfOut5qzKnBg6fXy8G395l1hO0SnxkHSPp6UoxL23Z5nvYveLrl+3jrZYE2
Knu1n4xXDtDdfuI0uL4yiNpm7hc1Uf59jQIDAQABo4IB4TCCAd0wHwYDVR0jBBgwFoAUehNO
AHRbxnhjZCfBL+KgW7x5xXswHQYDVR0OBBYEFOdMWCLyLg+KHqadhKEj9N+Y2sGkMA4GA1Ud
DwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1UdJQQZMBcGCCsGAQUFBwMEBgsrBgEEAbIx
AQMFAjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAQEwKzAp
BggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwVwYDVR0fBFAwTjBM
oEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPQ2xpZW50QXV0aGVudGljYXRp
b25hbmRTZWN1cmVFbWFpbENBLmNybDCBiAYIKwYBBQUHAQEEfDB6MFIGCCsGAQUFBzAChkZo
dHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9DbGllbnRBdXRoZW50aWNhdGlvbmFuZFNl
Y3VyZUVtYWlsQ0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20w
HAYDVR0RBBUwE4ERYXhlbC5odWVibEB3ZWIuZGUwDQYJKoZIhvcNAQEFBQADggEBADImMW+g
FmD3DPpnu5lhrs2zLAJnRr6rXPJ5U8MKJ1zmSAjulBbgMhULLFk1Bc0yusU17PV0qqlFQoMX
TfoLaoZd6dj2TZoZbYLIUDrI/E8443MP7SKEHh1dJW1zDr65WkW2cl56fykyIJcwemjv7VYI
lT6H7WeYr8n4CptFpzzfZe0Dei7JGwmqV5d4xOPchbm/L/WbjlS/EXwhRMNRyDdijdESI8w/
bXMrWmo8UFTtW6skMHDDNF5W7DJCNkvberYp4QeKWWfMnUj4y/y3DSibOEWff1AeSi7oP6or
YerzgWcNLbrxsznBCJrGgDCVITtDhVKXhPLsXUGGhXhExaExggQZMIIEFQIBATCBqDCBkzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGll
bnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQJ3QU8LUx4O3UtD+MKZ9+
RzAJBgUrDgMCGgUAoIICRTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0xNDAxMTAwODI5NDFaMCMGCSqGSIb3DQEJBDEWBBRxlysRTG+7xo2N9vX4O/4FLz1C
HDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcN
AwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMC
AgEoMIG5BgkrBgEEAYI3EAQxgaswgagwgZMxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVh
dGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBM
aW1pdGVkMTkwNwYDVQQDEzBDT01PRE8gQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1
cmUgRW1haWwgQ0ECECd0FPC1MeDt1LQ/jCmffkcwgbsGCyqGSIb3DQEJEAILMYGroIGoMIGT
MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdT
YWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENs
aWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhAndBTwtTHg7dS0P4wp
n35HMA0GCSqGSIb3DQEBAQUABIIBACVpGLnigCeuiT7UsmeQi6PwdsdKTIB8oxvBm2hUAa9r
yMGiNwZzXPEVFDsXzQrUhBxCjG83whLTpE4EgrbKhpc6tKtFW0Z5TiEEGOJ3aYaTnAEBbPyo
K4Ud15y8DlStiJaybkTQOBa5U543sssyZXMJBmlCWgOuUn3XmVh6/oXkfHDuBNYdjY1jsVR8
JVLKGGPqNDyv1QZXyzH+qQnMy7KHwQP6U8JhMecIF9Pa5GK62LwmShADXF4UCmj7puUyC382
bGGKxVch40fS2eoOEcIImvhSrdIwETx5qlnQxXLRLrnn2FhSFaKs6g5Kan4EtQ+u0ArhcfSh
HGw4aUEbQYIAAAAAAAA=
--------------ms050901080903020008090504--
