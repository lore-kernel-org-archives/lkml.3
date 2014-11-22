Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaKVOVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:21:21 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:61989 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaKVOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:21:20 -0500
MIME-Version: 1.0
Date: Sat, 22 Nov 2014 15:21:18 +0100
Message-ID: <CADuOw60rKs2-5AMPQ-7Qr6_7hfEmmgWcvdLynyCgfhwHUc8S7g@mail.gmail.com>
Subject: [Intel-gfx] drm/i915: vblank wait timed out
From: Salvatore Sisinni <s.sisinni@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
It used to be ok but in the last releases of kernel packages for
Fedora of 3.16.x and 3.17.x I did notice these WARNINGs. I did not try
Vanilla Kernel so I beg your pardon and I seek help since I had
already posted an  intel_wait_for_vblank issue on fedoraforum several
weeks ago


[  101.497093] WARNING: CPU: 1 PID: 839 at
drivers/gpu/drm/i915/intel_display.c:902
intel_wait_for_vblank+0x209/0x210 [i915]()
[  101.497095] vblank wait timed out
[  101.497096] Modules linked in: rfcomm ccm ip6t_rpfilter ip6t_REJECT
xt_conntrack bnep ebtable_nat ebtable_broute bridge stp llc
ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw
ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_security iptable_raw snd_hda_codec_hdmi snd_hda_codec_idt
snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec
snd_hwdep arc4 snd_seq brcmsmac snd_seq_device snd_pcm coretemp
kvm_intel cordic brcmutil b43 mac80211 kvm cfg80211 snd_timer ssb
mmc_core hp_wmi iTCO_wdt sparse_keymap iTCO_vendor_support ppdev bcma
snd btusb bluetooth serio_raw rfkill lpc_ich shpchp mfd_core soundcore
joydev hp_accel lis3lv02d
[  101.497132]  input_polldev tpm_tis tpm acpi_cpufreq parport_pc
parport wmi binfmt_misc nfsd auth_rpcgss nfs_acl lockd sunrpc i915
i2c_algo_bit drm_kms_helper r8169 drm mii video
[  101.497144] CPU: 1 PID: 839 Comm: X Tainted: G        W
3.17.3-200.fc20.x86_64 #1
[  101.497146] Hardware name: Hewlett-Packard HP 620/1526, BIOS 68PVI
Ver. F.20 12/12/2011
[  101.497148]  0000000000000000 00000000e02b1640 ffff8800afdcfa70
ffffffff81728acc
[  101.497156]  ffff8800afdcfab8 ffff8800afdcfaa8 ffffffff81094e6d
ffff880036cb0000
[  101.497159]  0000000000071040 0000000000000920 00000000fffcf898
00000000000000aa
[  101.497162] Call Trace:
[  101.497168]  [<ffffffff81728acc>] dump_stack+0x45/0x56
[  101.497172]  [<ffffffff81094e6d>] warn_slowpath_common+0x7d/0xa0
[  101.497175]  [<ffffffff81094eec>] warn_slowpath_fmt+0x5c/0x80
[  101.497195]  [<ffffffffa00e2b6b>] ? gen4_read32+0x4b/0xc0 [i915]
[  101.497214]  [<ffffffffa00f31e9>] intel_wait_for_vblank+0x209/0x210 [i915]
[  101.497237]  [<ffffffffa012ec05>] intel_tv_detect+0x245/0x5c0 [i915]
[  101.497248]  [<ffffffffa008ab03>]
drm_helper_probe_single_connector_modes_merge_bits+0x2c3/0x3d0
[drm_kms_helper]
[  101.497255]  [<ffffffffa008ac23>]
drm_helper_probe_single_connector_modes+0x13/0x20 [drm_kms_helper]
[  101.497272]  [<ffffffffa002858f>] drm_mode_getconnector+0x3ff/0x470 [drm]
[  101.497276]  [<ffffffff810a01eb>] ? recalc_sigpending+0x1b/0x50
[  101.497287]  [<ffffffffa001ae0c>] drm_ioctl+0x1ec/0x660 [drm]
[  101.497292]  [<ffffffff81214be0>] do_vfs_ioctl+0x2e0/0x4a0
[  101.497295]  [<ffffffff81214e21>] SyS_ioctl+0x81/0xa0
[  101.497299]  [<ffffffff81730447>] ? int_check_syscall_exit_work+0x34/0x3d
[  101.497301]  [<ffffffff817301a9>] system_call_fastpath+0x16/0x1b
[  101.497303] ---[ end trace 924e4cdb7d4fcb75 ]---
