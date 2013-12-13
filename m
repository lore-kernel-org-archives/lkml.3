Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3LMQHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:07:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab3LMQHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:07:12 -0500
Date: Fri, 13 Dec 2013 10:09:59 -0500
From: Dave Jones <davej@redhat.com>
To: daniel.vetter@ffwll.ch
Cc: intel-gfx@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 'power well on' trace in Linus current tree.
Message-ID: <20131213150959.GA28763@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, daniel.vetter@ffwll.ch,
	intel-gfx@lists.freedesktop.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I left this on overnight, and this morning this was in the log.

	Dave

WARNING: CPU: 1 PID: 131 at drivers/gpu/drm/i915/intel_display.c:6309 hsw_enable_pc8_work+0x6a9/0x6d0()
Power well on
Modules linked in: tun hidp bnep rfcomm can_raw can_bcm caif_socket caif phonet af_rxrpc bluetooth can llc2 pppoe pppox ppp_generic slhc af_key rose netrom snd_seq_dummy ipt_ULOG nfnetlink nfc af_802154 irda crc_ccitt rds scsi_transport_iscsi x25 atm appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_hdmi xfs snd_hda_codec_realtek snd_hda_intel snd_hda_codec coretemp snd_hwdep hwmon snd_seq snd_seq_device x86_pkg_temp_thermal snd_pcm libcrc32c snd_page_alloc e1000e snd_timer snd kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel shpchp serio_raw pcspkr ptp usb_debug soundcore microcode pps_core
CPU: 1 PID: 131 Comm: kworker/1:2 Not tainted 3.13.0-rc3+ #3
Workqueue: events hsw_enable_pc8_work
 ffffffff81a98b80 ffff88023d185c98 ffffffff8174cfd8 ffff88023d185ce0
 ffff88023d185cd0 ffffffff8105414d ffff88023e28d5f8 ffff88023e288000
 ffff88024155ef50 ffff88024155ef58 0000000000000080 ffff88023d185d30
Call Trace:
 [<ffffffff8174cfd8>] dump_stack+0x4e/0x7a
 [<ffffffff8105414d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff810541bc>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff81493339>] hsw_enable_pc8_work+0x6a9/0x6d0
 [<ffffffff81076611>] process_one_work+0x211/0x6f0
 [<ffffffff810765a5>] ? process_one_work+0x1a5/0x6f0
 [<ffffffff81076c0b>] worker_thread+0x11b/0x3a0
 [<ffffffff81076af0>] ? process_one_work+0x6f0/0x6f0
 [<ffffffff8107f55f>] kthread+0xff/0x120
 [<ffffffff8107f460>] ? insert_kthread_work+0x80/0x80
 [<ffffffff817608ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107f460>] ? insert_kthread_work+0x80/0x80
---[ end trace 23d69c0f014b7eb8 ]---


00:02.0 8086:0412 VGA compatible controller: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor Integrated Graphics Controller (rev 06)

