Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab3K1LaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:30:18 -0500
Received: from mout.gmx.net ([74.208.4.201]:54043 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533Ab3K1L31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:29:27 -0500
Message-ID: <5297290C.9050101@gmx.com>
Date: Thu, 28 Nov 2013 13:29:16 +0200
From: =?ISO-8859-9?Q?Osman_=C7aylak?= <osmancik@gmx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Micro freezes on Lenovo IdeaPad Y560p
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:hLI4QXxqLxbFJqt7PqsrqUbTOX8OxUdBG3HhSsEUlrQbFsCxsZ4
 Z0tdUH+0q1DvRpRvF6Wm60TavmZ1h38JHTC7IH3Wrc0OVz27NNCwhjdBpXto0s/lc0b7GBE
 03oJsu0scqzRoXiOPoYHO6Z1ZjE3F+r+k/HYsuiocxijNfVn4odFC+3fzKdE7TfY8F8Wp9O
 sFtgFh0NHHRlDqfgDKiFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:
Micro freezes on Lenovo IdeaPad Y560p

[2.] Full description of the problem/report:
There are micro freezes on system. This don't allow scrolling down a web 
page smoothly, watching a video or playing a game for example.
CPU-0 is always ~85% htop is not showing anything using cpu that much 
but top is showing kworker. (top output: http://pastebin.com/jz9jwkK0 ). 
Adding "noapic" on grub solves freezing issue but cpu issue persists.
One noticeable thing is this machine doesn't have 2 graphics cards 
despite having an i7 cpu.

[3.] Keywords (i.e., modules, networking, kernel):

[4.] Kernel version (from /proc/version):
Linux version 3.13.0-031300rc1-generic (apw@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201311221535 SMP Fri Nov 22 20:36:51 
UTC 2013

[5.] Output of Oops.. message (if applicable) with symbolic information 
resolved (see Documentation/oops-tracing.txt)

[6.] A small shell script or example program which triggers the problem 
(if possible)

[7.] Environment
Description:    Ubuntu 13.10
Release:        13.10

[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux bilgisayar 3.13.0-031300rc1-generic #201311221535 SMP Fri Nov 22 
20:36:51 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.8
Gnu make               3.81
binutils               2.23.52.20130913
util-linux             fdformat
mount                  support
module-init-tools      9
e2fsprogs              1.42.8
jfsutils               1.1.15
reiserfsprogs          3.6.21
reiser4progs           1.0.7
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.5
Sh-utils               8.20
wireless-tools         30
Modules Loaded         dm_crypt cuse cast6_avx_x86_64 cast6_generic cts 
gcm sha256_ssse3 sha512_ssse3 aes_x86_64 xfrm_user ah6 ah4 esp6 esp4 
xfrm4_mode_beet xfrm4_tunnel tunnel4 xfrm4_mode_tunnel 
xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_ro xfrm6_mode_beet 
xfrm6_mode_tunnel ipcomp ipcomp6 xfrm6_tunnel tunnel6 xfrm_ipcomp joydev 
ccm deflate ctr twofish_generic twofish_avx_x86_64 twofish_x86_64_3way 
twofish_x86_64 twofish_common camellia_generic camellia_x86_64 
serpent_avx_x86_64 serpent_sse2_x86_64 xts serpent_generic lrw gf128mul 
glue_helper blowfish_generic blowfish_x86_64 blowfish_common 
cast5_avx_x86_64 cast5_generic cast_common ablk_helper des_generic cmac 
xcbc rmd160 crypto_null af_key xfrm_algo parport_pc ppdev 
x86_pkg_temp_thermal intel_powerclamp kvm_intel kvm crct10dif_pclmul 
crc32_pclmul rfcomm ghash_clmulni_intel uvcvideo bnep cryptd 
videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb 
bluetooth dm_multipath scsi_dh microcode psmouse serio_raw binfmt_misc 
snd_hda_codec_hdmi arc4 snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq_midi 
snd_seq_midi_event jmb38x_ms ath9k memstick snd_rawmidi ath9k_common 
snd_seq ath9k_hw snd_seq_device ath mac80211 snd_timer cfg80211 
ideapad_laptop snd sparse_keymap mei_me mei soundcore lpc_ich mac_hid 
coretemp lp parport dm_mirror dm_region_hash dm_log hid_logitech_dj 
usbhid hid tg3 ahci sdhci_pci ptp libahci sdhci pps_core wmi video

[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2794.062
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2137.500
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2599.921
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2600.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 4
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2793.203
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 5
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2573.281
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 6
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2535.703
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 5
initial apicid  : 5
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
stepping        : 7
microcode       : 0x14
cpu MHz         : 2600.000
cache size      : 6144 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor 
ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt 
tsc_deadline_timer xsave avx lahf_lm ida arat epb xsaveopt pln pts 
dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 3991.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
dm_crypt 23417 0 - Live 0x0000000000000000
cuse 13566 3 - Live 0x0000000000000000
cast6_avx_x86_64 66938 0 - Live 0x0000000000000000
cast6_generic 21523 1 cast6_avx_x86_64, Live 0x0000000000000000
cts 12902 0 - Live 0x0000000000000000
gcm 23507 0 - Live 0x0000000000000000
sha256_ssse3 26322 0 - Live 0x0000000000000000
sha512_ssse3 42254 0 - Live 0x0000000000000000
aes_x86_64 17131 0 - Live 0x0000000000000000
xfrm_user 35941 2 - Live 0x0000000000000000
ah6 17168 0 - Live 0x0000000000000000
ah4 13002 0 - Live 0x0000000000000000
esp6 17144 0 - Live 0x0000000000000000
esp4 17139 0 - Live 0x0000000000000000
xfrm4_mode_beet 12611 0 - Live 0x0000000000000000
xfrm4_tunnel 12857 0 - Live 0x0000000000000000
tunnel4 13252 1 xfrm4_tunnel, Live 0x0000000000000000
xfrm4_mode_tunnel 13261 0 - Live 0x0000000000000000
xfrm4_mode_transport 12631 0 - Live 0x0000000000000000
xfrm6_mode_transport 12631 0 - Live 0x0000000000000000
xfrm6_mode_ro 12564 0 - Live 0x0000000000000000
xfrm6_mode_beet 12658 0 - Live 0x0000000000000000
xfrm6_mode_tunnel 13261 0 - Live 0x0000000000000000
ipcomp 12751 0 - Live 0x0000000000000000
ipcomp6 12754 0 - Live 0x0000000000000000
xfrm6_tunnel 13807 1 ipcomp6, Live 0x0000000000000000
tunnel6 13254 1 xfrm6_tunnel, Live 0x0000000000000000
xfrm_ipcomp 13606 2 ipcomp,ipcomp6, Live 0x0000000000000000
joydev 17575 0 - Live 0x0000000000000000
ccm 17856 2 - Live 0x0000000000000000
deflate 12617 0 - Live 0x0000000000000000
ctr 13193 2 - Live 0x0000000000000000
twofish_generic 16635 0 - Live 0x0000000000000000
twofish_avx_x86_64 46380 0 - Live 0x0000000000000000
twofish_x86_64_3way 27146 1 twofish_avx_x86_64, Live 0x0000000000000000
twofish_x86_64 12907 2 twofish_avx_x86_64,twofish_x86_64_3way, Live 
0x0000000000000000
twofish_common 21113 4 
twofish_generic,twofish_avx_x86_64,twofish_x86_64_3way,twofish_x86_64, 
Live 0x0000000000000000
camellia_generic 29348 0 - Live 0x0000000000000000
camellia_x86_64 52986 0 - Live 0x0000000000000000
serpent_avx_x86_64 48537 0 - Live 0x0000000000000000
serpent_sse2_x86_64 50367 0 - Live 0x0000000000000000
xts 12951 3 twofish_x86_64_3way,camellia_x86_64,serpent_sse2_x86_64, 
Live 0x0000000000000000
serpent_generic 29823 2 serpent_avx_x86_64,serpent_sse2_x86_64, Live 
0x0000000000000000
lrw 13323 6 
cast6_avx_x86_64,twofish_avx_x86_64,twofish_x86_64_3way,camellia_x86_64,serpent_avx_x86_64,serpent_sse2_x86_64, 
Live 0x0000000000000000
gf128mul 14951 2 xts,lrw, Live 0x0000000000000000
glue_helper 14095 6 
cast6_avx_x86_64,twofish_avx_x86_64,twofish_x86_64_3way,camellia_x86_64,serpent_avx_x86_64,serpent_sse2_x86_64, 
Live 0x0000000000000000
blowfish_generic 12530 0 - Live 0x0000000000000000
blowfish_x86_64 21400 0 - Live 0x0000000000000000
blowfish_common 16739 2 blowfish_generic,blowfish_x86_64, Live 
0x0000000000000000
cast5_avx_x86_64 49919 0 - Live 0x0000000000000000
cast5_generic 21429 1 cast5_avx_x86_64, Live 0x0000000000000000
cast_common 12983 4 
cast6_avx_x86_64,cast6_generic,cast5_avx_x86_64,cast5_generic, Live 
0x0000000000000000
ablk_helper 13597 5 
cast6_avx_x86_64,twofish_avx_x86_64,serpent_avx_x86_64,serpent_sse2_x86_64,cast5_avx_x86_64, 
Live 0x0000000000000000
des_generic 21379 0 - Live 0x0000000000000000
cmac 12788 0 - Live 0x0000000000000000
xcbc 12815 0 - Live 0x0000000000000000
rmd160 16744 0 - Live 0x0000000000000000
crypto_null 12840 0 - Live 0x0000000000000000
af_key 36462 0 - Live 0x0000000000000000
xfrm_algo 15394 7 xfrm_user,ah6,ah4,esp6,esp4,xfrm_ipcomp,af_key, Live 
0x0000000000000000
parport_pc 36962 0 - Live 0x0000000000000000
ppdev 17711 0 - Live 0x0000000000000000
x86_pkg_temp_thermal 14269 0 - Live 0x0000000000000000
intel_powerclamp 19031 0 - Live 0x0000000000000000
kvm_intel 144426 0 - Live 0x0000000000000000
kvm 468147 1 kvm_intel, Live 0x0000000000000000
crct10dif_pclmul 14250 0 - Live 0x0000000000000000
crc32_pclmul 13160 0 - Live 0x0000000000000000
rfcomm 74748 16 - Live 0x0000000000000000
ghash_clmulni_intel 13259 0 - Live 0x0000000000000000
uvcvideo 82247 0 - Live 0x0000000000000000
bnep 19884 2 - Live 0x0000000000000000
cryptd 20530 2 ablk_helper,ghash_clmulni_intel, Live 0x0000000000000000
videobuf2_vmalloc 13216 1 uvcvideo, Live 0x0000000000000000
videobuf2_memops 13362 1 videobuf2_vmalloc, Live 0x0000000000000000
videobuf2_core 40972 1 uvcvideo, Live 0x0000000000000000
videodev 139761 2 uvcvideo,videobuf2_core, Live 0x0000000000000000
btusb 28326 0 - Live 0x0000000000000000
bluetooth 411140 22 rfcomm,bnep,btusb, Live 0x0000000000000000
dm_multipath 27401 0 - Live 0x0000000000000000
scsi_dh 14873 1 dm_multipath, Live 0x0000000000000000
microcode 23788 0 - Live 0x0000000000000000
psmouse 104142 0 - Live 0x0000000000000000
serio_raw 13462 0 - Live 0x0000000000000000
binfmt_misc 17508 1 - Live 0x0000000000000000
snd_hda_codec_hdmi 46905 1 - Live 0x0000000000000000
arc4 12573 2 - Live 0x0000000000000000
snd_hda_codec_realtek 61658 1 - Live 0x0000000000000000
snd_hda_intel 57222 5 - Live 0x0000000000000000
snd_hda_codec 194970 3 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 
0x0000000000000000
snd_hwdep 13613 1 snd_hda_codec, Live 0x0000000000000000
snd_pcm 107140 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 
0x0000000000000000
snd_page_alloc 18798 2 snd_hda_intel,snd_pcm, Live 0x0000000000000000
snd_seq_midi 13324 0 - Live 0x0000000000000000
snd_seq_midi_event 14899 1 snd_seq_midi, Live 0x0000000000000000
jmb38x_ms 18947 0 - Live 0x0000000000000000
ath9k 166504 0 - Live 0x0000000000000000
memstick 16968 1 jmb38x_ms, Live 0x0000000000000000
snd_rawmidi 30465 1 snd_seq_midi, Live 0x0000000000000000
ath9k_common 13551 1 ath9k, Live 0x0000000000000000
snd_seq 66061 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
ath9k_hw 462889 2 ath9k,ath9k_common, Live 0x0000000000000000
snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 
0x0000000000000000
ath 29145 3 ath9k,ath9k_common,ath9k_hw, Live 0x0000000000000000
mac80211 654078 1 ath9k, Live 0x0000000000000000
snd_timer 30038 2 snd_pcm,snd_seq, Live 0x0000000000000000
cfg80211 509407 3 ath9k,ath,mac80211, Live 0x0000000000000000
ideapad_laptop 18462 0 - Live 0x0000000000000000
snd 73850 21 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq_midi,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0x0000000000000000
sparse_keymap 13890 1 ideapad_laptop, Live 0x0000000000000000
mei_me 18578 0 - Live 0x0000000000000000
mei 82671 1 mei_me, Live 0x0000000000000000
soundcore 12680 1 snd, Live 0x0000000000000000
lpc_ich 21163 0 - Live 0x0000000000000000
mac_hid 13253 0 - Live 0x0000000000000000
coretemp 17728 0 - Live 0x0000000000000000
lp 17799 0 - Live 0x0000000000000000
parport 42481 3 parport_pc,ppdev,lp, Live 0x0000000000000000
dm_mirror 22356 0 - Live 0x0000000000000000
dm_region_hash 21010 1 dm_mirror, Live 0x0000000000000000
dm_log 18527 2 dm_mirror,dm_region_hash, Live 0x0000000000000000
hid_logitech_dj 18759 0 - Live 0x0000000000000000
usbhid 53067 0 - Live 0x0000000000000000
hid 106254 3 hid_logitech_dj,usbhid, Live 0x0000000000000000
tg3 174850 0 - Live 0x0000000000000000
ahci 30063 4 - Live 0x0000000000000000
sdhci_pci 19241 0 - Live 0x0000000000000000
ptp 18980 1 tg3, Live 0x0000000000000000
libahci 32277 1 ahci, Live 0x0000000000000000
sdhci 43409 1 sdhci_pci, Live 0x0000000000000000
pps_core 19381 1 ptp, Live 0x0000000000000000
wmi 19363 0 - Live 0x0000000000000000
video 19859 0 - Live 0x0000000000000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
~$ cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : EC cmd
   0070-0077 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0400-0403 : ACPI PM1a_EVT_BLK
   0404-0405 : ACPI PM1a_CNT_BLK
   0408-040b : ACPI PM_TMR
   0410-0415 : ACPI CPU throttle
   0420-042f : ACPI GPE0_BLK
   0430-0433 : iTCO_wdt
   0450-0450 : ACPI PM2_CNT_BLK
   0454-0457 : pnp 00:06
   0458-047f : pnp 00:04
     0460-047f : iTCO_wdt
   0500-057f : pnp 00:04
   0680-069f : pnp 00:04
   0700-070f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   164e-164f : pnp 00:04
   1808-180b : 0000:00:1f.2
     1808-180b : ahci
   180c-180f : 0000:00:1f.2
     180c-180f : ahci
   1810-1817 : 0000:00:1f.2
     1810-1817 : ahci
   1818-181f : 0000:00:1f.2
     1818-181f : ahci
   1820-183f : 0000:00:1f.2
     1820-183f : ahci
   1840-185f : 0000:00:1f.3
   2000-2fff : PCI Bus 0000:01
     2000-20ff : 0000:01:00.0
   3000-3fff : PCI Bus 0000:03
   4000-4fff : PCI Bus 0000:06
   5000-5fff : PCI Bus 0000:05
   6000-6fff : PCI Bus 0000:09
   ffff-ffff : pnp 00:04
     ffff-ffff : pnp 00:04

~$ cat /proc/iomem
00000000-00000fff : reserved
00001000-0009c3ff : System RAM
0009c400-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cebff : Video ROM
000cf000-000cffff : Adapter ROM
000d0000-000d23ff : Adapter ROM
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : reserved
000e0000-000e3fff : PCI Bus 0000:00
000e4000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-c727bfff : System RAM
   01000000-0176ff9d : Kernel code
   0176ff9e-01d1bc3f : Kernel data
   01e78000-01fdcfff : Kernel bss
c727c000-c7281fff : reserved
c7282000-c73f1fff : System RAM
c73f2000-c740efff : reserved
c740f000-c746ffff : System RAM
c7470000-c74f0fff : ACPI Non-volatile Storage
c74f1000-c770efff : reserved
c770f000-c7717fff : System RAM
c7718000-c771efff : reserved
c771f000-c777efff : System RAM
c777f000-c779efff : ACPI Non-volatile Storage
c779f000-c77e0fff : System RAM
c77e1000-c77fefff : ACPI Tables
c77ff000-c77fffff : System RAM
c7800000-c7ffffff : reserved
c8000000-feb00000 : PCI Bus 0000:00
   c8000000-cfdfffff : pnp 00:09
   cfe00000-cfefffff : PCI Bus 0000:01
     cfe00000-cfe1ffff : 0000:01:00.0
     cfedc000-cfedffff : 0000:01:00.1
       cfedc000-cfedffff : ICH HD audio
     cfee0000-cfefffff : 0000:01:00.0
   d0000000-dfffffff : PCI Bus 0000:01
     d0000000-dfffffff : 0000:01:00.0
       d0000000-d02fffff : BOOTFB
   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
     e00f8000-e00f8fff : reserved
     e0100000-e02fffff : PCI Bus 0000:05
     e0300000-e05fffff : PCI Bus 0000:09
       e0300000-e030ffff : 0000:09:00.0
   f0000000-f3ffffff : PCI Bus 0000:03
   f4000000-f7ffffff : PCI Bus 0000:06
   f8000000-f81fffff : PCI Bus 0000:03
     f8000000-f800ffff : 0000:03:00.0
       f8000000-f800ffff : ath9k
   f8200000-f83fffff : PCI Bus 0000:06
   f8400000-f84fffff : PCI Bus 0000:05
     f8400000-f840ffff : 0000:05:00.0
       f8400000-f840ffff : tg3
   f8500000-f85fffff : PCI Bus 0000:09
     f8500000-f85000ff : 0000:09:00.0
     f8500400-f85004ff : 0000:09:00.2
       f8500400-f85004ff : mmc0
     f8500800-f85008ff : 0000:09:00.3
       f8500800-f85008ff : jmb38x_ms
     f8500c00-f8500cff : 0000:09:00.4
   f8800000-f8803fff : 0000:00:1b.0
     f8800000-f8803fff : ICH HD audio
   f8806000-f88067ff : 0000:00:1f.2
     f8806000-f88067ff : ahci
   f8806800-f880680f : 0000:00:16.0
     f8806800-f880680f : mei_me
   f8807000-f88073ff : 0000:00:1a.0
     f8807000-f88073ff : ehci_hcd
   f8807400-f88077ff : 0000:00:1d.0
     f8807400-f88077ff : ehci_hcd
   f8807800-f88078ff : 0000:00:1f.3
   feaff100-feafffff : pnp 00:09
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed10000-fed17fff : pnp 00:09
fed18000-fed18fff : pnp 00:09
fed19000-fed19fff : pnp 00:09
fed1c000-fed8ffff : reserved
   fed1c000-fed1ffff : pnp 00:09
     fed1f410-fed1f414 : iTCO_wdt
   fed20000-fed3ffff : pnp 00:09
   fed40000-fed44fff : pnp 00:09
   fed45000-fed8ffff : pnp 00:09
fed90000-fed93fff : pnp 00:09
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
   ff000000-ffffffff : pnp 00:09
100000000-1b77fffff : System RAM
1b7800000-1b7ffffff : RAM buffer

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor 
Family DRAM Controller (rev 09)
         Subsystem: Lenovo Device 3975
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core 
Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 00002000-00002fff
         Memory behind bridge: cfe00000-cfefffff
         Prefetchable memory behind bridge: 
00000000d0000000-00000000dfffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [88] Subsystem: Intel Corporation Device 2010
         Capabilities: [80] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: feeff00c  Data: 4161
         Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
                         ClockPM- Surprise- LLActRep- BwNot+
                 LnkCtl: ASPM L0s Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train+ 
SlotClk+ DLActive- BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Not Supported, TimeoutDis- 
ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -3.5dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                         Status: NegoPending- InProgress-
         Capabilities: [140 v1] Root Complex Link
                 Desc:   PortNumber=02 ComponentID=01 EltType=Config
                 Link0:  Desc:   TargetPort=00 TargetComponent=01 
AssocRCRB- LinkType=MemMapped LinkValid+
                         Addr:   00000000fed19000
         Kernel driver in use: pcieport

00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series 
Chipset Family MEI Controller #1 (rev 04)
         Subsystem: Lenovo Device 3975
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 42
         Region 0: Memory at f8806800 (64-bit, non-prefetchable) [size=16]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000feeff00c  Data: 41b1
         Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
         Subsystem: Lenovo Device 3975
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at f8807000 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] PCI Advanced Features
                 AFCap: TP+ FLR+
                 AFCtrl: FLR-
                 AFStatus: TP-
         Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset 
Family High Definition Audio Controller (rev 05)
         Subsystem: Lenovo Device 3975
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 43
         Region 0: Memory at f8800000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000feeff00c  Data: 41d1
         Capabilities: [70] Express (v1) Root Complex Integrated 
Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE- FLReset+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, 
Latency L0 <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
                 VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=22
                         Status: NegoPending- InProgress-
         Capabilities: [130 v1] Root Complex Link
                 Desc:   PortNumber=0f ComponentID=00 EltType=Config
                 Link0:  Desc:   TargetPort=00 TargetComponent=00 
AssocRCRB- LinkType=MemMapped LinkValid+
                         Addr:   00000000fed1c000
         Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
         I/O behind bridge: 00003000-00003fff
         Memory behind bridge: f8000000-f81fffff
         Prefetchable memory behind bridge: 
00000000f0000000-00000000f3ffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <16us
                         ClockPM- Surprise- LLActRep+ BwNot-
                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet- LinkState+
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
ARIFwd-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: 00000000  Data: 0000
         Capabilities: [90] Subsystem: Lenovo Device 3975
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
         I/O behind bridge: 00005000-00005fff
         Memory behind bridge: f8400000-f84fffff
         Prefetchable memory behind bridge: 
00000000e0100000-00000000e02fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <16us
                         ClockPM- Surprise- LLActRep+ BwNot-
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surprise+
                         Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
ARIFwd-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: 00000000  Data: 0000
         Capabilities: [90] Subsystem: Lenovo Device 3975
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=06, subordinate=07, sec-latency=0
         I/O behind bridge: 00004000-00004fff
         Memory behind bridge: f8200000-f83fffff
         Prefetchable memory behind bridge: 
00000000f4000000-00000000f7ffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <16us
                         ClockPM- Surprise- LLActRep+ BwNot-
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surprise+
                         Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
ARIFwd-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: 00000000  Data: 0000
         Capabilities: [90] Subsystem: Lenovo Device 3975
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport

00:1c.6 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 7 (rev b5) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
         I/O behind bridge: 00006000-00006fff
         Memory behind bridge: f8500000-f85fffff
         Prefetchable memory behind bridge: 
00000000e0300000-00000000e05fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #7, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <16us
                         ClockPM- Surprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surprise+
                         Slot #6, PowerLimit 10.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- 
ARIFwd-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: 00000000  Data: 0000
         Capabilities: [90] Subsystem: Lenovo Device 3975
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
         Subsystem: Lenovo Device 3975
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 23
         Region 0: Memory at f8807400 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Capabilities: [98] PCI Advanced Features
                 AFCap: TP+ FLR+
                 AFCtrl: FLR-
                 AFStatus: TP+
         Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM65 Express Chipset Family LPC 
Controller (rev 05)
         Subsystem: Lenovo Device 3975
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
         Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset 
Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
         Subsystem: Lenovo Device 3975
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 41
         Region 0: I/O ports at 1818 [size=8]
         Region 1: I/O ports at 180c [size=4]
         Region 2: I/O ports at 1810 [size=8]
         Region 3: I/O ports at 1808 [size=4]
         Region 4: I/O ports at 1820 [size=32]
         Region 5: Memory at f8806000 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: fee2200c  Data: 41a1
         Capabilities: [70] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
         Capabilities: [b0] PCI Advanced Features
                 AFCap: TP+ FLR+
                 AFCtrl: FLR-
                 AFStatus: TP-
         Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family 
SMBus Controller (rev 05)
         Subsystem: Lenovo Device 3975
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin C routed to IRQ 5
         Region 0: Memory at f8807800 (64-bit, non-prefetchable) [size=256]
         Region 4: I/O ports at 1840 [size=32]

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. 
[AMD/ATI] Madison [Mobility Radeon HD 5730 / 6570M] (prog-if 00 [VGA 
controller])
         Subsystem: Lenovo Radeon HD 6570M
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
         Region 2: Memory at cfee0000 (64-bit, non-prefetchable) [size=128K]
         Region 4: I/O ports at 2000 [size=256]
         [virtual] Expansion ROM at cfe00000 [disabled] [size=128K]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, TimeoutDis-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>

01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Redwood 
HDMI Audio [Radeon HD 5000 Series]
         Subsystem: Lenovo Device 3978
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 44
         Region 0: Memory at cfedc000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, TimeoutDis-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000feeff00c  Data: 41e1
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Kernel driver in use: snd_hda_intel

03:00.0 Network controller: Qualcomm Atheros AR9285 Wireless Network 
Adapter (PCI-Express) (rev 01)
         Subsystem: Lenovo Device 30a1
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [40] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA 
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: 00000000  Data: 0000
         Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <64us
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Capabilities: [140 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                         Status: NegoPending- InProgress-
         Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
         Capabilities: [170 v1] Power Budgeting <?>
         Kernel driver in use: ath9k

05:00.0 Ethernet controller: Broadcom Corporation NetLink BCM57780 
Gigabit Ethernet PCIe (rev 01)
         Subsystem: Lenovo Device 3975
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 45
         Region 0: Memory at f8400000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [48] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [60] Vendor Specific Information: Len=6c <?>
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000feeff00c  Data: 4122
         Capabilities: [cc] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <32us
                         ClockPM+ Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk+
                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Capabilities: [13c v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                         Status: NegoPending- InProgress-
         Capabilities: [160 v1] Device Serial Number 60-eb-69-ff-fe-fc-12-35
         Capabilities: [16c v1] Power Budgeting <?>
         Kernel driver in use: tg3

09:00.0 System peripheral: JMicron Technology Corp. SD/MMC Host 
Controller (rev 20)
         Subsystem: Lenovo Device 3921
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 5
         Region 0: Memory at f8500000 (32-bit, non-prefetchable) [size=256]
         [virtual] Expansion ROM at e0300000 [disabled] [size=64K]
         Capabilities: [a4] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 unlimited, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: fffffffc  Data: 0000

09:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host 
Controller (rev 20) (prog-if 01)
         Subsystem: Lenovo Device 3922
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 18
         Region 0: Memory at f8500400 (32-bit, non-prefetchable) [size=256]
         Capabilities: [a4] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 unlimited, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: fffffffc  Data: 0000
         Kernel driver in use: sdhci-pci

09:00.3 System peripheral: JMicron Technology Corp. MS Host Controller 
(rev 20)
         Subsystem: Lenovo Device 3923
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 18
         Region 0: Memory at f8500800 (32-bit, non-prefetchable) [size=256]
         Capabilities: [a4] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 unlimited, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: fffffffc  Data: 0000
         Kernel driver in use: jmb38x_ms

09:00.4 System peripheral: JMicron Technology Corp. xD Host Controller 
(rev 20)
         Subsystem: Lenovo Device 3924
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 5
         Region 0: Memory at f8500c00 (32-bit, non-prefetchable) [size=256]
         Capabilities: [a4] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 unlimited, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
                 Address: fffffffc  Data: 0000


[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: TS64GMSA720      Rev: 5.0.
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: ST9500325AS      Rev: 0011
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: Slimtype Model: DVD A  DS8A5SH   Rev: XL63
   Type:   CD-ROM                           ANSI  SCSI revision: 05


[7.7.] Other information that might be relevant to the problem (please 
look in /proc and include all information that you think to be relevant):


[X.] Other notes, patches, fixes, workarounds:
I think the offending commit is in somewhere between v2.6.35 and 
v2.6.39. There are no freezes and strange cpu usage on v2.6.35. But I 
could not bisect. Details can be found here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1253037
