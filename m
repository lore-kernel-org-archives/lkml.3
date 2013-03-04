Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3CDS5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:57:38 -0500
Received: from a194-210.smtp-out.amazonses.com ([199.255.194.210]:28813 "EHLO
	a194-210.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758210Ab3CDS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:57:36 -0500
Date: Mon, 4 Mar 2013 18:57:34 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: linux-kernel@vger.kernel.org
cc: bskeggs@redhat.com
Subject: 3.9-rc1 lockup with nouveau driver
Message-ID: <0000013d36c41ab6-83158275-c947-4508-b359-d7a69ef517b9-000000@email.amazonses.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    3.199957] Bluetooth: BNEP socket layer initialized
[    3.204441] type=1400 audit(1362422678.075:2): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=754 comm="apparmor_parser"
[    3.204671] type=1400 audit(1362422678.075:3): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=754 comm="apparmor_parser"
[    3.230111] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x10
[    3.244196] hidraw: raw HID events driver (C) Jiri Kosina
[    3.244308] [drm] Initialized drm 1.1.0 20060810
[    3.259999] usbcore: registered new interface driver usbhid
[    3.260001] usbhid: USB HID core driver
[    3.264506] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0c3c00a1
[    3.264509] nouveau  [  DEVICE][0000:01:00.0] Chipset: GF106 (NVC3)
[    3.264510] nouveau  [  DEVICE][0000:01:00.0] Family : NVC0
[    3.266862] type=1400 audit(1362422678.139:4): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=808 comm="apparmor_parser"
[    3.266988] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[    3.267058] type=1400 audit(1362422678.139:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=808 comm="apparmor_parser"
[    3.267171] type=1400 audit(1362422678.139:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=808 comm="apparmor_parser"
[    3.270787] type=1400 audit(1362422678.143:7): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=811 comm="apparmor_parser"
[    3.320219] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    3.320221] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
[    3.320282] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    3.320283] nouveau  [   VBIOS][0000:01:00.0] version 70.06.41.00.02
[    3.405441] device-mapper: multipath: version 1.5.1 loaded
[    3.460952] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.471075] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x10
[    3.474683] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x10
[    3.477180] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x10
[    3.485336] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x10
[    3.491085] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x10
[    3.492122] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1:1.0/input/input2
[    3.493322] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x10
[    3.494272] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x10
[    3.498223] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    3.498544] hid-generic 0003:046D:C077.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1.1/input0
[    3.500601] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.508952] hda_codec: ALC269VB: SKU not ready 0x411111f0
[    3.516239] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[    3.516624] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    3.516751] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    3.516889] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    3.518090] input: DELL Dell USB Entry Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input3
[    3.519422] hid-generic 0003:413C:2107.0002: input,hidraw1: USB HID v1.10 Keyboard [DELL Dell USB Entry Keyboard] on usb-0000:00:1a.0-1.2/input0
[    3.520110] input: Logitech G500 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input8
[    3.520589] hid-generic 0003:046D:C068.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech G500] on usb-0000:00:1d.0-1.6/input0
[    3.522744] input: Logitech G500 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/input/input9
[    3.523335] hid-generic 0003:046D:C068.0004: input,hiddev0,hidraw3: USB HID v1.11 Keyboard [Logitech G500] on usb-0000:00:1d.0-1.6/input1
[    3.556682] nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
[    3.556684] nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
[    3.556685] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[    4.838617] nouveau  [  PTHERM][0000:01:00.0] FAN control: PWM
[    4.838631] nouveau  [  PTHERM][0000:01:00.0] Thermal management: disabled
[    4.838643] nouveau  [  PTHERM][0000:01:00.0] programmed thresholds [ 90(3), 95(3), 105(5), 135(5) ]
[    4.841505] [TTM] Zone  kernel: Available graphics memory: 16449824 kiB
[    4.841506] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.841507] [TTM] Initializing pool allocator
[    4.841509] [TTM] Initializing DMA pool allocator
[    4.845874] nouveau  [     DRM] VRAM: 1024 MiB
[    4.845876] nouveau  [     DRM] GART: 512 MiB
[    4.845888] nouveau  [     DRM] TMDS table version 2.0
[    4.845889] nouveau  [     DRM] DCB version 4.0
[    4.845899] nouveau  [     DRM] DCB outp 00: 02000300 00000000
[    4.845900] nouveau  [     DRM] DCB outp 01: 01000302 00020030
[    4.845901] nouveau  [     DRM] DCB outp 02: 048113b6 0f220010
[    4.845902] nouveau  [     DRM] DCB outp 03: 04011372 00020010
[    4.845903] nouveau  [     DRM] DCB outp 04: 028223a6 0f220010
[    4.845904] nouveau  [     DRM] DCB outp 05: 02022362 00020010
[    4.845905] nouveau  [     DRM] DCB conn 00: 00001030
[    4.845906] nouveau  [     DRM] DCB conn 01: 00820146
[    4.845907] nouveau  [     DRM] DCB conn 02: 00410246
[    4.846673] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.846674] [drm] No driver support for vblank timestamp query.
[    4.846835] nouveau  [     DRM] 3 available performance level(s)
[    4.846837] nouveau  [     DRM] 0: core 50MHz shader 101MHz memory 135MHz voltage 850mV
[    4.846839] nouveau  [     DRM] 1: core 405MHz shader 810MHz memory 324MHz voltage 862mV-887mV
[    4.846840] nouveau  [     DRM] 3: core 625MHz shader 1251MHz memory 1304MHz voltage 862mV-975mV
[    4.846841] nouveau  [     DRM] c: core 405MHz shader 810MHz memory 324MHz voltage 912mV fanspeed 30%
[    4.850288] nouveau  [     DRM] MM: using COPY1 for buffer copies
[    4.996702] nouveau  [     DRM] allocated 2560x1600 fb: 0x60000, bo ffff8807f7184800
[    4.996808] fbcon: nouveaufb (fb0) is primary device
[    5.111023] Console: switching to colour frame buffer device 320x100
[    5.116019] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    5.116020] nouveau 0000:01:00.0: registered panic notifier
[    5.116023] [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 0
[    5.116147] hda_intel: Disabling MSI
[    5.116169] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    5.139054] init: plymouth-splash main process (1162) terminated with status 1
[    5.917224] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input10
[    5.917301] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input11
[    5.917366] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
[    5.917444] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
[    5.970025] Bridge firewalling registered
[    5.971173] device eth0 entered promiscuous mode
[    6.104187] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.204816] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.204885] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.206913] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
[    9.259268] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[    9.259302] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    9.259320] br0: port 1(eth0) entered forwarding state
[    9.259327] br0: port 1(eth0) entered forwarding state
[    9.259423] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[    9.460475] init: failsafe main process (1135) killed by TERM signal
[    9.491719] type=1400 audit(1362422684.368:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/libvirt/virt-aa-helper" pid=1565 comm="apparmor_parser"
[    9.491914] type=1400 audit(1362422684.368:9): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1562 comm="apparmor_parser"
[    9.492193] type=1400 audit(1362422684.372:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1562 comm="apparmor_parser"
[    9.492909] type=1400 audit(1362422684.372:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1559 comm="apparmor_parser"
[    9.493068] type=1400 audit(1362422684.372:12): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper//chromium_browser" pid=1559 comm="apparmor_parser"
[    9.494354] type=1400 audit(1362422684.372:13): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=1566 comm="apparmor_parser"
[    9.494602] type=1400 audit(1362422684.372:14): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=1566 comm="apparmor_parser"
[    9.495018] type=1400 audit(1362422684.372:15): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*//sanitized_helper" pid=1566 comm="apparmor_parser"
[    9.496559] type=1400 audit(1362422684.376:16): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1562 comm="apparmor_parser"
[    9.497315] type=1400 audit(1362422684.376:17): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=1567 comm="apparmor_parser"
[    9.555145] init: alsa-restore main process (1609) terminated with status 99
[    9.557593] init: apport pre-start process (1602) terminated with status 2
[    9.571883] init: apport post-stop process (1673) terminated with status 1
[    9.575887] init: lightdm main process (1678) killed by TERM signal
[    9.658078] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.760539] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   10.012446] Ebtables v2.0 registered
[   10.032737] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   10.060750] cgroup: libvirtd (1753) created nested cgroup for controller "devices" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   10.060776] cgroup: libvirtd (1753) created nested cgroup for controller "blkio" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   18.247848] br0: port 1(eth0) entered forwarding state
[  188.072656] nouveau W[   PFIFO][0000:01:00.0] INTR 0x00000001: 0x00000004
[  188.935129] nouveau W[   PFIFO][0000:01:00.0] INTR 0x00000001: 0x00000004
[  197.700977] nouveau E[     DRM] GPU lockup - switching to software fbcon
[  200.712211] nouveau E[Xorg[1735]] failed to idle channel 0xcccc0001 [Xorg[1735]]
[  203.712011] nouveau E[Xorg[1735]] failed to idle channel 0xcccc0000 [Xorg[1735]]
[  203.726646] nouveau W[   PFIFO][0000:01:00.0] INTR 0x00000001: 0x00000004

