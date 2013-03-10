Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3CJLiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:38:18 -0400
Received: from www17.your-server.de ([213.133.104.17]:34681 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3CJLiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:38:17 -0400
Message-ID: <1362915489.1220.8.camel@localhost.localdomain>
Subject: WARNING: at drivers/tty/tty_buffer.c:428 flush_to_ldisc
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Mar 2013 12:38:09 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[25693.253108] ------------[ cut here ]------------
[25693.253117] WARNING: at drivers/tty/tty_buffer.c:428 flush_to_ldisc+0x162/0x170()
[25693.253118] Hardware name: Aspire 1810T
[25693.253119] tty is NULL
[25693.253148] Modules linked in: fuse ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables btusb bluetooth acer_wmi sparse_keymap snd_hda_codec_hdmi snd_hda_codec_realtek snd_usb_audio snd_usbmidi_lib acerhdf snd_hda_intel snd_hda_codec snd_hwdep snd_seq acpi_cpufreq mperf freq_table snd_pcm udlfb syscopyarea sysfillrect joydev sysimgblt snd_rawmidi fb_sys_fops snd_seq_device pcspkr asix usbnet arc4 iwldvm mac80211 ipv6 iwlwifi snd_page_alloc snd_timer cfg80211 rfkill atl1c snd soundcore wmi kvm_intel kvm
[25693.253151] Pid: 8266, comm: kworker/0:2 Not tainted 3.9.0-rc1+ #24
[25693.253152] Call Trace:
[25693.253157]  [<ffffffff81032e4a>] warn_slowpath_common+0x7a/0xc0
[25693.253160]  [<ffffffff81032f31>] warn_slowpath_fmt+0x41/0x50
[25693.253163]  [<ffffffff810348e2>] ? console_unlock+0x252/0x380
[25693.253166]  [<ffffffff812b2cf2>] flush_to_ldisc+0x162/0x170
[25693.253170]  [<ffffffff810484b7>] process_one_work+0x147/0x3a0
[25693.253173]  [<ffffffff81049fa0>] worker_thread+0x110/0x350
[25693.253175]  [<ffffffff81049e90>] ? busy_worker_rebind_fn+0xa0/0xa0
[25693.253178]  [<ffffffff8104e57a>] kthread+0xba/0xc0
[25693.253181]  [<ffffffff8104e4c0>] ? kthread_create_on_node+0x110/0x110
[25693.253186]  [<ffffffff81519d6a>] ret_from_fork+0x7a/0xb0
[25693.253188]  [<ffffffff8104e4c0>] ? kthread_create_on_node+0x110/0x110
[25693.253190] ---[ end trace 2d19715e8b176a09 ]---

