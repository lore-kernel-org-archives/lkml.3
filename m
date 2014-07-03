Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbaGCP0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:26:32 -0400
Received: from pindarots.xs4all.nl ([82.161.210.87]:53840 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836AbaGCP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:26:30 -0400
Message-ID: <53B57623.40905@xs4all.nl>
Date: Thu, 03 Jul 2014 17:26:27 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.15.1 WARNING
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What went wrong here?

Please let me know!


Kind regards,
Udo

Jun 29 06:59:20 surfplank2 kernel: [ 5263.255573] ------------[ cut here
]------------
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255587] WARNING: CPU: 2 PID:
10113 at drivers/media/v4l2-core/videobuf2-core.c:2011
__vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255589] Modules linked in:
bnep bluetooth fuse edac_core cpufreq_userspace nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_REJECT ipt_REJECT xt_tcpudp iptable_fi
lter nf_conntrack_ipv6 nf_defrag_ipv6 ipt_MASQUERADE iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack
nf_conntrack ip6table_filter ip6_tables ip_tables x_tables eeprom it87
hwmon_
vid ext2 ppdev kvm_amd kvm microcode parport_serial evdev parport_pc
k10temp snd_usb_audio parport snd_usbmidi_lib snd_hwdep snd_rawmidi pwc
videobuf2_vmalloc videobuf2_memops v4l2_common cp210x videobuf2_co
re videodev usbserial cdc_acm snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
snd_seq snd_seq_device snd_pcm snd_timer snd i2c_piix4 button
acpi_cpufreq nfsd auth_r
pcgss oid_registry nfs_acl lockd binfmt_misc sunrpc autofs4 hid_generic
usbhid radeon sr_mod cdrom fbcon bitblit softcursor font cfbfillrect
cfbimgblt cfbcopyarea i2c_algo_bit backlight drm_kms_helper ttm oh
ci_pci ohci_hcd ehci_pci ehci_hcd xhci_hcd drm fb fbdev
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255639] CPU: 2 PID: 10113
Comm: skype Not tainted 3.15.1 #1
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255641] Hardware name:
Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS
F5a 04/30/2013
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255643]  0000000000000000
00000000c320517b ffffffff814f1fb9 0000000000000000
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255646]  ffffffff8106a081
0000000000000000 0000000040045613 ffff88042595cd00
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255649]  ffff88042e170300
ffff88041cfd3c48 ffffffffa03c8832 ffff88042e170000
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255651] Call Trace:
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255657]  [<ffffffff814f1fb9>]
? dump_stack+0x4a/0x75
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255661]  [<ffffffff8106a081>]
? warn_slowpath_common+0x81/0xb0
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255665]  [<ffffffffa03c8832>]
? __vb2_queue_cancel+0x102/0x170 [videobuf2_core]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255669]  [<ffffffffa03ca53d>]
? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255674]  [<ffffffffa0461163>]
? __video_do_ioctl+0x2f3/0x380 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255680]  [<ffffffffa0460bc0>]
? video_usercopy+0x1f0/0x490 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255684]  [<ffffffffa0460e70>]
? video_ioctl2+0x10/0x10 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255687]  [<ffffffff810c0052>]
? futex_wait_queue_me+0xe2/0x150
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255692]  [<ffffffffa045c7df>]
? v4l2_ioctl+0x11f/0x160 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255696]  [<ffffffffa046a7c6>]
? do_video_ioctl+0x246/0x1340 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255698]  [<ffffffff810c0c4c>]
? futex_wake+0x7c/0x160
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255701]  [<ffffffff810c290c>]
? do_futex+0x12c/0xb00
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255705]  [<ffffffffa046b942>]
? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255708]  [<ffffffff81185f52>]
? compat_SyS_ioctl+0x132/0x1130
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255711]  [<ffffffff810b5ead>]
? ktime_get_ts+0x3d/0xd0
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255713]  [<ffffffff81085b98>]
? posix_ktime_get_ts+0x8/0x10
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255716]  [<ffffffff81086a50>]
? SyS_clock_gettime+0x60/0x80
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255719]  [<ffffffff814f93c5>]
? cstar_dispatch+0x7/0x1a
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255721] ---[ end trace
57668a8b26e05662 ]---
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255722] ------------[ cut here
]------------
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255726] WARNING: CPU: 2 PID:
10113 at drivers/media/v4l2-core/videobuf2-core.c:1095
vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255727] Modules linked in:
bnep bluetooth fuse edac_core cpufreq_userspace nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_REJECT ipt_REJECT xt_tcpudp iptable_fi
lter nf_conntrack_ipv6 nf_defrag_ipv6 ipt_MASQUERADE iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack
nf_conntrack ip6table_filter ip6_tables ip_tables x_tables eeprom it87
hwmon_
vid ext2 ppdev kvm_amd kvm microcode parport_serial evdev parport_pc
k10temp snd_usb_audio parport snd_usbmidi_lib snd_hwdep snd_rawmidi pwc
videobuf2_vmalloc videobuf2_memops v4l2_common cp210x videobuf2_co
re videodev usbserial cdc_acm snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
snd_seq snd_seq_device snd_pcm snd_timer snd i2c_piix4 button
acpi_cpufreq nfsd auth_r
pcgss oid_registry nfs_acl lockd binfmt_misc sunrpc autofs4 hid_generic
usbhid radeon sr_mod cdrom fbcon bitblit softcursor font cfbfillrect
cfbimgblt cfbcopyarea i2c_algo_bit backlight drm_kms_helper ttm oh
ci_pci ohci_hcd ehci_pci ehci_hcd xhci_hcd drm fb fbdev
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255770] CPU: 2 PID: 10113
Comm: skype Tainted: G        W     3.15.1 #1
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255772] Hardware name:
Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS
F5a 04/30/2013
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255773]  0000000000000000
00000000c320517b ffffffff814f1fb9 0000000000000000
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255775]  ffffffff8106a081
0000000000000000 ffff8800882cf400 ffff88042e170300
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255778]  0000000000000003
ffff88041cfd3c48 ffffffffa03c80af 0000000000000000
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255781] Call Trace:
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255783]  [<ffffffff814f1fb9>]
? dump_stack+0x4a/0x75
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255786]  [<ffffffff8106a081>]
? warn_slowpath_common+0x81/0xb0
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255790]  [<ffffffffa03c80af>]
? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255793]  [<ffffffffa03c886e>]
? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255797]  [<ffffffffa03ca53d>]
? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255801]  [<ffffffffa0461163>]
? __video_do_ioctl+0x2f3/0x380 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255806]  [<ffffffffa0460bc0>]
? video_usercopy+0x1f0/0x490 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255810]  [<ffffffffa0460e70>]
? video_ioctl2+0x10/0x10 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255813]  [<ffffffff810c0052>]
? futex_wait_queue_me+0xe2/0x150
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255817]  [<ffffffffa045c7df>]
? v4l2_ioctl+0x11f/0x160 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255821]  [<ffffffffa046a7c6>]
? do_video_ioctl+0x246/0x1340 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255823]  [<ffffffff810c0c4c>]
? futex_wake+0x7c/0x160
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255826]  [<ffffffff810c290c>]
? do_futex+0x12c/0xb00
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255830]  [<ffffffffa046b942>]
? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255832]  [<ffffffff81185f52>]
? compat_SyS_ioctl+0x132/0x1130
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255834]  [<ffffffff810b5ead>]
? ktime_get_ts+0x3d/0xd0
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255837]  [<ffffffff81085b98>]
? posix_ktime_get_ts+0x8/0x10
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255839]  [<ffffffff81086a50>]
? SyS_clock_gettime+0x60/0x80
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255841]  [<ffffffff814f93c5>]
? cstar_dispatch+0x7/0x1a
Jun 29 06:59:20 surfplank2 kernel: [ 5263.255843] ---[ end trace
57668a8b26e05663 ]---
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584760] ------------[ cut here
]------------
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584774] WARNING: CPU: 1 PID:
10113 at drivers/media/v4l2-core/videobuf2-core.c:2011
__vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584776] Modules linked in:
bnep bluetooth fuse edac_core cpufreq_userspace nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_REJECT ipt_REJECT xt_tcpudp iptable_filter
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_MASQUERADE iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack
nf_conntrack ip6table_filter ip6_tables ip_tables x_tables eeprom it87
hwmon_vid ext2 ppdev kvm_amd kvm microcode parport_serial evdev
parport_pc k10temp snd_usb_audio parport snd_usbmidi_lib snd_hwdep
snd_rawmidi pwc videobuf2_vmalloc videobuf2_memops v4l2_common cp210x
videobuf2_core videodev usbserial cdc_acm snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
snd_seq snd_seq_device snd_pcm snd_timer snd i2c_piix4 button
acpi_cpufreq nfsd auth_rpcgss oid_registry nfs_acl lockd binfmt_misc
sunrpc autofs4 hid_generic usbhid radeon sr_mod cdrom fbcon bitblit
softcursor font cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit backlight
drm_kms_helper ttm ohci_pci ohci_hcd ehci_pci ehci_hcd xhci_hcd drm fb fbdev
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584822] CPU: 1 PID: 10113
Comm: skype Tainted: G        W     3.15.1 #1
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584824] Hardware name:
Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS
F5a 04/30/2013
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584826]  0000000000000000
00000000c320517b ffffffff814f1fb9 0000000000000000
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584828]  ffffffff8106a081
0000000000000000 0000000040045613 ffff88041a42ca00
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584831]  ffff88042e170300
ffff88041cfd3c48 ffffffffa03c8832 ffff88042e170000
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584834] Call Trace:
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584841]  [<ffffffff814f1fb9>]
? dump_stack+0x4a/0x75
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584845]  [<ffffffff8106a081>]
? warn_slowpath_common+0x81/0xb0
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584849]  [<ffffffffa03c8832>]
? __vb2_queue_cancel+0x102/0x170 [videobuf2_core]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584852]  [<ffffffffa03ca53d>]
? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584857]  [<ffffffffa0461163>]
? __video_do_ioctl+0x2f3/0x380 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584863]  [<ffffffffa0460bc0>]
? video_usercopy+0x1f0/0x490 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584867]  [<ffffffffa0460e70>]
? video_ioctl2+0x10/0x10 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584870]  [<ffffffff810c0052>]
? futex_wait_queue_me+0xe2/0x150
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584875]  [<ffffffffa045c7df>]
? v4l2_ioctl+0x11f/0x160 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584879]  [<ffffffffa046a7c6>]
? do_video_ioctl+0x246/0x1340 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584882]  [<ffffffff810c0c4c>]
? futex_wake+0x7c/0x160
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584884]  [<ffffffff810c290c>]
? do_futex+0x12c/0xb00
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584888]  [<ffffffffa046b942>]
? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584892]  [<ffffffff81185f52>]
? compat_SyS_ioctl+0x132/0x1130
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584894]  [<ffffffff810b5ead>]
? ktime_get_ts+0x3d/0xd0
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584897]  [<ffffffff81085b98>]
? posix_ktime_get_ts+0x8/0x10
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584899]  [<ffffffff81086a50>]
? SyS_clock_gettime+0x60/0x80
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584903]  [<ffffffff814f93c5>]
? cstar_dispatch+0x7/0x1a
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584904] ---[ end trace
57668a8b26e05664 ]---
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584906] ------------[ cut here
]------------
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584909] WARNING: CPU: 1 PID:
10113 at drivers/media/v4l2-core/videobuf2-core.c:1095
vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584911] Modules linked in:
bnep bluetooth fuse edac_core cpufreq_userspace nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_REJECT ipt_REJECT xt_tcpudp iptable_filter
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_MASQUERADE iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_conntrack
nf_conntrack ip6table_filter ip6_tables ip_tables x_tables eeprom it87
hwmon_vid ext2 ppdev kvm_amd kvm microcode parport_serial evdev
parport_pc k10temp snd_usb_audio parport snd_usbmidi_lib snd_hwdep
snd_rawmidi pwc videobuf2_vmalloc videobuf2_memops v4l2_common cp210x
videobuf2_core videodev usbserial cdc_acm snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
snd_seq snd_seq_device snd_pcm snd_timer snd i2c_piix4 button
acpi_cpufreq nfsd auth_rpcgss oid_registry nfs_acl lockd binfmt_misc
sunrpc autofs4 hid_generic usbhid radeon sr_mod cdrom fbcon bitblit
softcursor font cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit backlight
drm_kms_helper ttm ohci_pci ohci_hcd ehci_pci ehci_hcd xhci_hcd drm fb fbdev
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584951] CPU: 1 PID: 10113
Comm: skype Tainted: G        W     3.15.1 #1
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584952] Hardware name:
Gigabyte Technology Co., Ltd. To be filled by O.E.M./F2A85X-UP4, BIOS
F5a 04/30/2013
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584953]  0000000000000000
00000000c320517b ffffffff814f1fb9 0000000000000000
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584955]  ffffffff8106a081
0000000000000000 ffff8804182c6000 ffff88042e170300
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584958]  0000000000000003
ffff88041cfd3c48 ffffffffa03c80af 0000000000000000
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584960] Call Trace:
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584962]  [<ffffffff814f1fb9>]
? dump_stack+0x4a/0x75
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584965]  [<ffffffff8106a081>]
? warn_slowpath_common+0x81/0xb0
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584968]  [<ffffffffa03c80af>]
? vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584972]  [<ffffffffa03c886e>]
? __vb2_queue_cancel+0x13e/0x170 [videobuf2_core]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584975]  [<ffffffffa03ca53d>]
? vb2_internal_streamoff+0x1d/0x50 [videobuf2_core]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584979]  [<ffffffffa0461163>]
? __video_do_ioctl+0x2f3/0x380 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584985]  [<ffffffffa0460bc0>]
? video_usercopy+0x1f0/0x490 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584989]  [<ffffffffa0460e70>]
? video_ioctl2+0x10/0x10 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584991]  [<ffffffff810c0052>]
? futex_wait_queue_me+0xe2/0x150
Jun 29 06:59:32 surfplank2 kernel: [ 5275.584995]  [<ffffffffa045c7df>]
? v4l2_ioctl+0x11f/0x160 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585000]  [<ffffffffa046a7c6>]
? do_video_ioctl+0x246/0x1340 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585002]  [<ffffffff810c0c4c>]
? futex_wake+0x7c/0x160
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585004]  [<ffffffff810c290c>]
? do_futex+0x12c/0xb00
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585009]  [<ffffffffa046b942>]
? v4l2_compat_ioctl32+0x82/0xb8 [videodev]
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585011]  [<ffffffff81185f52>]
? compat_SyS_ioctl+0x132/0x1130
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585013]  [<ffffffff810b5ead>]
? ktime_get_ts+0x3d/0xd0
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585015]  [<ffffffff81085b98>]
? posix_ktime_get_ts+0x8/0x10
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585018]  [<ffffffff81086a50>]
? SyS_clock_gettime+0x60/0x80
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585020]  [<ffffffff814f93c5>]
? cstar_dispatch+0x7/0x1a
Jun 29 06:59:32 surfplank2 kernel: [ 5275.585022] ---[ end trace
57668a8b26e05665 ]---
