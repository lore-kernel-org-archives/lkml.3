Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbaJCWhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:37:03 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57522 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbaJCWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:36:52 -0400
MIME-Version: 1.0
Date: Fri, 3 Oct 2014 16:36:49 -0600
X-Google-Sender-Auth: _aJhqoG8_12KkaNgFGUxbJkyLjQ
Message-ID: <CADyGkNRc3dnYfipSNFGj3_r6Y8vuTVsiAbzRB0UWCqqd-9Pf6Q@mail.gmail.com>
Subject: Displaylink Attached Display Adapater and Monitor Not Recognized
From: Dennis Gesker <dennis@gesker.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Displaylink USB 3.0 Attached Display Adapater and Monitor Not Recognized
DisplayLink Plug and Play Universal docking Station
DELL
Model: D3000
MFG: ACP075US
SN: 1309017059


Apologies in advance if I'm posting to the wrong list.

I began by filing this as a bug on launchpad.net.
Folks on that site indicated that it should be filed at kernel.org as
it is upstream but not until after asking first on the mailling lists.

My issue touches many parts usb/graphics/laptops/etc so I tried to
choose what I thought was the most general list: linux-x86_64

Since the chip set in this docking station (port replicator) is a
little newer it was suggested on the linux-x86_64@vger.kernel.org that
perhaps I should post to linux-kernel.

Below is my collected information.

Please let me know If I should post to a different list or if this is
OK to file in the bug system. Or, if since this chip set might be
considered newer, if should file a feature/enhancement request in the
bug system.

Thanks,
Dennis

[1.] One line summary of the problem:

Displaylink Attached Display Adapater and Monitor Not Recognized

[2.] Full description of the problem/report:

DisplayLink Plug and Play Universal docking Station
DELL
Model: D3000
MFG: ACP075US
SN: 1309017059

All ports on the device are recocognized and function correctly except
the display adapter. My intention is to drive 2 external monitors with
this device.

[3.] Keywords

[4.] Kernel version

Linux version 3.17.0-031700rc7-generic (apw@gomeisa) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201409281835 SMP Sun Sep 28
22:36:30 UTC 2014

[5.] Output of Oops

N/A

[6.] A small shell script or example program which triggers the
problem (if possible)

N/A

[7.] Environment

Description: Ubuntu Utopic Unicorn (development branch)
Release: 14.10

[7.1.] Software (add the output of the ver_linux script here)

linux-headers-3.17.0-031700rc7-generic_3.17.0-031700rc7.201409281835_amd64.deb
failed to install. Could not override with --force. So, could not run
ver_linux script.

[7.2.] Processor information (from /proc/cpuinfo):

processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1290.335
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 0
cpu cores : 4
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1224.031
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 1
cpu cores : 4
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1226.636
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 2
cpu cores : 4
apicid : 4
initial apicid : 4
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1232.027
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 3
cpu cores : 4
apicid : 6
initial apicid : 6
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 4
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1213.878
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 0
cpu cores : 4
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 5
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1234.992
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 1
cpu cores : 4
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 6
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1210.375
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 2
cpu cores : 4
apicid : 5
initial apicid : 5
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 7
vendor_id : GenuineIntel
cpu family : 6
model : 58
model name : Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping : 9
microcode : 0x12
cpu MHz : 1316.210
cache size : 6144 KB
physical id : 0
siblings : 8
core id : 3
cpu cores : 4
apicid : 7
initial apicid : 7
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl
vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb pln
pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms
xsaveopt
bugs :
bogomips : 4589.68
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):

arc4 12573 2 - Live 0xffffffffc052b000
iwldvm 243857 0 - Live 0xffffffffc0c4d000
mac80211 696913 1 iwldvm, Live 0xffffffffc0ba1000
snd_hda_codec_hdmi 52620 1 - Live 0xffffffffc06c5000
snd_hda_codec_via 32006 1 - Live 0xffffffffc0702000
snd_hda_codec_generic 70087 1 snd_hda_codec_via, Live 0xffffffffc06d7000
iwlwifi 190863 1 iwldvm, Live 0xffffffffc0b71000
cfg80211 514757 3 iwldvm,mac80211,iwlwifi, Live 0xffffffffc0af2000
rtsx_pci_ms 18337 0 - Live 0xffffffffc06bf000
memstick 16968 1 rtsx_pci_ms, Live 0xffffffffc05aa000
hid_generic 12559 0 - Live 0xffffffffc0a22000
usbhid 53122 0 - Live 0xffffffffc09ec000
hid 110572 2 hid_generic,usbhid, Live 0xffffffffc0c98000
intel_rapl 19196 0 - Live 0xffffffffc0a34000
x86_pkg_temp_thermal 14312 0 - Live 0xffffffffc094d000
intel_powerclamp 19099 0 - Live 0xffffffffc0947000
coretemp 13638 0 - Live 0xffffffffc0957000
kvm_intel 149257 0 - Live 0xffffffffc09c6000
kvm 468567 1 kvm_intel, Live 0xffffffffc0a7e000
crct10dif_pclmul 14268 0 - Live 0xffffffffc09c1000
crc32_pclmul 13180 0 - Live 0xffffffffc095c000
ghash_clmulni_intel 13230 0 - Live 0xffffffffc0a79000
aesni_intel 165469 0 - Live 0xffffffffc0997000
aes_x86_64 17131 1 aesni_intel, Live 0xffffffffc098c000
lrw 13323 1 aesni_intel, Live 0xffffffffc0987000
gf128mul 14951 1 lrw, Live 0xffffffffc0992000
uvcvideo 86628 0 - Live 0xffffffffc0966000
glue_helper 14095 1 aesni_intel, Live 0xffffffffc0961000
ablk_helper 13597 1 aesni_intel, Live 0xffffffffc0952000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0xffffffffc0935000
cryptd 20531 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0xffffffffc0940000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0xffffffffc093b000
videobuf2_core 59907 1 uvcvideo, Live 0xffffffffc08f2000
v4l2_common 15715 1 videobuf2_core, Live 0xffffffffc08bb000
videodev 163831 3 uvcvideo,videobuf2_core,v4l2_common, Live 0xffffffffc090c000
joydev 17587 0 - Live 0xffffffffc0902000
snd_usb_audio 164122 0 - Live 0xffffffffc08c8000
cdc_ether 14410 0 - Live 0xffffffffc08b6000
tpm_infineon 17169 0 - Live 0xffffffffc08c2000
usbnet 44000 1 cdc_ether, Live 0xffffffffc0893000
media 22008 2 uvcvideo,videodev, Live 0xffffffffc08af000
snd_usbmidi_lib 30597 1 snd_usb_audio, Live 0xffffffffc08a2000
serio_raw 13483 0 - Live 0xffffffffc088e000
wmi 19379 0 - Live 0xffffffffc0884000
intel_smartconnect 12637 0 - Live 0xffffffffc0848000
snd_hda_intel 30783 3 - Live 0xffffffffc0874000
snd_hda_controller 32234 1 snd_hda_intel, Live 0xffffffffc083f000
snd_hda_codec 145035 5
snd_hda_codec_hdmi,snd_hda_codec_via,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
Live 0xffffffffc084f000
snd_hwdep 17709 2 snd_usb_audio,snd_hda_codec, Live 0xffffffffc07f1000
snd_pcm 105052 5
snd_hda_codec_hdmi,snd_usb_audio,snd_hda_intel,snd_hda_controller,snd_hda_codec,
Live 0xffffffffc0824000
snd_seq_midi 13564 0 - Live 0xffffffffc0813000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0xffffffffc07db000
snd_rawmidi 31197 2 snd_usbmidi_lib,snd_seq_midi, Live 0xffffffffc081b000
rfcomm 75114 8 - Live 0xffffffffc07ff000
bnep 19884 2 - Live 0xffffffffc07f9000
snd_seq 63540 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffc07e0000
btusb 32408 0 - Live 0xffffffffc07d2000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffc07cd000
snd_timer 30118 2 snd_pcm,snd_seq, Live 0xffffffffc074d000
bluetooth 477455 22 rfcomm,bnep,btusb, Live 0xffffffffc0757000
snd 84025 19 snd_hda_codec_hdmi,snd_hda_codec_via,snd_hda_codec_generic,snd_usb_audio,snd_usbmidi_lib,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer,
Live 0xffffffffc0737000
lpc_ich 21176 0 - Live 0xffffffffc071b000
mei_me 19524 0 - Live 0xffffffffc0711000
soundcore 15091 2 snd_hda_codec,snd, Live 0xffffffffc06ef000
shpchp 37216 0 - Live 0xffffffffc06f7000
mei 88810 1 mei_me, Live 0xffffffffc0593000
mac_hid 13275 0 - Live 0xffffffffc0526000
i915 993210 3 - Live 0xffffffffc05cb000
video 20569 1 i915, Live 0xffffffffc0530000
drm_kms_helper 99872 1 i915, Live 0xffffffffc05b1000
drm 318542 5 i915,drm_kms_helper, Live 0xffffffffc0544000
i2c_algo_bit 13564 1 i915, Live 0xffffffffc03ad000
parport_pc 32906 0 - Live 0xffffffffc051c000
ppdev 17711 0 - Live 0xffffffffc0513000
lp 17799 0 - Live 0xffffffffc03d5000
parport 42481 3 parport_pc,ppdev,lp, Live 0xffffffffc0538000
btrfs 935758 1 - Live 0xffffffffc042d000
xor 21411 1 btrfs, Live 0xffffffffc03ef000
raid6_pq 97812 1 btrfs, Live 0xffffffffc0414000
rtsx_pci_sdmmc 23718 0 - Live 0xffffffffc03c5000
psmouse 118039 0 - Live 0xffffffffc03f6000
r8169 77680 0 - Live 0xffffffffc03db000
ahci 30167 2 - Live 0xffffffffc03cc000
rtsx_pci 51162 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0xffffffffc03b7000
mii 13981 2 usbnet,r8169, Live 0xffffffffc03b2000
libahci 32533 1 ahci, Live 0xffffffffc03a4000

[7.4.] Loaded driver and hardware information (cat /proc/ioports; cat
/proc/iomem
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : PNP0C09:00
    0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : PNP0C09:00
    0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : PNP0C04:00
    00f0-00ff : fpu
  03c0-03df : vesafb
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-042f : ACPI GPE0_BLK
  0430-0433 : iTCO_wdt
  0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:03
  0458-047f : pnp 00:01
    0460-047f : iTCO_wdt
  04d0-04d1 : pnp 00:06
  0500-057f : pnp 00:01
  0680-069f : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-100f : pnp 00:01
  164e-164f : pnp 00:01
  3322-3323 : pnp 00:01
  e000-efff : PCI Bus 0000:03
    e000-e0ff : 0000:03:00.2
      e000-e0ff : r8169
  f000-f03f : 0000:00:02.0
  f040-f05f : 0000:00:1f.3
  f060-f07f : 0000:00:1f.2
    f060-f07f : ahci
  f080-f083 : 0000:00:1f.2
    f080-f083 : ahci
  f090-f097 : 0000:00:1f.2
    f090-f097 : ahci
  f0a0-f0a3 : 0000:00:1f.2
    f0a0-f0a3 : ahci
  f0b0-f0b7 : 0000:00:1f.2
    f0b0-f0b7 : ahci
  ffff-ffff : pnp 00:01
    ffff-ffff : pnp 00:01
00000000-00000fff : reserved
00001000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cefff : Video ROM
000cf000-000cffff : Adapter ROM
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
  000e0000-000e3fff : PCI Bus 0000:00
  000e4000-000e7fff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
  01000000-017a9a77 : Kernel code
  017a9a78-01d1e57f : Kernel data
  01e80000-01fc6fff : Kernel bss
20000000-201fffff : reserved
  20000000-201fffff : pnp 00:08
20200000-40003fff : System RAM
40004000-40004fff : reserved
  40004000-40004fff : pnp 00:08
40005000-d9c08fff : System RAM
d9c09000-da098fff : reserved
da099000-da099fff : ACPI Tables
da09a000-da1b7fff : ACPI Non-volatile Storage
da1b8000-da64dfff : reserved
da64e000-da64efff : System RAM
da64f000-da691fff : ACPI Non-volatile Storage
da692000-dad8cfff : System RAM
dad8d000-daff2fff : reserved
daff3000-daffffff : System RAM
db000000-db7fffff : RAM buffer
db800000-df9fffff : reserved
  dba00000-df9fffff : Graphics Stolen Memory
dfa00000-feafffff : PCI Bus 0000:00
  dfa00000-dfa00fff : pnp 00:07
  e0000000-efffffff : 0000:00:02.0
  f0000000-f00fffff : PCI Bus 0000:03
    f0000000-f0003fff : 0000:03:00.2
      f0000000-f0003fff : r8169
    f0004000-f0004fff : 0000:03:00.2
      f0004000-f0004fff : r8169
  f7800000-f7bfffff : 0000:00:02.0
  f7c00000-f7cfffff : PCI Bus 0000:03
    f7c00000-f7c0ffff : 0000:03:00.0
      f7c00000-f7c0ffff : rtsx_pci
  f7d00000-f7dfffff : PCI Bus 0000:02
    f7d00000-f7d01fff : 0000:02:00.0
      f7d00000-f7d01fff : iwlwifi
  f7e00000-f7e0ffff : 0000:00:14.0
    f7e00000-f7e0ffff : xhci_hcd
  f7e10000-f7e13fff : 0000:00:1b.0
    f7e10000-f7e13fff : ICH HD audio
  f7e15000-f7e150ff : 0000:00:1f.3
  f7e16000-f7e167ff : 0000:00:1f.2
    f7e16000-f7e167ff : ahci
  f7e17000-f7e173ff : 0000:00:1d.0
    f7e17000-f7e173ff : ehci_hcd
  f7e18000-f7e183ff : 0000:00:1a.0
    f7e18000-f7e183ff : ehci_hcd
  f7e1a000-f7e1a00f : 0000:00:16.0
    f7e1a000-f7e1a00f : mei_me
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:07
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed03fff : reserved
  fed00000-fed003ff : HPET 0
    fed00000-fed003ff : PNP0103:00
fed10000-fed17fff : pnp 00:07
fed18000-fed18fff : pnp 00:07
fed19000-fed19fff : pnp 00:07
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:07
    fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:07
fed40000-fed44fff : pnp 00:00
fed45000-fed8ffff : pnp 00:07
fed90000-fed93fff : pnp 00:07
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
  ff000000-ffffffff : INT0800:00
    ff000000-ffffffff : pnp 00:07
100000000-41f5fffff : System RAM
41f600000-41fffffff : RAM buffer
/proc/ioports, /proc/iomem)

[7.5.] PCI information ('lspci -vvv' as root)

lspci -vvv
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
 Latency: 0
 Capabilities: [e0] Vendor Specific Information: Len=0c <?>
 Kernel driver in use: ivb_uncore

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 28
 Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=4M]
 Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
 Region 4: I/O ports at f000 [size=64]
 Expansion ROM at <unassigned> [disabled]
 Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
  Address: feeff00c Data: 4122
 Capabilities: [d0] Power Management version 2
  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [a4] PCI Advanced Features
  AFCap: TP+ FLR+
  AFCtrl: FLR-
  AFStatus: TP-
 Kernel driver in use: i915

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 24
 Region 0: Memory at f7e00000 (64-bit, non-prefetchable) [size=64K]
 Capabilities: [70] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
  Address: 00000000fee1100c Data: 41b1
 Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210
Series Chipset Family MEI Controller #1 (rev 04)
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 29
 Region 0: Memory at f7e1a000 (64-bit, non-prefetchable) [size=16]
 Capabilities: [50] Power Management version 3
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000feeff00c Data: 4142
 Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 16
 Region 0: Memory at f7e18000 (32-bit, non-prefetchable) [size=1K]
 Capabilities: [50] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [58] Debug port: BAR=1 offset=00a0
 Capabilities: [98] PCI Advanced Features
  AFCap: TP+ FLR+
  AFCtrl: FLR-
  AFStatus: TP-
 Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin A routed to IRQ 30
 Region 0: Memory at f7e10000 (64-bit, non-prefetchable) [size=16K]
 Capabilities: [50] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000feeff00c Data: 4162
 Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
  DevCap: MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE-
  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
 Capabilities: [100 v1] Virtual Channel
  Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
  Arb: Fixed- WRR32- WRR64- WRR128-
  Ctrl: ArbSelect=Fixed
  Status: InProgress-
  VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
   Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
   Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
   Status: NegoPending- InProgress-
  VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
   Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
   Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=22
   Status: NegoPending- InProgress-
 Capabilities: [130 v1] Root Complex Link
  Desc: PortNumber=0f ComponentID=00 EltType=Config
  Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
   Addr: 00000000fed1c000
 Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
 I/O behind bridge: 0000f000-00000fff
 Memory behind bridge: fff00000-000fffff
 Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
 Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
 BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
  DevCap: MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE+
  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
  LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <1us, L1 <16us
   ClockPM- Surprise- LLActRep+ BwNot-
  LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk-
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
  SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
   Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
  SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
   Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
  SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
   Changed: MRL- PresDet- LinkState-
  RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
  RootCap: CRSVisible-
  RootSta: PME ReqID 0000, PMEStatus- PMEPending-
  DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
  LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
  Address: 00000000 Data: 0000
 Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 2702
 Capabilities: [a0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 3 (rev c4) (prog-if 00 [Normal decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
 I/O behind bridge: 0000f000-00000fff
 Memory behind bridge: f7d00000-f7dfffff
 Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
 Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
 BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
  DevCap: MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE+
  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
  LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <512ns, L1 <16us
   ClockPM- Surprise- LLActRep+ BwNot-
  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
  SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
   Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
  SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
   Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
  SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
   Changed: MRL- PresDet- LinkState-
  RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
  RootCap: CRSVisible-
  RootSta: PME ReqID 0000, PMEStatus- PMEPending-
  DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
  LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
  Address: 00000000 Data: 0000
 Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 2702
 Capabilities: [a0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 4 (rev c4) (prog-if 00 [Normal decode])
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
 I/O behind bridge: 0000e000-0000efff
 Memory behind bridge: f7c00000-f7cfffff
 Prefetchable memory behind bridge: 00000000f0000000-00000000f00fffff
 Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
 BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
 Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
  DevCap: MaxPayload 128 bytes, PhantFunc 0
   ExtTag- RBE+
  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
  LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <512ns, L1 <16us
   ClockPM- Surprise- LLActRep+ BwNot-
  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
  SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
   Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
  SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
   Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
  SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
   Changed: MRL- PresDet- LinkState-
  RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
  RootCap: CRSVisible-
  RootSta: PME ReqID 0000, PMEStatus- PMEPending-
  DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
  LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
  Address: 00000000 Data: 0000
 Capabilities: [90] Subsystem: CLEVO/KAPOK Computer Device 2702
 Capabilities: [a0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin A routed to IRQ 23
 Region 0: Memory at f7e17000 (32-bit, non-prefetchable) [size=1K]
 Capabilities: [50] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [58] Debug port: BAR=1 offset=00a0
 Capabilities: [98] PCI Advanced Features
  AFCap: TP+ FLR+
  AFCtrl: FLR-
  AFStatus: TP-
 Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC
Controller (rev 04)
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Capabilities: [e0] Vendor Specific Information: Len=0c <?>
 Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0
 Interrupt: pin B routed to IRQ 26
 Region 0: I/O ports at f0b0 [size=8]
 Region 1: I/O ports at f0a0 [size=4]
 Region 2: I/O ports at f090 [size=8]
 Region 3: I/O ports at f080 [size=4]
 Region 4: I/O ports at f060 [size=32]
 Region 5: Memory at f7e16000 (32-bit, non-prefetchable) [size=2K]
 Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
  Address: fee2200c Data: 41d1
 Capabilities: [70] Power Management version 3
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
 Capabilities: [b0] PCI Advanced Features
  AFCap: TP+ FLR+
  AFCtrl: FLR-
  AFStatus: TP-
 Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
 Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Interrupt: pin C routed to IRQ 3
 Region 0: Memory at f7e15000 (64-bit, non-prefetchable) [size=256]
 Region 4: I/O ports at f040 [size=32]

02:00.0 Network controller: Intel Corporation Centrino Wireless-N 1030
[Rainbow Peak] (rev 34)
 Subsystem: Intel Corporation Centrino Wireless-N 1030 BGN
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin A routed to IRQ 31
 Region 0: Memory at f7d00000 (64-bit, non-prefetchable) [size=8K]
 Capabilities: [c8] Power Management version 3
  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000fee0800c Data: 4172
 Capabilities: [e0] Express (v1) Endpoint, MSI 00
  DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
   ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
   MaxPayload 128 bytes, MaxReadReq 128 bytes
  DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
  LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s <4us, L1 <32us
   ClockPM+ Surprise- LLActRep- BwNot-
  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
 Capabilities: [100 v1] Advanced Error Reporting
  UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
  CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
 Capabilities: [140 v1] Device Serial Number 58-91-cf-ff-ff-52-e0-6d
 Kernel driver in use: iwlwifi

03:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
Device 5289 (rev 01)
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin B routed to IRQ 25
 Region 0: Memory at f7c00000 (32-bit, non-prefetchable) [size=64K]
 Capabilities: [40] Power Management version 3
  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000feeff00c Data: 41c1
 Capabilities: [70] Express (v2) Endpoint, MSI 00
  DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
   ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 512 bytes
  DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
  LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s unlimited, L1 <64us
   ClockPM+ Surprise- LLActRep- BwNot-
  LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk-
   ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
  DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
  LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
    Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
    Compliance De-emphasis: -6dB
  LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [b0] MSI-X: Enable- Count=1 Masked-
  Vector table: BAR=0 offset=00000000
  PBA: BAR=0 offset=00000000
 Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
  Not readable
 Capabilities: [100 v1] Advanced Error Reporting
  UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
  CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
 Capabilities: [140 v1] Virtual Channel
  Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
  Arb: Fixed- WRR32- WRR64- WRR128-
  Ctrl: ArbSelect=Fixed
  Status: InProgress-
  VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
   Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
   Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
   Status: NegoPending- InProgress-
 Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
 Kernel driver in use: rtsx_pci

03:00.2 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0a)
 Subsystem: CLEVO/KAPOK Computer Device 2702
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
 Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
 Latency: 0, Cache Line Size: 64 bytes
 Interrupt: pin A routed to IRQ 27
 Region 0: I/O ports at e000 [size=256]
 Region 2: Memory at f0004000 (64-bit, prefetchable) [size=4K]
 Region 4: Memory at f0000000 (64-bit, prefetchable) [size=16K]
 Capabilities: [40] Power Management version 3
  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
 Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
  Address: 00000000feeff00c Data: 41e1
 Capabilities: [70] Express (v2) Endpoint, MSI 01
  DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
   ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
   RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
   MaxPayload 128 bytes, MaxReadReq 4096 bytes
  DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
  LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s unlimited, L1 <64us
   ClockPM+ Surprise- LLActRep- BwNot-
  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
   ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
  DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not Supported
  DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
  LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
    EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
 Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
  Vector table: BAR=4 offset=00000000
  PBA: BAR=4 offset=00000800
 Capabilities: [d0] Vital Product Data
  Unknown small resource type 00, will not decode more.
 Capabilities: [100 v1] Advanced Error Reporting
  UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
  UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
  CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
  AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
 Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
 Kernel driver in use: r8169

[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA Model: Samsung SSD 840 Rev: BB6Q
  Type: Direct-Access ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: TSSTcorp Model: CDDVDW SN-208AB Rev: TC00
  Type: CD-ROM ANSI SCSI revision: 05

[7.7.] Other information that might be relevant to the problem (please
look in /proc and include all information that you think to be
relevant):

1 1460 187 201 2147 228 2346 2810 39 5 5207 5679 663 81 consoles
kpageflags sysrq-trigger
10 1498 188 2010 2148 2281 235 2819 41 5014 5226 5680 664 82 cpuinfo
loadavg sysvipc
11 15 189 2014 2150 2282 236 2820 42 5030 5229 57 665 872 crypto locks
thread-self
118 1505 19 2017 2151 2285 237 2873 428 5068 525 5754 669 9 devices
mdstat timer_list
119 1517 190 202 2152 2287 238 29 43 5083 5268 578 67 910 diskstats
meminfo timer_stats
12 1528 191 2025 2164 229 2394 2955 431 5084 53 5785 675 94 dma misc tty
1248 1533 192 2027 2170 23 24 2987 44 5087 532 5791 68 941 driver modules uptime
1253 1538 1927 2029 2174 230 25 3 45 5095 533 58 69 947 execdomains
mounts version
1254 16 1937 2030 2176 2303 2514 30 46 5096 5393 580 7 95 fb mtrr vmallocinfo
1261 17 1938 2032 218 2308 2540 31 47 5097 54 59 70 96 filesystems net vmstat
1262 179 1955 2035 22 231 2574 32 48 5098 543 61 71 960 fs pagetypeinfo zoneinfo
1267 18 1968 205 220 2318 26 3200 49 51 5445 62 714 964 interrupts partitions
1276 180 1973 2063 2209 2319 27 3261 4923 5100 549 63 715 97 iomem sched_debug
13 181 1974 2064 221 232 2708 33 4936 5101 55 639 72 98 ioports schedstat
1313 182 1991 209 222 2320 2750 34 4953 5105 5522 64 73 99 irq scsi
1315 183 1992 2094 223 2325 2758 3452 4954 5106 5538 642 74 acpi kallsyms self
1321 184 2 21 2233 2329 2772 348 4958 5108 56 644 75 asound kcore slabinfo
1374 1841 20 2100 224 233 2777 35 4962 511 561 647 76 buddyinfo keys softirqs
14 1842 200 2142 225 2337 2783 36 4963 5183 562 65 774 bus key-users stat
1401 185 2007 2144 226 2339 28 37 4971 52 5626 66 8 cgroups kmsg swaps
143 186 2008 2145 227 234 2806 38 4975 5206 564 662 80 cmdline kpagecount sys
root@drgnbk:~/Downloads#

[X.] Other notes, patches, fixes, workarounds:



This problem also exists under trusty. 14.04

My intention is to drive 2 external monitors with this device.
This specific device has no issues under Windows 8.1

ProblemType: Bug
DistroRelease: Ubuntu 14.10
Package: linux-image-3.16.0-20-generic 3.16.0-20.27
ProcVersionSignature: Ubuntu 3.16.0-20.27-generic 3.16.3
Uname: Linux 3.16.0-20-generic x86_64
ApportVersion: 2.14.7-0ubuntu2
Architecture: amd64
AudioDevicesInUse:
 USER PID ACCESS COMMAND
 /dev/snd/controlC0: gesker 2140 F.... pulseaudio
CurrentDesktop: Unity
Date: Thu Oct 2 08:54:53 2014
HibernationDevice: RESUME=UUID=8d719d41-d691-447b-8dd0-29bbdd631465
InstallationDate: Installed on 2014-08-24 (38 days ago)
InstallationMedia: Ubuntu 14.04.1 LTS "Trusty Tahr" - Release amd64 (20140722.2)
MachineType: System76, Inc. Gazelle Professional
ProcFB: 0 inteldrmfb
ProcKernelCmdLine: BOOT_IMAGE=/@/boot/vmlinuz-3.16.0-20-generic
root=UUID=5dc9a0a5-84ba-495e-b644-8d11f37bece5 ro rootflags=subvol=@
quiet splash vt.handoff=7
RelatedPackageVersions:
 linux-restricted-modules-3.16.0-20-generic N/A
 linux-backports-modules-3.16.0-20-generic N/A
 linux-firmware 1.134
SourcePackage: linux
UpgradeStatus: Upgraded to utopic on 2014-09-26 (5 days ago)
dmi.bios.date: 05/16/2012
dmi.bios.vendor: American Megatrends Inc.
dmi.bios.version: 4.6.5
dmi.board.asset.tag: Tag 12345
dmi.board.name: Gazelle Professional
dmi.board.vendor: System76, Inc.
dmi.board.version: gazp7
dmi.chassis.asset.tag: No Asset Tag
dmi.chassis.type: 9
dmi.chassis.vendor: No Enclosure
dmi.chassis.version: N/A
dmi.modalias: dmi:bvnAmericanMegatrendsInc.:bvr4.6.5:bd05/16/2012:svnSystem76,Inc.:pnGazelleProfessional:pvrgazp7:rvnSystem76,Inc.:rnGazelleProfessional:rvrgazp7:cvnNoEnclosure:ct9:cvrN/A:
dmi.product.name: Gazelle Professional
dmi.product.version: gazp7
dmi.sys.vendor: System76, Inc.



xOrg logs:

X.Org X Server 1.16.0
Release Date: 2014-07-16
[     9.901] X Protocol Version 11, Revision 0
[     9.901] Build Operating System: Linux 3.2.0-61-generic x86_64 Ubuntu
[     9.901] Current Operating System: Linux drgnbk
3.17.0-031700rc7-generic #201409281835 SMP Sun Sep 28 22:36:30 UTC
2014 x86_64
[     9.901] Kernel command line:
BOOT_IMAGE=/@/boot/vmlinuz-3.17.0-031700rc7-generic
root=UUID=5dc9a0a5-84ba-495e-b644-8d11f37bece5 ro rootflags=subvol=@
quiet splash vt.handoff=7
[     9.901] Build Date: 10 September 2014  01:10:01PM
[     9.901] xorg-server 2:1.16.0-1ubuntu1 (For technical support
please see http://www.ubuntu.com/support)
[     9.901] Current version of pixman: 0.32.4
[     9.901] Before reporting problems, check http://wiki.x.org
to make sure that you have the latest version.
[     9.901] Markers: (--) probed, (**) from config file, (==) default setting,
(++) from command line, (!!) notice, (II) informational,
(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[     9.901] (==) Log file: "/var/log/Xorg.0.log", Time: Thu Oct  2
10:42:03 2014
[     9.901] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[     9.901] (==) No Layout section.  Using the first Screen section.
[     9.901] (==) No screen section available. Using defaults.
[     9.901] (**) |-->Screen "Default Screen Section" (0)
[     9.901] (**) |   |-->Monitor "<default monitor>"
[     9.901] (==) No monitor specified for screen "Default Screen Section".
Using a default monitor configuration.
[     9.901] (==) Automatically adding devices
[     9.901] (==) Automatically enabling devices
[     9.901] (==) Automatically adding GPU devices
[     9.901] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
[     9.901] Entry deleted from font path.
[     9.901] (WW) The directory "/usr/share/fonts/X11/100dpi/" does not exist.
[     9.901] Entry deleted from font path.
[     9.901] (WW) The directory "/usr/share/fonts/X11/75dpi/" does not exist.
[     9.901] Entry deleted from font path.
[     9.901] (WW) The directory "/usr/share/fonts/X11/100dpi" does not exist.
[     9.901] Entry deleted from font path.
[     9.901] (WW) The directory "/usr/share/fonts/X11/75dpi" does not exist.
[     9.901] Entry deleted from font path.
[     9.901] (==) FontPath set to:
/usr/share/fonts/X11/misc,
/usr/share/fonts/X11/Type1,
built-ins
[     9.901] (==) ModulePath set to
"/usr/lib/x86_64-linux-gnu/xorg/extra-modules,/usr/lib/xorg/extra-modules,/usr/lib/xorg/modules"
[     9.901] (II) The server relies on udev to provide the list of
input devices.
If no devices become available, reconfigure udev or disable AutoAddDevices.
[     9.901] (II) Loader magic: 0x7fedb59b7d80
[     9.902] (II) Module ABI versions:
[     9.902] X.Org ANSI C Emulation: 0.4
[     9.902] X.Org Video Driver: 18.0
[     9.902] X.Org XInput driver : 21.0
[     9.902] X.Org Server Extension : 8.0
[     9.902] (II) xfree86: Adding drm device (/dev/dri/card0)
[     9.902] (--) PCI:*(0:0:2:0) 8086:0166:1558:2702 rev 9, Mem @
0xf7800000/4194304, 0xe0000000/268435456, I/O @ 0x0000f000/64
[     9.903] (II) LoadModule: "glx"
[     9.904] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[     9.912] (II) Module glx: vendor="X.Org Foundation"
[     9.912] compiled for 1.16.0, module version = 1.0.0
[     9.912] ABI class: X.Org Server Extension, version 8.0
[     9.912] (==) AIGLX enabled
[     9.912] (==) Matched intel as autoconfigured driver 0
[     9.912] (==) Matched intel as autoconfigured driver 1
[     9.912] (==) Matched modesetting as autoconfigured driver 2
[     9.912] (==) Matched fbdev as autoconfigured driver 3
[     9.912] (==) Matched vesa as autoconfigured driver 4
[     9.912] (==) Assigned the driver to the xf86ConfigLayout
[     9.912] (II) LoadModule: "intel"
[     9.913] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[     9.915] (II) Module intel: vendor="X.Org Foundation"
[     9.915] compiled for 1.16.0, module version = 2.99.914
[     9.915] Module class: X.Org Video Driver
[     9.915] ABI class: X.Org Video Driver, version 18.0
[     9.915] (II) LoadModule: "modesetting"
[     9.915] (II) Loading /usr/lib/xorg/modules/drivers/modesetting_drv.so
[     9.915] (II) Module modesetting: vendor="X.Org Foundation"
[     9.915] compiled for 1.16.0, module version = 0.9.0
[     9.915] Module class: X.Org Video Driver
[     9.915] ABI class: X.Org Video Driver, version 18.0
[     9.915] (II) LoadModule: "fbdev"
[     9.915] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[     9.915] (II) Module fbdev: vendor="X.Org Foundation"
[     9.915] compiled for 1.16.0, module version = 0.4.4
[     9.915] Module class: X.Org Video Driver
[     9.915] ABI class: X.Org Video Driver, version 18.0
[     9.915] (II) LoadModule: "vesa"
[     9.915] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[     9.915] (II) Module vesa: vendor="X.Org Foundation"
[     9.915] compiled for 1.16.0, module version = 2.3.3
[     9.915] Module class: X.Org Video Driver
[     9.915] ABI class: X.Org Video Driver, version 18.0
[     9.915] (II) intel: Driver for Intel(R) Integrated Graphics Chipsets:
i810, i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G,
915G, E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM,
Pineview G, 965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33,
GM45, 4 Series, G45/G43, Q45/Q43, G41, B43
[     9.915] (II) intel: Driver for Intel(R) HD Graphics: 2000-6000
[     9.915] (II) intel: Driver for Intel(R) Iris(TM) Graphics: 5100, 6100
[     9.915] (II) intel: Driver for Intel(R) Iris(TM) Pro Graphics:
5200, 6200, P6300
[     9.915] (II) modesetting: Driver for Modesetting Kernel Drivers: kms
[     9.915] (II) FBDEV: driver for framebuffer: fbdev
[     9.916] (II) VESA: driver for VESA chipsets: vesa
[     9.916] (++) using VT number 7

[     9.916] (II) intel(0): Using Kernel Mode Setting driver: i915,
version 1.6.0 20140725
[     9.916] (II) intel(0): SNA compiled: xserver-xorg-video-intel
2:2.99.914-1~exp1ubuntu3 (Maarten Lankhorst
<maarten.lankhorst@ubuntu.com>)
[     9.916] (II) intel(0): SNA compiled for use with valgrind
[     9.916] (WW) Falling back to old probe method for modesetting
[     9.916] (WW) Falling back to old probe method for fbdev
[     9.916] (II) Loading sub module "fbdevhw"
[     9.916] (II) LoadModule: "fbdevhw"
[     9.916] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[     9.916] (II) Module fbdevhw: vendor="X.Org Foundation"
[     9.916] compiled for 1.16.0, module version = 0.0.2
[     9.916] ABI class: X.Org Video Driver, version 18.0
[     9.916] (WW) Falling back to old probe method for vesa
[     9.916] (--) intel(0): Integrated Graphics Chipset: Intel(R) HD
Graphics 4000
[     9.916] (--) intel(0): CPU: x86-64, sse2, sse3, ssse3, sse4.1, sse4.2, avx
[     9.916] (II) intel(0): Creating default Display subsection in
Screen section
"Default Screen Section" for depth/fbbpp 24/32
[     9.916] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[     9.916] (==) intel(0): RGB weight 888
[     9.916] (==) intel(0): Default visual is TrueColor
[     9.917] (II) intel(0): Output LVDS1 has no monitor section
[     9.917] (--) intel(0): Found backlight control interface
acpi_video0 (type 'firmware') for output LVDS1
[     9.917] (II) intel(0): Output VGA1 has no monitor section
[     9.917] (II) intel(0): Output HDMI1 has no monitor section
[     9.917] (II) intel(0): Output DP1 has no monitor section
[     9.917] (--) intel(0): Using a maximum size of 256x256 for hardware cursors
[     9.917] (II) intel(0): Output VIRTUAL1 has no monitor section
[     9.917] (--) intel(0): Output LVDS1 using initial mode 1920x1080 on pipe 0
[     9.917] (==) intel(0): TearFree disabled
[     9.917] (==) intel(0): DPI set to (96, 96)
[     9.917] (II) Loading sub module "dri3"
[     9.917] (II) LoadModule: "dri3"
[     9.917] (II) Module "dri3" already built-in
[     9.917] (II) Loading sub module "dri2"
[     9.917] (II) LoadModule: "dri2"
[     9.917] (II) Module "dri2" already built-in
[     9.917] (II) Loading sub module "present"
[     9.917] (II) LoadModule: "present"
[     9.917] (II) Module "present" already built-in
[     9.917] (II) UnloadModule: "modesetting"
[     9.917] (II) Unloading modesetting
[     9.917] (II) UnloadModule: "fbdev"
[     9.917] (II) Unloading fbdev
[     9.917] (II) UnloadSubModule: "fbdevhw"
[     9.917] (II) Unloading fbdevhw
[     9.917] (II) UnloadModule: "vesa"
[     9.917] (II) Unloading vesa
[     9.917] (==) Depth 24 pixmap format is 32 bpp
[     9.917] (II) intel(0): SNA initialized with Ivybridge (gen7, gt2) backend
[     9.917] (==) intel(0): Backing store enabled
[     9.917] (==) intel(0): Silken mouse enabled
[     9.917] (II) intel(0): HW Cursor enabled
[     9.917] (II) intel(0): RandR 1.2 enabled, ignore the following
RandR disabled message.
[     9.917] (==) intel(0): DPMS enabled
[     9.917] (II) intel(0): [DRI2] Setup complete
[     9.917] (II) intel(0): [DRI2]   DRI driver: i965
[     9.917] (II) intel(0): [DRI2]   VDPAU driver: i965
[     9.917] (II) intel(0): direct rendering: DRI2 DRI3 enabled
[     9.917] (II) intel(0): hardware support for Present enabled
[     9.917] (==) intel(0): display hotplug detection enabled
[     9.917] (--) RandR disabled
[     9.921] (II) SELinux: Disabled on system
[     9.956] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[     9.957] (II) AIGLX: enabled GLX_ARB_create_context
[     9.957] (II) AIGLX: enabled GLX_ARB_create_context_profile
[     9.957] (II) AIGLX: enabled GLX_EXT_create_context_es2_profile
[     9.957] (II) AIGLX: enabled GLX_INTEL_swap_event
[     9.957] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[     9.957] (II) AIGLX: enabled GLX_EXT_framebuffer_sRGB
[     9.957] (II) AIGLX: enabled GLX_ARB_fbconfig_float
[     9.957] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[     9.957] (II) AIGLX: enabled GLX_ARB_create_context_robustness
[     9.957] (II) AIGLX: Loaded and initialized i965
[     9.957] (II) GLX: Initialized DRI2 GL provider for screen 0
[     9.959] (II) intel(0): switch to mode 1920x1080@59.9 on LVDS1
using pipe 0, position (0, 0), rotation normal, reflection none
[     9.968] (II) intel(0): Setting screen physical size to 508 x 285
[     9.974] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[     9.976] (II) config/udev: Adding input device Power Button
(/dev/input/event3)
[     9.976] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     9.976] (II) LoadModule: "evdev"
[     9.976] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     9.977] (II) Module evdev: vendor="X.Org Foundation"
[     9.977] compiled for 1.16.0, module version = 2.9.0
[     9.977] Module class: X.Org XInput Driver
[     9.977] ABI class: X.Org XInput driver, version 21.0
[     9.977] (II) Using input driver 'evdev' for 'Power Button'
[     9.977] (**) Power Button: always reports core events
[     9.977] (**) evdev: Power Button: Device: "/dev/input/event3"
[     9.978] (--) evdev: Power Button: Vendor 0 Product 0x1
[     9.978] (--) evdev: Power Button: Found keys
[     9.978] (II) evdev: Power Button: Configuring as keyboard
[     9.978] (**) Option "config_info"
"udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3/event3"
[     9.978] (II) XINPUT: Adding extended input device "Power Button"
(type: KEYBOARD, id 6)
[     9.978] (**) Option "xkb_rules" "evdev"
[     9.978] (**) Option "xkb_model" "pc105"
[     9.978] (**) Option "xkb_layout" "us"
[     9.978] (II) config/udev: Adding input device Video Bus
(/dev/input/event10)
[     9.978] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[     9.978] (II) Using input driver 'evdev' for 'Video Bus'
[     9.978] (**) Video Bus: always reports core events
[     9.978] (**) evdev: Video Bus: Device: "/dev/input/event10"
[     9.978] (--) evdev: Video Bus: Vendor 0 Product 0x6
[     9.978] (--) evdev: Video Bus: Found keys
[     9.978] (II) evdev: Video Bus: Configuring as keyboard
[     9.978] (**) Option "config_info"
"udev:/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input17/event10"
[     9.978] (II) XINPUT: Adding extended input device "Video Bus"
(type: KEYBOARD, id 7)
[     9.978] (**) Option "xkb_rules" "evdev"
[     9.978] (**) Option "xkb_model" "pc105"
[     9.978] (**) Option "xkb_layout" "us"
[     9.978] (II) config/udev: Adding input device Power Button
(/dev/input/event0)
[     9.978] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     9.978] (II) Using input driver 'evdev' for 'Power Button'
[     9.978] (**) Power Button: always reports core events
[     9.978] (**) evdev: Power Button: Device: "/dev/input/event0"
[     9.978] (--) evdev: Power Button: Vendor 0 Product 0x1
[     9.978] (--) evdev: Power Button: Found keys
[     9.978] (II) evdev: Power Button: Configuring as keyboard
[     9.978] (**) Option "config_info"
"udev:/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0/event0"
[     9.978] (II) XINPUT: Adding extended input device "Power Button"
(type: KEYBOARD, id 8)
[     9.978] (**) Option "xkb_rules" "evdev"
[     9.978] (**) Option "xkb_model" "pc105"
[     9.978] (**) Option "xkb_layout" "us"
[     9.979] (II) config/udev: Adding input device Lid Switch
(/dev/input/event2)
[     9.979] (II) No input driver specified, ignoring this device.
[     9.979] (II) This device may have been added with another device file.
[     9.979] (II) config/udev: Adding input device Sleep Button
(/dev/input/event1)
[     9.979] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[     9.979] (II) Using input driver 'evdev' for 'Sleep Button'
[     9.979] (**) Sleep Button: always reports core events
[     9.979] (**) evdev: Sleep Button: Device: "/dev/input/event1"
[     9.979] (--) evdev: Sleep Button: Vendor 0 Product 0x3
[     9.979] (--) evdev: Sleep Button: Found keys
[     9.979] (II) evdev: Sleep Button: Configuring as keyboard
[     9.979] (**) Option "config_info"
"udev:/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1/event1"
[     9.979] (II) XINPUT: Adding extended input device "Sleep Button"
(type: KEYBOARD, id 9)
[     9.979] (**) Option "xkb_rules" "evdev"
[     9.979] (**) Option "xkb_model" "pc105"
[     9.979] (**) Option "xkb_layout" "us"
[     9.979] (II) config/udev: Adding input device LiteOn HP USB
Multimedia Keyboard (/dev/input/event7)
[     9.979] (**) LiteOn HP USB Multimedia Keyboard: Applying
InputClass "evdev keyboard catchall"
[     9.979] (II) Using input driver 'evdev' for 'LiteOn HP USB
Multimedia Keyboard'
[     9.979] (**) LiteOn HP USB Multimedia Keyboard: always reports core events
[     9.979] (**) evdev: LiteOn HP USB Multimedia Keyboard: Device:
"/dev/input/event7"
[     9.980] (--) evdev: LiteOn HP USB Multimedia Keyboard: Vendor
0x4ca Product 0x40
[     9.980] (--) evdev: LiteOn HP USB Multimedia Keyboard: Found keys
[     9.980] (II) evdev: LiteOn HP USB Multimedia Keyboard:
Configuring as keyboard
[     9.980] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.2/3-2.4.2:1.0/0003:04CA:0040.0001/input/input14/event7"
[     9.980] (II) XINPUT: Adding extended input device "LiteOn HP USB
Multimedia Keyboard" (type: KEYBOARD, id 10)
[     9.980] (**) Option "xkb_rules" "evdev"
[     9.980] (**) Option "xkb_model" "pc105"
[     9.980] (**) Option "xkb_layout" "us"
[     9.980] (II) config/udev: Adding input device LiteOn HP USB
Multimedia Keyboard (/dev/input/event8)
[     9.980] (**) LiteOn HP USB Multimedia Keyboard: Applying
InputClass "evdev keyboard catchall"
[     9.980] (II) Using input driver 'evdev' for 'LiteOn HP USB
Multimedia Keyboard'
[     9.980] (**) LiteOn HP USB Multimedia Keyboard: always reports core events
[     9.980] (**) evdev: LiteOn HP USB Multimedia Keyboard: Device:
"/dev/input/event8"
[     9.980] (--) evdev: LiteOn HP USB Multimedia Keyboard: Vendor
0x4ca Product 0x40
[     9.980] (--) evdev: LiteOn HP USB Multimedia Keyboard: Found keys
[     9.980] (II) evdev: LiteOn HP USB Multimedia Keyboard:
Configuring as keyboard
[     9.980] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.2/3-2.4.2:1.1/0003:04CA:0040.0002/input/input15/event8"
[     9.980] (II) XINPUT: Adding extended input device "LiteOn HP USB
Multimedia Keyboard" (type: KEYBOARD, id 11)
[     9.980] (**) Option "xkb_rules" "evdev"
[     9.980] (**) Option "xkb_model" "pc105"
[     9.980] (**) Option "xkb_layout" "us"
[     9.980] (II) config/udev: Adding input device USB Optical Mouse
(/dev/input/event9)
[     9.980] (**) USB Optical Mouse: Applying InputClass "evdev
pointer catchall"
[     9.980] (**) USB Optical Mouse: Applying InputClass "Avago
Technologies mouse quirks (LP: #746639)"
[     9.980] (II) Using input driver 'evdev' for 'USB Optical Mouse'
[     9.980] (**) USB Optical Mouse: always reports core events
[     9.980] (**) evdev: USB Optical Mouse: Device: "/dev/input/event9"
[     9.980] (--) evdev: USB Optical Mouse: Vendor 0x192f Product 0x416
[     9.980] (--) evdev: USB Optical Mouse: Found 3 mouse buttons
[     9.980] (--) evdev: USB Optical Mouse: Found scroll wheel(s)
[     9.980] (--) evdev: USB Optical Mouse: Found relative axes
[     9.981] (--) evdev: USB Optical Mouse: Found x and y relative axes
[     9.981] (II) evdev: USB Optical Mouse: Configuring as mouse
[     9.981] (II) evdev: USB Optical Mouse: Adding scrollwheel support
[     9.981] (**) Option "Emulate3Buttons" "True"
[     9.981] (**) Option "Emulate3Timeout" "50"
[     9.981] (**) evdev: USB Optical Mouse: YAxisMapping: buttons 4 and 5
[     9.981] (**) evdev: USB Optical Mouse: EmulateWheelButton: 4,
EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[     9.981] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.3/3-2.4.3:1.0/0003:192F:0416.0003/input/input16/event9"
[     9.981] (II) XINPUT: Adding extended input device "USB Optical
Mouse" (type: MOUSE, id 12)
[     9.981] (II) evdev: USB Optical Mouse: initialized for relative axes.
[     9.981] (**) USB Optical Mouse: (accel) keeping acceleration scheme 1
[     9.981] (**) USB Optical Mouse: (accel) acceleration profile 0
[     9.981] (**) USB Optical Mouse: (accel) acceleration factor: 2.000
[     9.981] (**) USB Optical Mouse: (accel) acceleration threshold: 4
[     9.981] (II) config/udev: Adding input device USB Optical Mouse
(/dev/input/mouse1)
[     9.981] (II) No input driver specified, ignoring this device.
[     9.981] (II) This device may have been added with another device file.
[     9.981] (II) config/udev: Adding input device HDA Intel PCH Mic
(/dev/input/event11)
[     9.981] (II) No input driver specified, ignoring this device.
[     9.981] (II) This device may have been added with another device file.
[     9.981] (II) config/udev: Adding input device HDA Intel PCH Front
Headphone (/dev/input/event12)
[     9.981] (II) No input driver specified, ignoring this device.
[     9.981] (II) This device may have been added with another device file.
[     9.981] (II) config/udev: Adding input device HDA Intel PCH
HDMI/DP,pcm=3 (/dev/input/event13)
[     9.981] (II) No input driver specified, ignoring this device.
[     9.981] (II) This device may have been added with another device file.
[     9.982] (II) config/udev: Adding input device Chicony USB 2.0
Camera (/dev/input/event6)
[     9.982] (**) Chicony USB 2.0 Camera: Applying InputClass "evdev
keyboard catchall"
[     9.982] (II) Using input driver 'evdev' for 'Chicony USB 2.0 Camera'
[     9.982] (**) Chicony USB 2.0 Camera: always reports core events
[     9.982] (**) evdev: Chicony USB 2.0 Camera: Device: "/dev/input/event6"
[     9.982] (--) evdev: Chicony USB 2.0 Camera: Vendor 0x4f2 Product 0xb34c
[     9.982] (--) evdev: Chicony USB 2.0 Camera: Found keys
[     9.982] (II) evdev: Chicony USB 2.0 Camera: Configuring as keyboard
[     9.982] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input13/event6"
[     9.982] (II) XINPUT: Adding extended input device "Chicony USB
2.0 Camera" (type: KEYBOARD, id 13)
[     9.982] (**) Option "xkb_rules" "evdev"
[     9.982] (**) Option "xkb_model" "pc105"
[     9.982] (**) Option "xkb_layout" "us"
[     9.982] (II) config/udev: Adding input device AT Translated Set 2
keyboard (/dev/input/event4)
[     9.982] (**) AT Translated Set 2 keyboard: Applying InputClass
"evdev keyboard catchall"
[     9.982] (II) Using input driver 'evdev' for 'AT Translated Set 2 keyboard'
[     9.982] (**) AT Translated Set 2 keyboard: always reports core events
[     9.982] (**) evdev: AT Translated Set 2 keyboard: Device:
"/dev/input/event4"
[     9.982] (--) evdev: AT Translated Set 2 keyboard: Vendor 0x1 Product 0x1
[     9.982] (--) evdev: AT Translated Set 2 keyboard: Found keys
[     9.982] (II) evdev: AT Translated Set 2 keyboard: Configuring as keyboard
[     9.982] (**) Option "config_info"
"udev:/sys/devices/platform/i8042/serio0/input/input4/event4"
[     9.982] (II) XINPUT: Adding extended input device "AT Translated
Set 2 keyboard" (type: KEYBOARD, id 14)
[     9.982] (**) Option "xkb_rules" "evdev"
[     9.982] (**) Option "xkb_model" "pc105"
[     9.982] (**) Option "xkb_layout" "us"
[     9.982] (II) config/udev: Adding input device ETPS/2 Elantech
Touchpad (/dev/input/event5)
[     9.982] (**) ETPS/2 Elantech Touchpad: Applying InputClass "evdev
touchpad catchall"
[     9.982] (**) ETPS/2 Elantech Touchpad: Applying InputClass
"touchpad catchall"
[     9.982] (**) ETPS/2 Elantech Touchpad: Applying InputClass
"Default clickpad buttons"
[     9.982] (II) LoadModule: "synaptics"
[     9.983] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[     9.983] (II) Module synaptics: vendor="X.Org Foundation"
[     9.983] compiled for 1.16.0, module version = 1.8.99
[     9.983] Module class: X.Org XInput Driver
[     9.983] ABI class: X.Org XInput driver, version 21.0
[     9.983] (II) Using input driver 'synaptics' for 'ETPS/2 Elantech Touchpad'
[     9.983] (**) ETPS/2 Elantech Touchpad: always reports core events
[     9.983] (**) Option "Device" "/dev/input/event5"
[    10.000] (--) synaptics: ETPS/2 Elantech Touchpad: x-axis range 0
- 2436 (res 0)
[    10.000] (--) synaptics: ETPS/2 Elantech Touchpad: y-axis range 0
- 1044 (res 0)
[    10.000] (--) synaptics: ETPS/2 Elantech Touchpad: pressure range 0 - 255
[    10.000] (--) synaptics: ETPS/2 Elantech Touchpad: finger width range 0 - 15
[    10.000] (--) synaptics: ETPS/2 Elantech Touchpad: buttons: left
right double triple
[    10.000] (--) synaptics: ETPS/2 Elantech Touchpad: Vendor 0x2 Product 0xe
[    10.000] (--) synaptics: ETPS/2 Elantech Touchpad: touchpad found
[    10.000] (**) ETPS/2 Elantech Touchpad: always reports core events
[    10.024] (**) Option "config_info"
"udev:/sys/devices/platform/i8042/serio2/input/input10/event5"
[    10.024] (II) XINPUT: Adding extended input device "ETPS/2
Elantech Touchpad" (type: TOUCHPAD, id 15)
[    10.024] (**) synaptics: ETPS/2 Elantech Touchpad: (accel)
MinSpeed is now constant deceleration 2.5
[    10.024] (**) synaptics: ETPS/2 Elantech Touchpad: (accel)
MaxSpeed is now 1.75
[    10.024] (**) synaptics: ETPS/2 Elantech Touchpad: (accel)
AccelFactor is now 0.075
[    10.024] (**) ETPS/2 Elantech Touchpad: (accel) keeping
acceleration scheme 1
[    10.024] (**) ETPS/2 Elantech Touchpad: (accel) acceleration profile 1
[    10.024] (**) ETPS/2 Elantech Touchpad: (accel) acceleration factor: 2.000
[    10.024] (**) ETPS/2 Elantech Touchpad: (accel) acceleration threshold: 4
[    10.024] (--) synaptics: ETPS/2 Elantech Touchpad: touchpad found
[    10.024] (II) config/udev: Adding input device ETPS/2 Elantech
Touchpad (/dev/input/mouse0)
[    10.024] (**) ETPS/2 Elantech Touchpad: Ignoring device from
InputClass "touchpad ignore duplicates"
[    10.556] (II) intel(0): EDID vendor "LGD", prod id 489
[    10.556] (II) intel(0): Printing DDC gathered Modelines:
[    10.556] (II) intel(0): Modeline "1920x1080"x0.0  138.50  1920
1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz eP)
[    10.683] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[    11.223] (II) XKB: reuse xkmfile
/var/lib/xkb/server-7C75F152E85183199599C3E0B919739C0EE668AA.xkm
[    11.907] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[    11.924] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[   105.785] (II) config/udev: removing device LiteOn HP USB Multimedia Keyboard
[   105.808] (II) evdev: LiteOn HP USB Multimedia Keyboard: Close
[   105.808] (II) UnloadModule: "evdev"
[   105.817] (II) config/udev: removing device LiteOn HP USB Multimedia Keyboard
[   105.832] (II) evdev: LiteOn HP USB Multimedia Keyboard: Close
[   105.832] (II) UnloadModule: "evdev"
[   105.881] (II) config/udev: removing device USB Optical Mouse
[   105.900] (II) evdev: USB Optical Mouse: Close
[   105.900] (II) UnloadModule: "evdev"
[   121.814] (II) config/udev: Adding input device LiteOn HP USB
Multimedia Keyboard (/dev/input/event8)
[   121.814] (**) LiteOn HP USB Multimedia Keyboard: Applying
InputClass "evdev keyboard catchall"
[   121.814] (II) Using input driver 'evdev' for 'LiteOn HP USB
Multimedia Keyboard'
[   121.814] (**) LiteOn HP USB Multimedia Keyboard: always reports core events
[   121.814] (**) evdev: LiteOn HP USB Multimedia Keyboard: Device:
"/dev/input/event8"
[   121.814] (--) evdev: LiteOn HP USB Multimedia Keyboard: Vendor
0x4ca Product 0x40
[   121.814] (--) evdev: LiteOn HP USB Multimedia Keyboard: Found keys
[   121.814] (II) evdev: LiteOn HP USB Multimedia Keyboard:
Configuring as keyboard
[   121.814] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.2/3-2.4.2:1.1/0003:04CA:0040.0005/input/input22/event8"
[   121.814] (II) XINPUT: Adding extended input device "LiteOn HP USB
Multimedia Keyboard" (type: KEYBOARD, id 10)
[   121.814] (**) Option "xkb_rules" "evdev"
[   121.814] (**) Option "xkb_model" "pc105"
[   121.814] (**) Option "xkb_layout" "us"
[   121.816] (II) config/udev: Adding input device LiteOn HP USB
Multimedia Keyboard (/dev/input/event7)
[   121.816] (**) LiteOn HP USB Multimedia Keyboard: Applying
InputClass "evdev keyboard catchall"
[   121.816] (II) Using input driver 'evdev' for 'LiteOn HP USB
Multimedia Keyboard'
[   121.816] (**) LiteOn HP USB Multimedia Keyboard: always reports core events
[   121.816] (**) evdev: LiteOn HP USB Multimedia Keyboard: Device:
"/dev/input/event7"
[   121.816] (--) evdev: LiteOn HP USB Multimedia Keyboard: Vendor
0x4ca Product 0x40
[   121.816] (--) evdev: LiteOn HP USB Multimedia Keyboard: Found keys
[   121.816] (II) evdev: LiteOn HP USB Multimedia Keyboard:
Configuring as keyboard
[   121.816] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.2/3-2.4.2:1.0/0003:04CA:0040.0004/input/input21/event7"
[   121.816] (II) XINPUT: Adding extended input device "LiteOn HP USB
Multimedia Keyboard" (type: KEYBOARD, id 11)
[   121.816] (**) Option "xkb_rules" "evdev"
[   121.816] (**) Option "xkb_model" "pc105"
[   121.816] (**) Option "xkb_layout" "us"
[   121.818] (II) config/udev: Adding input device USB Optical Mouse
(/dev/input/mouse1)
[   121.818] (II) No input driver specified, ignoring this device.
[   121.818] (II) This device may have been added with another device file.
[   121.818] (II) config/udev: Adding input device USB Optical Mouse
(/dev/input/event9)
[   121.818] (**) USB Optical Mouse: Applying InputClass "evdev
pointer catchall"
[   121.818] (**) USB Optical Mouse: Applying InputClass "Avago
Technologies mouse quirks (LP: #746639)"
[   121.818] (II) Using input driver 'evdev' for 'USB Optical Mouse'
[   121.818] (**) USB Optical Mouse: always reports core events
[   121.819] (**) evdev: USB Optical Mouse: Device: "/dev/input/event9"
[   121.832] (--) evdev: USB Optical Mouse: Vendor 0x192f Product 0x416
[   121.832] (--) evdev: USB Optical Mouse: Found 3 mouse buttons
[   121.832] (--) evdev: USB Optical Mouse: Found scroll wheel(s)
[   121.832] (--) evdev: USB Optical Mouse: Found relative axes
[   121.832] (--) evdev: USB Optical Mouse: Found x and y relative axes
[   121.832] (II) evdev: USB Optical Mouse: Configuring as mouse
[   121.832] (II) evdev: USB Optical Mouse: Adding scrollwheel support
[   121.832] (**) Option "Emulate3Buttons" "True"
[   121.832] (**) Option "Emulate3Timeout" "50"
[   121.832] (**) evdev: USB Optical Mouse: YAxisMapping: buttons 4 and 5
[   121.832] (**) evdev: USB Optical Mouse: EmulateWheelButton: 4,
EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[   121.832] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.3/3-2.4.3:1.0/0003:192F:0416.0006/input/input23/event9"
[   121.832] (II) XINPUT: Adding extended input device "USB Optical
Mouse" (type: MOUSE, id 12)
[   121.832] (II) evdev: USB Optical Mouse: initialized for relative axes.
[   121.833] (**) USB Optical Mouse: (accel) keeping acceleration scheme 1
[   121.833] (**) USB Optical Mouse: (accel) acceleration profile 0
[   121.833] (**) USB Optical Mouse: (accel) acceleration factor: 2.000
[   121.833] (**) USB Optical Mouse: (accel) acceleration threshold: 4
[   121.841] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[   121.851] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[   186.317] (II) config/udev: removing device LiteOn HP USB Multimedia Keyboard
[   186.336] (II) evdev: LiteOn HP USB Multimedia Keyboard: Close
[   186.336] (II) UnloadModule: "evdev"
[   186.337] (II) config/udev: removing device LiteOn HP USB Multimedia Keyboard
[   186.352] (II) evdev: LiteOn HP USB Multimedia Keyboard: Close
[   186.353] (II) UnloadModule: "evdev"
[   187.049] (II) config/udev: removing device USB Optical Mouse
[   187.069] (II) evdev: USB Optical Mouse: Close
[   187.069] (II) UnloadModule: "evdev"
[   356.156] (II) config/udev: Adding input device USB Optical Mouse
(/dev/input/mouse1)
[   356.156] (II) No input driver specified, ignoring this device.
[   356.156] (II) This device may have been added with another device file.
[   356.157] (II) config/udev: Adding input device USB Optical Mouse
(/dev/input/event7)
[   356.157] (**) USB Optical Mouse: Applying InputClass "evdev
pointer catchall"
[   356.157] (**) USB Optical Mouse: Applying InputClass "Avago
Technologies mouse quirks (LP: #746639)"
[   356.157] (II) Using input driver 'evdev' for 'USB Optical Mouse'
[   356.158] (**) USB Optical Mouse: always reports core events
[   356.158] (**) evdev: USB Optical Mouse: Device: "/dev/input/event7"
[   356.158] (--) evdev: USB Optical Mouse: Vendor 0x192f Product 0x416
[   356.158] (--) evdev: USB Optical Mouse: Found 3 mouse buttons
[   356.158] (--) evdev: USB Optical Mouse: Found scroll wheel(s)
[   356.158] (--) evdev: USB Optical Mouse: Found relative axes
[   356.158] (--) evdev: USB Optical Mouse: Found x and y relative axes
[   356.158] (II) evdev: USB Optical Mouse: Configuring as mouse
[   356.158] (II) evdev: USB Optical Mouse: Adding scrollwheel support
[   356.158] (**) Option "Emulate3Buttons" "True"
[   356.158] (**) Option "Emulate3Timeout" "50"
[   356.158] (**) evdev: USB Optical Mouse: YAxisMapping: buttons 4 and 5
[   356.158] (**) evdev: USB Optical Mouse: EmulateWheelButton: 4,
EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[   356.158] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.2/3-2.4.2:1.0/0003:192F:0416.0007/input/input24/event7"
[   356.158] (II) XINPUT: Adding extended input device "USB Optical
Mouse" (type: MOUSE, id 10)
[   356.158] (II) evdev: USB Optical Mouse: initialized for relative axes.
[   356.159] (**) USB Optical Mouse: (accel) keeping acceleration scheme 1
[   356.159] (**) USB Optical Mouse: (accel) acceleration profile 0
[   356.159] (**) USB Optical Mouse: (accel) acceleration factor: 2.000
[   356.159] (**) USB Optical Mouse: (accel) acceleration threshold: 4
[   358.454] (II) config/udev: Adding input device LiteOn HP USB
Multimedia Keyboard (/dev/input/event9)
[   358.454] (**) LiteOn HP USB Multimedia Keyboard: Applying
InputClass "evdev keyboard catchall"
[   358.454] (II) Using input driver 'evdev' for 'LiteOn HP USB
Multimedia Keyboard'
[   358.454] (**) LiteOn HP USB Multimedia Keyboard: always reports core events
[   358.454] (**) evdev: LiteOn HP USB Multimedia Keyboard: Device:
"/dev/input/event9"
[   358.454] (--) evdev: LiteOn HP USB Multimedia Keyboard: Vendor
0x4ca Product 0x40
[   358.454] (--) evdev: LiteOn HP USB Multimedia Keyboard: Found keys
[   358.454] (II) evdev: LiteOn HP USB Multimedia Keyboard:
Configuring as keyboard
[   358.454] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.3/3-2.4.3:1.1/0003:04CA:0040.0009/input/input26/event9"
[   358.454] (II) XINPUT: Adding extended input device "LiteOn HP USB
Multimedia Keyboard" (type: KEYBOARD, id 11)
[   358.454] (**) Option "xkb_rules" "evdev"
[   358.454] (**) Option "xkb_model" "pc105"
[   358.454] (**) Option "xkb_layout" "us"
[   358.456] (II) config/udev: Adding input device LiteOn HP USB
Multimedia Keyboard (/dev/input/event8)
[   358.456] (**) LiteOn HP USB Multimedia Keyboard: Applying
InputClass "evdev keyboard catchall"
[   358.456] (II) Using input driver 'evdev' for 'LiteOn HP USB
Multimedia Keyboard'
[   358.456] (**) LiteOn HP USB Multimedia Keyboard: always reports core events
[   358.456] (**) evdev: LiteOn HP USB Multimedia Keyboard: Device:
"/dev/input/event8"
[   358.456] (--) evdev: LiteOn HP USB Multimedia Keyboard: Vendor
0x4ca Product 0x40
[   358.456] (--) evdev: LiteOn HP USB Multimedia Keyboard: Found keys
[   358.456] (II) evdev: LiteOn HP USB Multimedia Keyboard:
Configuring as keyboard
[   358.456] (**) Option "config_info"
"udev:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2.4/3-2.4.3/3-2.4.3:1.0/0003:04CA:0040.0008/input/input25/event8"
[   358.456] (II) XINPUT: Adding extended input device "LiteOn HP USB
Multimedia Keyboard" (type: KEYBOARD, id 12)
[   358.456] (**) Option "xkb_rules" "evdev"
[   358.456] (**) Option "xkb_model" "pc105"
[   358.456] (**) Option "xkb_layout" "us"
[   358.466] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[   358.475] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[ 14916.205] (II) XKB: reuse xkmfile
/var/lib/xkb/server-7C75F152E85183199599C3E0B919739C0EE668AA.xkm
[ 92771.473] (II) intel(0): switch to mode 1920x1080@59.9 on LVDS1
using pipe 0, position (0, 0), rotation normal, reflection none
[ 92775.394] (II) config/udev: removing device USB Optical Mouse
[ 92775.420] (II) evdev: USB Optical Mouse: Close
[ 92775.420] (II) UnloadModule: "evdev"
[ 92775.421] (II) config/udev: removing device LiteOn HP USB Multimedia Keyboard
[ 92775.448] (II) evdev: LiteOn HP USB Multimedia Keyboard: Close
[ 92775.448] (II) UnloadModule: "evdev"
[ 92775.448] (II) config/udev: removing device LiteOn HP USB Multimedia Keyboard
[ 92775.484] (II) evdev: LiteOn HP USB Multimedia Keyboard: Close
[ 92775.484] (II) UnloadModule: "evdev"
[ 92775.552] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[ 92775.568] (II) XKB: reuse xkmfile
/var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
