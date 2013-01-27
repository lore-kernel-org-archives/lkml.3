Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3A0WDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:03:10 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:55589 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab3A0WDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:03:09 -0500
X-Greylist: delayed 1027 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2013 17:03:08 EST
MIME-Version: 1.0
In-Reply-To: <CABSsHRKRwEa4bn8+cqQLtPFcpikA9GsFni4V+0p6bXdg_-k0VQ@mail.gmail.com>
References: <CABSsHRKRwEa4bn8+cqQLtPFcpikA9GsFni4V+0p6bXdg_-k0VQ@mail.gmail.com>
Date: Sun, 27 Jan 2013 17:03:07 -0500
Message-ID: <CABSsHRJ-6=p0AcqRTOX_-sRHjsDjzeLXq=s5MuRmbr7=BxM2KQ@mail.gmail.com>
Subject: Bad audio quality over HDMI when using snd-hda-intel driver
From: Gary Mann <archvilen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending this to linux-kernel instead. Seems like it may be some sort
of IRQ problem. Please CC me on any RE or comments.

This email is in regards to the snd-hda-intel codec driver that is a
part of the linux kernel and the issues that I have encountered.

My set up currently is a Dell Latitude E6500 with onboard Intel sound
and nvidia GPU. The laptop has a DisplayPort which I'm using to
connect to a HDMI cable using a DP to HDMI adapter. From the DP to
HDMI adapter, the HDMI cable is plugged from the adapter directly into
my television, which (the audio) is then transferred to a sound
receiver for audio output. Attached is the rest of the information for
this bug report as asked for in the linux kernel bug reporting tips.

Please let me know if I can be any more assistance

REPORT:

[1.] One line summary of the problem: Bad audio quality over HDMI when
using snd-hda-intel_hdmi capability
[2.] Full description of the problem/report: Any audio going over HDMI
will produce crackly broken sound
[3.] Keywords (i.e., modules, networking, kernel): audio, hdmi, intel,
nvidia, nouveau, snd_hda_intel
[4.] Kernel version (from /proc/version): Linux version 3.7.43.7.1
(gmann@localhost.localdomain) (gcc version 4.5.1 20100924 (Red Hat
4.5.1-4) (GCC) ) #1 SMP Tue Jan 22 23:04:31 EST 2013
[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt): None
[6.] A small shell script or example program which triggers the
     problem (if possible): None
[7.] Environment: Any
[7.1.] Software (add the output of the ver_linux script here):
Linux localhost.localdomain 3.7.43.7.1 #1 SMP Tue Jan 22 23:04:31 EST
2013 i686 i686 i386 GNU/Linux

Gnu C                  4.5.1
Gnu make               3.82
binutils               2.20.51.0.7
util-linux             2.18
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.12
xfsprogs               3.1.2
pcmciautils            017
quota-tools            3.17.
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
oprofile               0.9.6
Sh-utils               8.5
wireless-tools         29
Modules Loaded         fuse rfcomm bnep sunrpc cpufreq_ondemand
acpi_cpufreq mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables ipv6 uinput btusb snd_hda_codec_idt
bluetooth rfkill e1000e snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_timer snd soundcore dell_laptop
snd_page_alloc dell_wmi i2c_i801 dcdbas sparse_keymap joydev microcode
firewire_ohci sdhci_pci sdhci firewire_core pata_acpi mmc_core
crc_itu_t yenta_socket ata_generic nouveau ttm drm_kms_helper drm
i2c_algo_bit i2c_core mxm_wmi video wmi

[7.2.] Processor information (from /proc/cpuinfo):
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 23
model name : Intel(R) Core(TM)2 Duo CPU     P9700  @ 2.80GHz
stepping : 10
microcode : 0xa0c
cpu MHz : 800.000
cache size : 6144 KB
physical id : 0
siblings : 2
core id : 0
cpu cores : 2
apicid : 0
initial apicid : 0
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida
dtherm tpr_shadow vnmi flexpriority
bogomips : 5586.09
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 23
model name : Intel(R) Core(TM)2 Duo CPU     P9700  @ 2.80GHz
stepping : 10
microcode : 0xa0c
cpu MHz : 800.000
cache size : 6144 KB
physical id : 0
siblings : 2
core id : 1
cpu cores : 2
apicid : 1
initial apicid : 1
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 13
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida
dtherm tpr_shadow vnmi flexpriority
bogomips : 5586.09
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
fuse 55424 1 - Live 0xf7b05000
rfcomm 46361 4 - Live 0xf9e1d000
bnep 11136 2 - Live 0xf9c81000
sunrpc 154464 1 - Live 0xf9c54000
cpufreq_ondemand 5063 2 - Live 0xf9c4c000
acpi_cpufreq 9928 1 - Live 0xf9c21000
mperf 1122 1 acpi_cpufreq, Live 0xf9bee000
ip6t_REJECT 3256 2 - Live 0xf9bca000
nf_conntrack_ipv6 6343 7 - Live 0xf9b87000
nf_defrag_ipv6 7171 1 nf_conntrack_ipv6, Live 0xf9b0f000
ip6table_filter 1168 1 - Live 0xf9a98000
ip6_tables 9221 1 ip6table_filter, Live 0xf9a58000
ipv6 237947 33 ip6t_REJECT,nf_conntrack_ipv6,nf_defrag_ipv6, Live 0xf99c3000
uinput 5515 0 - Live 0xf9942000
btusb 12349 0 - Live 0xf979d000
snd_hda_codec_idt 47767 1 - Live 0xf918d000
bluetooth 225830 26 rfcomm,bnep,btusb, Live 0xf8042000
rfkill 13357 3 bluetooth, Live 0xf7e69000
e1000e 155113 0 - Live 0xf7eae000
snd_hda_intel 24474 5 - Live 0xf7e57000
snd_hda_codec 88924 2 snd_hda_codec_idt,snd_hda_intel, Live 0xf7927000
snd_hwdep 4659 1 snd_hda_codec, Live 0xf789c000
snd_seq 42592 0 - Live 0xf78e6000
snd_seq_device 4822 1 snd_seq, Live 0xf7894000
snd_pcm 65437 4 snd_hda_intel,snd_hda_codec, Live 0xf7851000
snd_timer 14887 2 snd_seq,snd_pcm, Live 0xf7849000
snd 49150 16 snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq,snd_seq_device,snd_pcm,snd_timer,
Live 0xf7836000
soundcore 4775 1 snd, Live 0xfdf86000
dell_laptop 8225 0 - Live 0xfdf55000
snd_page_alloc 6265 2 snd_hda_intel,snd_pcm, Live 0xfdf25000
dell_wmi 1290 0 - Live 0xfdec9000
i2c_i801 9370 0 - Live 0xfde52000
dcdbas 5993 1 dell_laptop, Live 0xfde12000
sparse_keymap 2742 1 dell_wmi, Live 0xfdde1000
joydev 6948 0 - Live 0xfddba000
microcode 12142 0 - Live 0xfdbf6000
firewire_ohci 23953 0 - Live 0xfdbdf000
sdhci_pci 9000 0 - Live 0xfcffb000
sdhci 23026 1 sdhci_pci, Live 0xfcfbc000
firewire_core 43150 1 firewire_ohci, Live 0xfaf71000
pata_acpi 2387 0 - Live 0xf9efd000
mmc_core 76806 2 sdhci_pci,sdhci, Live 0xf9ee1000
crc_itu_t 1262 1 firewire_core, Live 0xf9edd000
yenta_socket 19268 0 - Live 0xf9d75000
ata_generic 2679 0 - Live 0xf9d6e000
nouveau 651535 2 - Live 0xf9c88000
ttm 47004 1 nouveau, Live 0xf80a0000
drm_kms_helper 22629 1 nouveau, Live 0xf7f48000
drm 185642 4 nouveau,ttm,drm_kms_helper, Live 0xf7e7f000
i2c_algo_bit 4189 1 nouveau, Live 0xf794f000
i2c_core 21222 5 i2c_i801,nouveau,drm_kms_helper,drm,i2c_algo_bit,
Live 0xf7920000
mxm_wmi 1434 1 nouveau, Live 0xf78e4000
video 10732 1 nouveau, Live 0xf78a0000
wmi 7374 3 dell_wmi,nouveau,mxm_wmi, Live 0xf7863000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem):
ioports>
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  04d0-04d1 : pnp 00:0a
  0809-0809 : pnp 00:0b
  0900-092f : pnp 00:0a
  0930-0930 : EC data
  0931-0933 : pnp 00:0a
  0934-0934 : EC cmd
  0935-097f : pnp 00:0a
  0c80-0caf : pnp 00:05
  0cb0-0cbb : pnp 00:09
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1005 : pnp 00:0a
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
  1006-1007 : pnp 00:0b
  1008-100f : pnp 00:0a
    1008-100b : ACPI PM_TMR
  1010-102f : pnp 00:0b
    1010-1015 : ACPI CPU throttle
    1020-102f : ACPI GPE0_BLK
  1050-1050 : ACPI PM2_CNT_BLK
  1060-107f : pnp 00:0b
  1080-10bf : pnp 00:0b
  1100-111f : 0000:00:1f.3
    1100-111f : pnp 00:0b
      1100-111f : i801_smbus
  2000-2fff : PCI Bus 0000:0b
  3000-3fff : PCI Bus 0000:0c
  4000-4fff : PCI Bus 0000:0d
  5000-5fff : PCI Bus 0000:03
    5000-50ff : PCI CardBus 0000:04
    5400-54ff : PCI CardBus 0000:04
  6e70-6e77 : 0000:00:1f.2
    6e70-6e77 : ahci
  6e78-6e7b : 0000:00:1f.2
    6e78-6e7b : ahci
  6e80-6e87 : 0000:00:1f.2
    6e80-6e87 : ahci
  6e88-6e8b : 0000:00:1f.2
    6e88-6e8b : ahci
  6ea0-6ebf : 0000:00:1f.2
    6ea0-6ebf : ahci
  6f00-6f1f : 0000:00:1d.0
    6f00-6f1f : uhci_hcd
  6f20-6f3f : 0000:00:1d.1
    6f20-6f3f : uhci_hcd
  6f40-6f5f : 0000:00:1d.2
    6f40-6f5f : uhci_hcd
  6f60-6f7f : 0000:00:1a.0
    6f60-6f7f : uhci_hcd
  6f80-6f9f : 0000:00:1a.1
    6f80-6f9f : uhci_hcd
  6fa0-6fbf : 0000:00:1a.2
    6fa0-6fbf : uhci_hcd
  c000-cfff : PCI Bus 0000:0e
  d000-dfff : PCI Bus 0000:01
    df00-df7f : 0000:01:00.0
  ef70-ef73 : 0000:00:03.2
    ef70-ef73 : ata_generic
  ef74-ef77 : 0000:00:03.2
    ef74-ef77 : ata_generic
  ef78-ef7f : 0000:00:03.2
    ef78-ef7f : ata_generic
  ef80-ef87 : 0000:00:03.2
    ef80-ef87 : ata_generic
  ef88-ef8f : 0000:00:03.3
    ef88-ef8f : serial
  ef90-ef9f : 0000:00:03.2
    ef90-ef9f : ata_generic
  efe0-efff : 0000:00:19.0
  f400-f4fe : pnp 00:0b

iomem>
00000000-0000ffff : reserved
00010000-0009bbff : System RAM
0009bc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000ce7ff : Video ROM
000ce800-000d37ff : Adapter ROM
000d3800-000d3fff : Adapter ROM
000d4000-000dffff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-df44d3ff : System RAM
  00400000-007f5aaf : Kernel code
  007f5ab0-00a576ff : Kernel data
  00aeb000-00bbdfff : Kernel bss
df44d400-df44f3ff : RAM buffer
df44f400-dfffffff : reserved
  dff00000-dfffffff : pnp 00:0c
e0000000-f7ffffff : PCI Bus 0000:00
  e0000000-efffffff : PCI Bus 0000:01
    e0000000-efffffff : 0000:01:00.0
  f0000000-f01fffff : PCI Bus 0000:0e
  f0200000-f03fffff : PCI Bus 0000:0b
  f0400000-f05fffff : PCI Bus 0000:0b
  f0600000-f07fffff : PCI Bus 0000:0c
  f0800000-f09fffff : PCI Bus 0000:0d
  f0a00000-f0bfffff : PCI Bus 0000:0d
  f0c00000-f0ffffff : PCI CardBus 0000:04
  f1000000-f13fffff : PCI CardBus 0000:04
  f1b00000-f1bfffff : PCI Bus 0000:03
    f1bff700-f1bff7ff : 0000:03:01.2
      f1bff700-f1bff7ff : mmc0
    f1bff800-f1bfffff : 0000:03:01.1
      f1bff800-f1bfffff : firewire_ohci
  f1c00000-f1efffff : PCI Bus 0000:0e
  f1f00000-f1ffffff : PCI Bus 0000:0c
    f1ffe000-f1ffffff : 0000:0c:00.0
  f2000000-f6efffff : PCI Bus 0000:01
    f2000000-f3ffffff : 0000:01:00.0
    f4000000-f401ffff : 0000:01:00.0
    f5000000-f5ffffff : 0000:01:00.0
  f6fd9ef0-f6fd9eff : 0000:00:03.0
  f6fd9f00-f6fd9fff : 0000:00:1f.3
  f6fda000-f6fdafff : 0000:00:03.3
  f6fdb000-f6fdbfff : 0000:00:19.0
    f6fdb000-f6fdbfff : e1000e
  f6fdc000-f6fdffff : 0000:00:1b.0
    f6fdc000-f6fdffff : ICH HD audio
  f6fe0000-f6ffffff : 0000:00:19.0
    f6fe0000-f6ffffff : e1000e
f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
  f8000000-fbffffff : reserved
    f8000000-fbffffff : pnp 00:0c
fc000000-febfffff : PCI Bus 0000:00
  fc000000-fc000fff : 0000:03:01.0
    fc000000-fc000fff : yenta_socket
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fec10000-fecfffff : PCI Bus 0000:00
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : pnp 00:08
fed18000-fed1bfff : reserved
  fed18000-fed1bfff : pnp 00:0c
fed1c000-fed1ffff : PCI Bus 0000:00
  fed1c000-fed1c3ff : 0000:00:1d.7
    fed1c000-fed1c3ff : ehci_hcd
  fed1c400-fed1c7ff : 0000:00:1a.7
    fed1c400-fed1c7ff : ehci_hcd
  fed1c800-fed1cfff : 0000:00:1f.2
    fed1c800-fed1cfff : pnp 00:0c
      fed1c800-fed1cfff : ahci
fed20000-fed8ffff : reserved
  fed20000-fed3ffff : pnp 00:0c
  fed40000-fed44fff : PCI Bus 0000:00
    fed40000-fed44fff : pnp 00:09
  fed45000-fed8ffff : pnp 00:0c
fed90000-fed9ffff : PCI Bus 0000:00
feda0000-feda5fff : reserved
  feda0000-feda3fff : pnp 00:0c
  feda4000-feda4fff : pnp 00:0c
  feda5000-feda5fff : pnp 00:0c
feda6000-feda6fff : pnp 00:0c
feda7000-fedfffff : PCI Bus 0000:00
fee00000-fee0ffff : reserved
  fee00000-fee0ffff : pnp 00:0c
    fee00000-fee00fff : Local APIC
fee10000-ff9fffff : PCI Bus 0000:00
ffa00000-ffbfffff : pnp 00:0c
ffc00000-ffdfffff : PCI Bus 0000:00
ffe60000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root):

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
Subsystem: Dell Device 024f
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0a <?>

00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI
Express Graphics Port (rev 07) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: f2000000-f6efffff
Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [88] Subsystem: Dell Device 024f
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0300c  Data: 41b1
Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<256ns, L1 <4us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Off, PwrInd On, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed+ WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [140 v1] Root Complex Link
Desc: PortNumber=02 ComponentID=01 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000feda5000
Kernel driver in use: pcieport

00:03.0 Communication controller: Intel Corporation Mobile 4 Series
Chipset MEI Controller (rev 07)
Subsystem: Dell Device 024f
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx+
Latency: 0
Interrupt: pin A routed to IRQ 11
Region 0: Memory at f6fd9ef0 (64-bit, non-prefetchable) [size=16]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000

00:03.2 IDE interface: Intel Corporation Mobile 4 Series Chipset PT
IDER Controller (rev 07) (prog-if 85 [Master SecO PriO])
Subsystem: Dell Device 024f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 18
Region 0: I/O ports at ef78 [size=8]
Region 1: I/O ports at ef70 [size=4]
Region 2: I/O ports at ef80 [size=8]
Region 3: I/O ports at ef74 [size=4]
Region 4: I/O ports at ef90 [size=16]
Capabilities: [c8] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Kernel driver in use: ata_generic

00:03.3 Serial controller: Intel Corporation Mobile 4 Series Chipset
AMT SOL Redirection (rev 07) (prog-if 02 [16550])
Subsystem: Dell Device 024f
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 17
Region 0: I/O ports at ef88 [size=8]
Region 1: Memory at f6fda000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [c8] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Kernel driver in use: serial

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network
Connection (rev 03)
Subsystem: Dell Device 024f
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 47
Region 0: Memory at f6fe0000 (32-bit, non-prefetchable) [size=128K]
Region 1: Memory at f6fdb000 (32-bit, non-prefetchable) [size=4K]
Region 2: I/O ports at efe0 [size=32]
Capabilities: [c8] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0200c  Data: 4182
Capabilities: [e0] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: e1000e
Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
Subsystem: Dell Device 024f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 20
Region 4: I/O ports at 6f60 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
Subsystem: Dell Device 024f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 21
Region 4: I/O ports at 6f80 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #6 (rev 03) (prog-if 00 [UHCI])
Subsystem: Dell Device 024f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 22
Region 4: I/O ports at 6fa0 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
Subsystem: Dell Device 024f
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 22
Region 0: Memory at fed1c400 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)
Subsystem: Dell Device 024f
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 46
Region 0: Memory at f6fdc000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0300c  Data: 4152
Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE- FLReset+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
Status: NegoPending- InProgress-
VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable- ID=0 ArbSelect=Fixed TC/VC=00
Status: NegoPending- InProgress-
Capabilities: [130 v1] Root Complex Link
Desc: PortNumber=0f ComponentID=02 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed18000
Kernel driver in use: snd_hda_intel
Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 03) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
I/O behind bridge: 00002000-00002fff
Memory behind bridge: f0200000-f03fffff
Prefetchable memory behind bridge: 00000000f0400000-00000000f05fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0300c  Data: 41c1
Capabilities: [90] Subsystem: Dell Device 024f
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed+ WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [180 v1] Root Complex Link
Desc: PortNumber=01 ComponentID=02 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed18000
Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 2 (rev 03) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
I/O behind bridge: 00003000-00003fff
Memory behind bridge: f1f00000-f1ffffff
Prefetchable memory behind bridge: 00000000f0600000-00000000f07fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0300c  Data: 41d1
Capabilities: [90] Subsystem: Dell Device 024f
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed+ WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [180 v1] Root Complex Link
Desc: PortNumber=02 ComponentID=02 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed18000
Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 3 (rev 03) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
I/O behind bridge: 00004000-00004fff
Memory behind bridge: f0800000-f09fffff
Prefetchable memory behind bridge: 00000000f0a00000-00000000f0bfffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0300c  Data: 41e1
Capabilities: [90] Subsystem: Dell Device 024f
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed+ WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [180 v1] Root Complex Link
Desc: PortNumber=03 ComponentID=02 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed18000
Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 4 (rev 03) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=0e, subordinate=0f, sec-latency=0
I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: f1c00000-f1efffff
Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
ExtTag- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
Changed: MRL- PresDet- LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0300c  Data: 4122
Capabilities: [90] Subsystem: Dell Device 024f
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed+ WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [180 v1] Root Complex Link
Desc: PortNumber=04 ComponentID=02 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=02 AssocRCRB-
LinkType=MemMapped LinkValid+
Addr: 00000000fed18000
Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
Subsystem: Dell Device 024f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 20
Region 4: I/O ports at 6f00 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
Subsystem: Dell Device 024f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 21
Region 4: I/O ports at 6f20 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
Subsystem: Dell Device 024f
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 22
Region 4: I/O ports at 6f40 [size=32]
Capabilities: [50] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
Subsystem: Dell Device 024f
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 20
Region 0: Memory at fed1c000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
(prog-if 01 [Subtractive decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Bus: primary=00, secondary=03, subordinate=07, sec-latency=32
I/O behind bridge: 00005000-00005fff
Memory behind bridge: f1b00000-f1bfffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Subsystem: Dell Device 024f

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
Subsystem: Dell Device 024f
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 RAID bus controller: Intel Corporation Mobile 82801 SATA RAID
Controller (rev 03)
Subsystem: Dell Device 024f
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin D routed to IRQ 45
Region 0: I/O ports at 6e70 [size=8]
Region 1: I/O ports at 6e78 [size=4]
Region 2: I/O ports at 6e80 [size=8]
Region 3: I/O ports at 6e88 [size=4]
Region 4: I/O ports at 6ea0 [size=32]
Region 5: Memory at fed1c800 (32-bit, non-prefetchable) [size=2K]
Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
Address: fee0100c  Data: 4142
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
Capabilities: [b0] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
Subsystem: Dell Device 024f
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin B routed to IRQ 19
Region 0: Memory at f6fd9f00 (64-bit, non-prefetchable) [size=256]
Region 4: I/O ports at 1100 [size=32]
Kernel driver in use: i801_smbus
Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation G98M [Quadro NVS
160M] (rev a1) (prog-if 00 [VGA controller])
Subsystem: Dell Device 024f
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
Region 3: Memory at f2000000 (64-bit, non-prefetchable) [size=32M]
Region 5: I/O ports at df00 [size=128]
[virtual] Expansion ROM at f4000000 [disabled] [size=128K]
Capabilities: [60] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [78] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [128 v1] Power Budgeting <?>
Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>
Kernel driver in use: nouveau
Kernel modules: nouveau

03:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
Subsystem: Dell Device 024f
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 168, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 19
Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=4K]
Bus: primary=03, secondary=04, subordinate=07, sec-latency=176
Memory window 0: f0c00000-f0fff000 (prefetchable)
Memory window 1: f1000000-f13ff000
I/O window 0: 00005400-000054ff
I/O window 1: 00005000-000050ff
BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
16-bit legacy interface ports at 0001
Kernel driver in use: yenta_cardbus
Kernel modules: yenta_socket

03:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
(rev 04) (prog-if 10 [OHCI])
Subsystem: Dell Device 024f
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Region 0: Memory at f1bff800 (32-bit, non-prefetchable) [size=2K]
Capabilities: [dc] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
Kernel driver in use: firewire_ohci
Kernel modules: firewire-ohci

03:01.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro
Host Adapter (rev 21) (prog-if 01)
Subsystem: Dell Device 024f
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 64, Cache Line Size: 64 bytes
Interrupt: pin C routed to IRQ 18
Region 0: Memory at f1bff700 (32-bit, non-prefetchable) [size=256]
Capabilities: [80] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
Kernel driver in use: sdhci-pci
Kernel modules: sdhci-pci

0c:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
Subsystem: Intel Corporation Device 1121
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 5
Region 0: Memory at f1ffe000 (64-bit, non-prefetchable) [size=8K]
Capabilities: [c8] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [e0] Express (v1) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<128ns, L1 <32us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Device Serial Number 00-21-6a-ff-ff-ae-58-5a
[7.6.] SCSI information (from /proc/scsi/scsi):
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST9250410ASG     Rev: 0004
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: MATSHITA Model: BD-RE UJ242      Rev: 1.00
  Type:   CD-ROM                           ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
/proc/asound/card0/pcm*/info:
card: 0
device: 0
subdevice: 0
stream: CAPTURE
id: STAC92xx Analog
name: STAC92xx Analog
subname: subdevice #0
class: 0
subclass: 0
subdevices_count: 1
subdevices_avail: 0
card: 0
device: 0
subdevice: 0
stream: PLAYBACK
id: STAC92xx Analog
name: STAC92xx Analog
subname: subdevice #0
class: 0
subclass: 0
subdevices_count: 1
subdevices_avail: 1
card: 0
device: 1
subdevice: 0
stream: PLAYBACK
id: STAC92xx Digital
name: STAC92xx Digital
subname: subdevice #0
class: 0
subclass: 0
subdevices_count: 1
subdevices_avail: 0

[X.] Other notes, patches, fixes, workarounds: Tried adding the flags
as mentioned in the snd_hda_intel FAQ for crackly sound but was
unsuccessful in repairing the issue. Tested hardware by using
proprietary nVIDIA driver which had produced good quality sound, when
trying to use novueau I began to experience crackly quality sound.


ALSA-INFO:

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.60
!!################################

!!Script ran on: Wed Jan 23 05:04:41 UTC 2013


!!Linux Distribution
!!------------------

Fedora release 14 (Laughlin) Fedora release 14 (Laughlin) Fedora
release 14 (Laughlin) Fedora release 14 (Laughlin)


!!DMI Information
!!---------------

Manufacturer:      Dell Inc.
Product Name:      Latitude E6500
Product Version:


!!Kernel Information
!!------------------

Kernel release:    3.7.43.7.1
Operating System:  GNU/Linux
Architecture:      i686
Processor:         i686
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     k3.7.43.7.1
Library version:    1.0.24
Utilities version:  1.0.24.1


!!Loaded ALSA modules
!!-------------------

snd_hda_intel


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/usr/bin/pulseaudio)
      Running - Yes

aRts:
      Installed - Yes (/usr/bin/artsd)
      Running - No

Jack:
      Installed - Yes (/usr/bin/jackd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xf6fdc000 irq 47


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!--------------------------------------------------------

00:1b.0 0403: 8086:293e (rev 03)
Subsystem: 1028:024f


!!Modprobe options (Sound related)
!!--------------------------------

snd-hda-intel: model=auto
snd-hda-intel: position_fix=2


!!Loaded sound module options
!!--------------------------

!!Module: snd_hda_intel
align_buffer_size : -1
bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
beep_mode : N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N,N
enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
enable_msi : -1
id : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
index : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
model : auto,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
patch : (null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)
position_fix : 2,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
power_save : 0
power_save_controller : Y
probe_mask : -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
probe_only : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
single_cmd : N
snoop : Y


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: IDT 92HD71B7X
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x111d76b2
Subsystem Id: 0x1028024f
Revision Id: 0x100302
No Modem Function Group found
Default PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
Default Amp-Out caps: ofs=0x7f, nsteps=0x7f, stepsize=0x02, mute=1
GPIO: io=8, o=0, i=0, unsolicited=1, wake=1
  IO[0]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[4]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[5]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[6]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[7]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Power-Map: 0x05
Analog Loopback: 0x00
Node 0x0a [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Headphone Jack", index=0, device=0
  Pincap 0x0000001c: OUT HP Detect
  Pin Default 0x0421101f: [Jack] HP Out at Ext Right
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=01, enabled=1
  Connection: 3
     0x10 0x11* 0x17
Node 0x0b [Pin Complex] wcaps 0x400081: Stereo
  Control: name="Mic Jack Mode", index=0, device=0
    ControlAmp: chs=0, dir=In, idx=0, ofs=0
  Control: name="Mic Jack", index=0, device=0
  Pincap 0x00001724: IN Detect
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x04a11021: [Jack] Mic at Ext Right
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0x1
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=03, enabled=1
Node 0x0c [Pin Complex] wcaps 0x400081: Stereo
  Pincap 0x00001724: IN Detect
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x40f000f0: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
  Pin-ctls: 0x00: VREF_HIZ
  Unsolicited: tag=00, enabled=0
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Speaker Phantom Jack", index=0, device=0
  Pincap 0x00000014: OUT Detect
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 3
     0x10* 0x11 0x17
Node 0x0e [Pin Complex] wcaps 0x400081: Stereo
  Control: name="Dock Mic Jack Mode", index=0, device=0
    ControlAmp: chs=0, dir=In, idx=0, ofs=0
  Control: name="Dock Mic Jack", index=0, device=0
  Pincap 0x00001724: IN Detect
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x23a1102e: [Jack] Mic at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0xe
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=04, enabled=1
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Dock Line Out Jack", index=0, device=0
  Pincap 0x00000014: OUT Detect
  Pin Default 0x23011050: [Jack] Line Out at Sep Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x5, Sequence = 0x0
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=02, enabled=1
  Connection: 3
     0x10* 0x11 0x17
Node 0x10 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Control: name="Front Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=63
  Control: name="Front Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Device: name="STAC92xx Analog", type="Audio", device=0
  Amp-Out caps: N/A
  Amp-Out vals:  [0x65 0x65]
  Converter: stream=0, channel=0
  Power states:
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x11 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
  Control: name="Headphone Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=63
  Control: name="Headphone Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: N/A
  Amp-Out vals:  [0x65 0x65]
  Converter: stream=0, channel=0
  Power states:
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x12 [Audio Input] wcaps 0x1d0541: Stereo
  Device: name="STAC92xx Analog", type="Audio", device=0
  Converter: stream=4, channel=0
  SDI-Select: 0
  Power states:
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x1c
  Processing caps: benign=0, ncoeff=0
Node 0x13 [Audio Input] wcaps 0x1d0541: Stereo
  Converter: stream=0, channel=0
  SDI-Select: 0
  Power states:
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x1d
  Processing caps: benign=0, ncoeff=0
Node 0x14 [Pin Complex] wcaps 0x400100: Mono
  Pincap 0x00000010: OUT
  Pin Default 0x40f000f2: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x2
  Pin-ctls: 0x00:
  Connection: 1
     0x16
Node 0x15 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x10* 0x11 0x17
Node 0x16 [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x15
Node 0x17 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x97 0x97] [0x97 0x97] [0x97 0x97] [0x97 0x97] [0x97 0x97]
  Connection: 5
     0x10 0x11 0x27 0x1a 0x1b
Node 0x18 [Pin Complex] wcaps 0x40000d: Stereo Amp-Out
  Control: name="Internal Mic Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000020: IN
  Pin Default 0x90a601a0: [Fixed] Mic at Int N/A
    Conn = Digital, Color = Unknown
    DefAssociation = 0xa, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x19 [Pin Complex] wcaps 0x40000d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x00000020: IN
  Pin Default 0x40f000f4: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x4
  Pin-ctls: 0x00:
Node 0x1a [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Mux Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 3
     0x0b* 0x0c 0x0e
Node 0x1b [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 3
     0x0b* 0x0c 0x0e
Node 0x1c [Audio Selector] wcaps 0x30090d: Stereo Amp-Out R/L
  Control: name="Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="Capture Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x0f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x08 0x08]
  Connection: 4
     0x1a 0x17 0x18* 0x19
Node 0x1d [Audio Selector] wcaps 0x30090d: Stereo Amp-Out R/L
  Amp-Out caps: ofs=0x00, nsteps=0x0f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 4
     0x1b* 0x17 0x18 0x19
Node 0x1e [Pin Complex] wcaps 0x400301: Stereo Digital
  Control: name="SPDIF Phantom Jack", index=0, device=0
  Pincap 0x00000010: OUT
  Pin Default 0x014613b0: [Jack] SPDIF Out at Ext Rear
    Conn = Digital, Color = Black
    DefAssociation = 0xb, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x24
Node 0x1f [Pin Complex] wcaps 0x400701: Stereo Digital
  Pincap 0x00010010: OUT EAPD
  EAPD 0x0:
  Pin Default 0x40f000f6: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x6
  Pin-ctls: 0x00:
  Power states:
  Power: setting=D0, actual=D0
  Connection: 2
     0x24* 0x25
Node 0x20 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x40f000f7: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x7
  Pin-ctls: 0x00:
  Connection: 1
     0x25
Node 0x21 [Audio Output] wcaps 0x40211: Stereo Digital
  Control: name="IEC958 Playback Con Mask", index=0, device=0
  Control: name="IEC958 Playback Pro Mask", index=0, device=0
  Control: name="IEC958 Playback Default", index=0, device=0
  Control: name="IEC958 Playback Switch", index=0, device=0
  Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
  Device: name="STAC92xx Digital", type="SPDIF", device=1
  Converter: stream=8, channel=0
  Digital: Enabled GenLevel
  Digital category: 0x2
  IEC Coding Type: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x22 [Audio Output] wcaps 0x40211: Stereo Digital
  Converter: stream=8, channel=0
  Digital: Enabled GenLevel
  Digital category: 0x2
  IEC Coding Type: 0x0
  PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x23 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x24 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x21* 0x1c 0x1d
Node 0x25 [Audio Selector] wcaps 0x300101: Stereo
  Connection: 3
     0x22* 0x1c 0x1d
Node 0x26 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Control: name="Beep Playback Switch", index=0, device=0
    ControlAmp: chs=1, dir=Out, idx=0, ofs=0
  Control: name="Beep Playback Volume", index=0, device=0
    ControlAmp: chs=1, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=1
  Amp-Out vals:  [0x00]
Node 0x27 [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x00000020: IN
  Pin Default 0x40f000f0: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
  Pin-ctls: 0x00:
Node 0x28 [Volume Knob Widget] wcaps 0x600000: Mono
  Volume-Knob: delta=1, steps=127, direct=1, val=127
  Connection: 2
     0x10 0x11
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116,  6 Jan 23 00:02 /dev/snd/controlC0
crw-rw----+ 1 root audio 116,  5 Jan 23 00:02 /dev/snd/hwC0D0
crw-rw----+ 1 root audio 116,  4 Jan 23 00:03 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116,  3 Jan 23 00:03 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116,  2 Jan 23 00:03 /dev/snd/pcmC0D1p
crw-rw----+ 1 root audio 116,  1 Jan 23 00:02 /dev/snd/seq
crw-rw----+ 1 root audio 116, 33 Jan 23 00:02 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jan 23 00:02 .
drwxr-xr-x 3 root root 200 Jan 23 00:02 ..
lrwxrwxrwx 1 root root  12 Jan 23 00:02 pci-0000:00:1b.0 -> ../controlC0


!!ALSA configuration files
!!------------------------

!!System wide config file (/etc/asound.conf)

#
# Place your global alsa-lib configuration here...
#

@hooks [
{
func load
files [
"/etc/alsa/pulse-default.conf"
]
errors false
}
]


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
  Subdevices: 0/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
  Subdevices: 0/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xf6fdc000 irq 47'
  Mixer name : 'IDT 92HD71B7X'
  Components : 'HDA:111d76b2,1028024f,00100302'
  Controls      : 30
  Simple ctrls  : 13
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 64
  Mono: Playback 38 [59%] [-19.50dB] [on]
Simple mixer control 'Headphone',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 64
  Mono:
  Front Left: Playback 64 [100%] [0.00dB] [on]
  Front Right: Playback 64 [100%] [0.00dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 252 [99%] [0.60dB]
  Front Right: Playback 252 [99%] [0.60dB]
Simple mixer control 'Front',0
  Capabilities: pvolume pswitch penum
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 64
  Mono:
  Front Left: Playback 64 [100%] [0.00dB] [on]
  Front Right: Playback 64 [100%] [0.00dB] [on]
Simple mixer control 'Mic Jack Mode',0
  Capabilities: enum
  Items: 'Mic In' 'Line In'
  Item0: 'Mic In'
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958 Default PCM',0
  Capabilities: pswitch pswitch-joined penum
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958 Playback Source',0
  Capabilities: enum
  Items: 'Digital Playback' 'Analog Mux 1' 'Analog Mux 2'
  Item0: 'Digital Playback'
Simple mixer control 'Beep',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
  Playback channels: Mono
  Limits: Playback 0 - 3
  Mono: Playback 0 [0%] [-18.00dB] [on]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 8 [53%] [12.00dB] [on]
  Front Right: Capture 8 [53%] [12.00dB] [on]
Simple mixer control 'Dock Mic Jack Mode',0
  Capabilities: enum
  Items: 'Mic In' 'Line In'
  Item0: 'Mic In'
Simple mixer control 'Internal Mic',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 3
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]
Simple mixer control 'Mux',0
  Capabilities: cvolume penum
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 3
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]


!!Alsactl output
!!-------------

--startcollapse--
state.Intel {
control.1 {
iface MIXER
name 'Front Playback Volume'
value.0 64
value.1 64
comment {
access 'read write'
type INTEGER
count 2
range '0 - 64'
dbmin -4800
dbmax 0
dbvalue.0 0
dbvalue.1 0
}
}
control.2 {
iface MIXER
name 'Front Playback Switch'
value.0 true
value.1 true
comment {
access 'read write'
type BOOLEAN
count 2
}
}
control.3 {
iface MIXER
name 'Mic Jack Mode'
value 'Mic In'
comment {
access 'read write'
type ENUMERATED
count 1
item.0 'Mic In'
item.1 'Line In'
}
}
control.4 {
iface MIXER
name 'Dock Mic Jack Mode'
value 'Mic In'
comment {
access 'read write'
type ENUMERATED
count 1
item.0 'Mic In'
item.1 'Line In'
}
}
control.5 {
iface MIXER
name 'Beep Playback Switch'
value true
comment {
access 'read write'
type BOOLEAN
count 1
}
}
control.6 {
iface MIXER
name 'Beep Playback Volume'
value 0
comment {
access 'read write'
type INTEGER
count 1
range '0 - 3'
dbmin -1800
dbmax 0
dbvalue.0 -1800
}
}
control.7 {
iface MIXER
name 'Headphone Playback Volume'
value.0 64
value.1 64
comment {
access 'read write'
type INTEGER
count 2
range '0 - 64'
dbmin -4800
dbmax 0
dbvalue.0 0
dbvalue.1 0
}
}
control.8 {
iface MIXER
name 'Headphone Playback Switch'
value.0 true
value.1 true
comment {
access 'read write'
type BOOLEAN
count 2
}
}
control.9 {
iface MIXER
name 'Capture Volume'
value.0 8
value.1 8
comment {
access 'read write'
type INTEGER
count 2
range '0 - 15'
dbmin 0
dbmax 2250
dbvalue.0 1200
dbvalue.1 1200
}
}
control.10 {
iface MIXER
name 'Capture Switch'
value.0 true
value.1 true
comment {
access 'read write'
type BOOLEAN
count 2
}
}
control.11 {
iface MIXER
name 'Internal Mic Capture Volume'
value.0 0
value.1 0
comment {
access 'read write'
type INTEGER
count 2
range '0 - 3'
dbmin 0
dbmax 3000
dbvalue.0 0
dbvalue.1 0
}
}
control.12 {
iface MIXER
name 'Mux Capture Volume'
value.0 0
value.1 0
comment {
access 'read write'
type INTEGER
count 2
range '0 - 3'
dbmin 0
dbmax 3000
dbvalue.0 0
dbvalue.1 0
}
}
control.13 {
iface MIXER
name 'IEC958 Playback Source'
value 'Digital Playback'
comment {
access 'read write'
type ENUMERATED
count 1
item.0 'Digital Playback'
item.1 'Analog Mux 1'
item.2 'Analog Mux 2'
}
}
control.14 {
iface MIXER
name 'IEC958 Playback Con Mask'
value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
comment {
access read
type IEC958
count 1
}
}
control.15 {
iface MIXER
name 'IEC958 Playback Pro Mask'
value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
comment {
access read
type IEC958
count 1
}
}
control.16 {
iface MIXER
name 'IEC958 Playback Default'
value '0482000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
comment {
access 'read write locked'
type IEC958
count 1
}
}
control.17 {
iface MIXER
name 'IEC958 Playback Switch'
value true
comment {
access 'read write'
type BOOLEAN
count 1
}
}
control.18 {
iface MIXER
name 'IEC958 Default PCM Playback Switch'
value true
comment {
access 'read write'
type BOOLEAN
count 1
}
}
control.19 {
iface MIXER
name 'Master Playback Volume'
value 38
comment {
access 'read write'
type INTEGER
count 1
range '0 - 64'
dbmin -9999999
dbmax 0
dbvalue.0 -1950
}
}
control.20 {
iface MIXER
name 'Master Playback Switch'
value true
comment {
access 'read write'
type BOOLEAN
count 1
}
}
control.21 {
iface CARD
name 'Dock Line Out Jack'
value false
comment {
access read
type BOOLEAN
count 1
}
}
control.22 {
iface CARD
name 'Headphone Jack'
value false
comment {
access read
type BOOLEAN
count 1
}
}
control.23 {
iface CARD
name 'Speaker Phantom Jack'
value true
comment {
access read
type BOOLEAN
count 1
}
}
control.24 {
iface CARD
name 'Mic Jack'
value false
comment {
access read
type BOOLEAN
count 1
}
}
control.25 {
iface CARD
name 'Dock Mic Jack'
value false
comment {
access read
type BOOLEAN
count 1
}
}
control.26 {
iface CARD
name 'SPDIF Phantom Jack'
value true
comment {
access read
type BOOLEAN
count 1
}
}
control.27 {
iface PCM
name 'Playback Channel Map'
value.0 0
value.1 0
value.2 0
value.3 0
value.4 0
value.5 0
value.6 0
value.7 0
comment {
access read
type INTEGER
count 8
range '0 - 27'
}
}
control.28 {
iface PCM
name 'Capture Channel Map'
value.0 3
value.1 4
comment {
access read
type INTEGER
count 2
range '0 - 27'
}
}
control.29 {
iface PCM
device 1
name 'Playback Channel Map'
value.0 3
value.1 4
comment {
access read
type INTEGER
count 2
range '0 - 27'
}
}
control.30 {
iface MIXER
name 'PCM Playback Volume'
value.0 252
value.1 252
comment {
access 'read write user'
type INTEGER
count 2
range '0 - 255'
tlv '0000000100000008ffffec1400000014'
dbmin -5100
dbmax 0
dbvalue.0 -60
dbvalue.1 -60
}
}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
fuse
rfcomm
bnep
sunrpc
cpufreq_ondemand
acpi_cpufreq
mperf
ip6t_REJECT
nf_conntrack_ipv6
nf_defrag_ipv6
ip6table_filter
ip6_tables
ipv6
uinput
snd_hda_codec_idt
btusb
bluetooth
rfkill
snd_hda_intel
snd_hda_codec
snd_hwdep
snd_seq
snd_seq_device
snd_pcm
snd_timer
snd
e1000e
dell_wmi
dell_laptop
dcdbas
soundcore
snd_page_alloc
i2c_i801
joydev
sparse_keymap
microcode
sdhci_pci
firewire_ohci
sdhci
pata_acpi
firewire_core
mmc_core
crc_itu_t
yenta_socket
ata_generic
nouveau
ttm
drm_kms_helper
drm
i2c_algo_bit
i2c_core
mxm_wmi
video
wmi


!!Sysfs Files
!!-----------

/sys/class/sound/hwC0D0/init_pin_configs:
0x0a 0x0421101f
0x0b 0x04a11021
0x0c 0x40f000f0
0x0d 0x90170110
0x0e 0x23a1102e
0x0f 0x23011050
0x14 0x40f000f2
0x18 0x90a601a0
0x19 0x40f000f4
0x1e 0x014613b0
0x1f 0x40f000f6
0x20 0x40f000f7
0x27 0x40f000f0

/sys/class/sound/hwC0D0/driver_pin_configs:

/sys/class/sound/hwC0D0/user_pin_configs:

/sys/class/sound/hwC0D0/init_verbs:


!!ALSA/HDA dmesg
!!------------------

[   10.973162] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 4003FF-0FF
[   11.591202] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   11.690703] usb 3-1.3: new full-speed USB device number 5 using uhci_hcd
--
[   11.911777] usbcore: registered new interface driver btusb
[   12.259413] ALSA sound/pci/hda/hda_codec.c:4328 hda_codec: model
'auto' is selected
[   12.259420] ALSA sound/pci/hda/hda_auto_parser.c:318 autoconfig:
line_outs=1 (0xf/0x0/0x0/0x0/0x0) type:line
[   12.259423] ALSA sound/pci/hda/hda_auto_parser.c:322
speaker_outs=1 (0xd/0x0/0x0/0x0/0x0)
[   12.259425] ALSA sound/pci/hda/hda_auto_parser.c:326    hp_outs=1
(0xa/0x0/0x0/0x0/0x0)
[   12.259427] ALSA sound/pci/hda/hda_auto_parser.c:327    mono: mono_out=0x0
[   12.259429] ALSA sound/pci/hda/hda_auto_parser.c:330    dig-out=0x1e/0x0
[   12.259431] ALSA sound/pci/hda/hda_auto_parser.c:331    inputs:
[   12.259433] ALSA sound/pci/hda/hda_auto_parser.c:335      Mic=0xb
[   12.259435] ALSA sound/pci/hda/hda_auto_parser.c:335      Dock Mic=0xe
[   12.259874] ALSA sound/pci/hda/patch_sigmatel.c:3145 stac92xx:
dac_nids=1 (0x10/0x0/0x0/0x0/0x0)
[   12.265674] input: HDA Intel Dock Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   12.265771] input: HDA Intel Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   12.265834] input: HDA Intel Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   12.265896] input: HDA Intel Dock Line Out as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   14.421479] EXT4-fs (sda2): re-mounted. Opts: (null)
--
[   24.990408] Bluetooth: RFCOMM ver 1.11
[   30.671043] hda-intel: IRQ timing workaround is activated for card
#0. Suggest a bigger bdl_pos_adj.
[   48.778211] dell_wmi: Received unknown WMI event (0x11)

Let me know if I can be anymore assistance.

Gary
