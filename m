Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3FSTDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:03:35 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:61767 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab3FSTDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:03:33 -0400
X-AuditID: cbfec37b-b7f306d0000047de-a1-51c20083884a
From: Shuah Khan <shuah.kh@samsung.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Linux 3.10-rc6 drivers/gpu/drm/i915/intel_display warnon during suspend
Thread-topic: Linux 3.10-rc6 drivers/gpu/drm/i915/intel_display warnon during
 suspend
Thread-index: Ac5tH68+TWVZTJ2EQuSlAqUIT13q2A==
Date: Wed, 19 Jun 2013 19:03:30 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172C0FD@sisaex02sj>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9hP91mhkOBBkeXaVpc3jWHzeLrTwcH
	Jo+ds+6ye3zeJBfAFMVlk5Kak1mWWqRvl8CVcfOqecFi84qtUxayNjBON+xi5OSQEDCR6D++
	hAXCFpO4cG89WxcjF4eQwDJGiZOXLjNCOL1MEifmXmCBcOYzSvzY38cO0sImoC7x+fUOMFtE
	wFFix8GvbCA2s0CIxI3fE5lBbGGBAImzXZeYIGrCJZa+/M4CYetJtNy9AVbDIqAq0f33KlgN
	r4C9xOP5/8BmMgKd9P3UGiaImeISza03oU4VkFiy5zwzhC0q8fLxP9YuRg4gW1Fi+2oriHIt
	ifU7j0O1aks8eXeBFWK8oMSPyfdYJjCKzkIydRaSlllIWmYhaVnAyLKKUay0OLmgOCk9tcJI
	rzgxt7g0L10vOT93EyMkSqp3MN79anOIUYCDUYmHV+PywUAh1sSy4srcQ4wSHMxKIrybvwOF
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MCaYr42ena7uMyd8zdtL/W8nWzXeb1kgxvTzdkXBvnVX
	HB68/XRcv8+//uOnSRtz7k4v1FrDlbhIaMG5fJ2zoYUmNbyVdjf8+UVqlN4VbSl5XvdMbbmc
	d+TCqd13TIt3GuV0PcuXE9y7xmKDW5eBy9ZjUw+L7W5/lZ45hT1M+YSZpYXxsrsPtJRYijMS
	DbWYi4oTAQYMphVwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing the following warning during suspend/resume on 3.10-rc6. Is 
this a known issue?


[ 2375.024986] ------------[ cut here ]------------
[ 2375.025034] WARNING: at drivers/gpu/drm/i915/intel_display.c:1656 
ironlake_crtc_disable+0x865/0x890 [i915]()
[ 2375.025096] Modules linked in: bnep rfcomm parport_pc ppdev arc4 
iwldvm mac80211 ext2 i915 iwlwifi joydev coretemp uvcvideo 
snd_hda_codec_hdmi kvm_intel snd_hda_codec_realtek kvm snd_hda_intel 
videobuf2_core snd_hda_codec videodev cfg80211 media videobuf2_vmalloc 
snd_hwdep videobuf2_memops snd_pcm drm_kms_helper snd_seq_midi drm 
snd_rawmidi btusb snd_seq_midi_event snd_seq bluetooth 
ghash_clmulni_intel aesni_intel ablk_helper tpm_infineon cryptd 
snd_timer lrw snd_seq_device gf128mul glue_helper psmouse snd aes_x86_64 
microcode samsung_laptop soundcore serio_raw i2c_algo_bit snd_page_alloc 
lpc_ich tpm_tis video mac_hid lp wmi parport r8169
[ 2375.025102] CPU: 2 PID: 70 Comm: kworker/u16:5 Not tainted 
3.10.0-rc6+ #11
[ 2375.025105] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P03AAC 07/12/2012
[ 2375.025117] Workqueue: events_unbound async_run_entry_fn
[ 2375.025126]  0000000000000009 ffff8803f05aba48 ffffffff81690861 
ffff8803f05aba88
[ 2375.025130]  ffffffff81043870 ffff8803fd954000 ffff88040cede000 
ffff8803fd954000
[ 2375.025134]  ffff8803fd956688 00000000000e0300 ffff880404826800 
ffff8803f05aba98
[ 2375.025136] Call Trace:
[ 2375.025149]  [<ffffffff81690861>] dump_stack+0x19/0x1b
[ 2375.025158]  [<ffffffff81043870>] warn_slowpath_common+0x70/0xa0
[ 2375.025167]  [<ffffffff810438ba>] warn_slowpath_null+0x1a/0x20
[ 2375.025197]  [<ffffffffa0411f35>] ironlake_crtc_disable+0x865/0x890 
[i915]
[ 2375.025222]  [<ffffffffa0413408>] __intel_set_mode+0x458/0xd00 [i915]
[ 2375.025249]  [<ffffffffa041d5d9>] 
intel_modeset_setup_hw_state+0x679/0xa60 [i915]
[ 2375.025261]  [<ffffffff81693dbd>] ? mutex_lock+0x1d/0x50
[ 2375.025277]  [<ffffffffa03e8277>] __i915_drm_thaw+0x137/0x1d0 [i915]
[ 2375.025293]  [<ffffffffa03e85cb>] i915_resume+0x7b/0xd0 [i915]
[ 2375.025310]  [<ffffffffa03e8636>] i915_pm_resume+0x16/0x20 [i915]
[ 2375.025317]  [<ffffffff81355173>] pci_pm_restore+0x73/0xd0
[ 2375.025324]  [<ffffffff81355100>] ? pci_pm_default_resume+0x50/0x50
[ 2375.025330]  [<ffffffff81355100>] ? pci_pm_default_resume+0x50/0x50
[ 2375.025339]  [<ffffffff81424ca5>] dpm_run_callback.isra.3+0x45/0x80
[ 2375.025345]  [<ffffffff8142565b>] device_resume+0xdb/0x200
[ 2375.025351]  [<ffffffff814257a1>] async_resume+0x21/0x50
[ 2375.025359]  [<ffffffff8107000b>] async_run_entry_fn+0x3b/0x140
[ 2375.025367]  [<ffffffff8106269e>] process_one_work+0x16e/0x3f0
[ 2375.025374]  [<ffffffff81062db2>] worker_thread+0x122/0x370
[ 2375.025382]  [<ffffffff81062c90>] ? rescuer_thread+0x330/0x330
[ 2375.025389]  [<ffffffff810695d0>] kthread+0xc0/0xd0
[ 2375.025397]  [<ffffffff81069510>] ? kthread_create_on_node+0x130/0x130
[ 2375.025404]  [<ffffffff8169f51c>] ret_from_fork+0x7c/0xb0
[ 2375.025411]  [<ffffffff81069510>] ? kthread_create_on_node+0x130/0x130
[ 2375.025415] ---[ end trace e597428d95220943 ]---

[ 2375.025440] WARNING: at drivers/gpu/drm/i915/intel_display.c:1091 
assert_pch_pll+0x18f/0x1f0 [i915]()
[ 2375.025444] PCH PLL state for reg c6014 assertion failure (expected 
off, current on), val=89086008
[ 2375.025494] Modules linked in: bnep rfcomm parport_pc ppdev arc4 
iwldvm mac80211 ext2 i915 iwlwifi joydev coretemp uvcvideo 
snd_hda_codec_hdmi kvm_intel snd_hda_codec_realtek kvm snd_hda_intel 
videobuf2_core snd_hda_codec videodev cfg80211 media videobuf2_vmalloc 
snd_hwdep videobuf2_memops snd_pcm drm_kms_helper snd_seq_midi drm 
snd_rawmidi btusb snd_seq_midi_event snd_seq bluetooth 
ghash_clmulni_intel aesni_intel ablk_helper tpm_infineon cryptd 
snd_timer lrw snd_seq_device gf128mul glue_helper psmouse snd aes_x86_64 
microcode samsung_laptop soundcore serio_raw i2c_algo_bit snd_page_alloc 
lpc_ich tpm_tis video mac_hid lp wmi parport r8169
[ 2375.025499] CPU: 2 PID: 70 Comm: kworker/u16:5 Tainted: G        W 
  3.10.0-rc6+ #11
[ 2375.025501] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 
900X3C/900X3D/900X4C/900X4D/SAMSUNG_NP1234567890, BIOS P03AAC 07/12/2012
[ 2375.025510] Workqueue: events_unbound async_run_entry_fn
[ 2375.025515]  0000000000000009 ffff8803f05ab9a8 ffffffff81690861 
ffff8803f05ab9e8
[ 2375.025519]  ffffffff81043870 0000000000000009 ffff8803fd954000 
ffff8803fd956688
[ 2375.025523]  0000000000000000 0000000000000000 0000000089086008 
ffff8803f05aba48
[ 2375.025524] Call Trace:
[ 2375.025531]  [<ffffffff81690861>] dump_stack+0x19/0x1b
[ 2375.025539]  [<ffffffff81043870>] warn_slowpath_common+0x70/0xa0
[ 2375.025546]  [<ffffffff81043956>] warn_slowpath_fmt+0x46/0x50
[ 2375.025568]  [<ffffffffa040d36f>] assert_pch_pll+0x18f/0x1f0 [i915]
[ 2375.025590]  [<ffffffffa0411c79>] ironlake_crtc_disable+0x5a9/0x890 
[i915]
[ 2375.025610]  [<ffffffffa0413408>] __intel_set_mode+0x458/0xd00 [i915]
[ 2375.025635]  [<ffffffffa041d5d9>] 
intel_modeset_setup_hw_state+0x679/0xa60 [i915]
[ 2375.025645]  [<ffffffff81693dbd>] ? mutex_lock+0x1d/0x50
[ 2375.025660]  [<ffffffffa03e8277>] __i915_drm_thaw+0x137/0x1d0 [i915]
[ 2375.025676]  [<ffffffffa03e85cb>] i915_resume+0x7b/0xd0 [i915]
[ 2375.025693]  [<ffffffffa03e8636>] i915_pm_resume+0x16/0x20 [i915]
[ 2375.025698]  [<ffffffff81355173>] pci_pm_restore+0x73/0xd0
[ 2375.025705]  [<ffffffff81355100>] ? pci_pm_default_resume+0x50/0x50
[ 2375.025712]  [<ffffffff81355100>] ? pci_pm_default_resume+0x50/0x50
[ 2375.025718]  [<ffffffff81424ca5>] dpm_run_callback.isra.3+0x45/0x80
[ 2375.025725]  [<ffffffff8142565b>] device_resume+0xdb/0x200
[ 2375.025731]  [<ffffffff814257a1>] async_resume+0x21/0x50
[ 2375.025741]  [<ffffffff8107000b>] async_run_entry_fn+0x3b/0x140
[ 2375.025748]  [<ffffffff8106269e>] process_one_work+0x16e/0x3f0
[ 2375.025756]  [<ffffffff81062db2>] worker_thread+0x122/0x370
[ 2375.025764]  [<ffffffff81062c90>] ? rescuer_thread+0x330/0x330
[ 2375.025770]  [<ffffffff810695d0>] kthread+0xc0/0xd0
[ 2375.025778]  [<ffffffff81069510>] ? kthread_create_on_node+0x130/0x130
[ 2375.025784]  [<ffffffff8169f51c>] ret_from_fork+0x7c/0xb0
[ 2375.025791]  [<ffffffff81069510>] ? kthread_create_on_node+0x130/0x130
[ 2375.025794] ---[ end trace e597428d95220944 ]---

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
