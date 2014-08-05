Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbaHEJ6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 05:58:48 -0400
Received: from mx3.wp.pl ([212.77.101.9]:11973 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbaHEJ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 05:58:45 -0400
Date: Tue, 5 Aug 2014 11:58:34 +0200
From: Janek Kozicki <janek_listy@wp.pl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: markus@gutschke.com, Pavel Machek <pavel@ucw.cz>,
        Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: 3.16 crashes on resume from Suspend-To-disk
Message-ID: <20140805115834.5e5e76f0@absurd>
In-Reply-To: <11544482.e7kpiLjKfi@vostro.rjw.lan>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	<20140804141613.GB24261@amd.pavel.ucw.cz>
	<CALGCz1oG2g-UsK7FnxRRj7R5n6yxwJey0EBcP8ctRYSGjfw==Q@mail.gmail.com>
	<11544482.e7kpiLjKfi@vostro.rjw.lan>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: $rkfae+2_DGd"-<Fvf,vE7&hL?oJC.uN!6/loh7NMwb/Cs*h!wXg0^+WL;VPwQ0]e0\sPi~63[g*K.:C@jj9zV:L^0&vNyT+aq.9L.0V'8yV%Q/PzmqW{8{/P`>BPR=BhRod2pTifbsp+}LY@O++;u~RqNMBFJgn?R{QHO^@4;?(l5x002ZHJ$zZd~:,H{5E&LV]7X9\7Bw*fl
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAALVBMVEUBAQEtLS1KSkpRUVFXV1dYWFhjY2Nzc3N3d3eHh4eKioqdnZ24uLjLy8vc3NxVIagyAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH2AIVEzgS1fgQtQAAAjRJREFUOMtt1DFv00AUAOAzFQNbjigSyoQaRaBMhKgLUyKXpVNNeUpk9vyDqFJhQ1kiBuaqAwJCqvPtSLY7RlTn5+5IdnYkkt/AOyfxXVLe5vf53Z1875kd34tOEax8djmj6GyjhB5bxz50GdsVZr9fqRjZwAtKOJw5Wqs2MMZ16ALHsaDncF7xAHix1oEFHAB8f+pRjcO4gfZDykcYzbiucRolOLUJ6kjA0xtVt+A6TySlM0RajIpK6DzwKZ/nOYbF/gclHMo1ZOHYY/+Ha+AWuM+3oMS4eeqYzZ8FiCltgUqI8cd2wwAVpJk+8LWYjBtnJdQpHQqJMd4Oxt4bU9ESiFGc5hkqaH74asAX4iabP5I5gZ+qjgGlJCqZa3h3lxhoeVcSE1qLQC4sqKOK9MGW9E3izFqqHokoztLFEgXg31sbZEKnWi2T74A4NxfVQqlkjKtcAWD+zcArFEES01dR0E/nnV0IgugmDd/2L84sOAouRBBHEc7gtc8teDkRlE0iNQPo2w3Xhh/D4TCIQ4LRLoTvgwjj6RRgavdurxYGMaIuGOyAW/PpNlCcU9/93AHenAWYjPoAwa+G3e3to/MgFNTAEKvKDjzuCzHTnY3qqdXtx24VijzQfZ0yewZ5cwRFQaa+mIYr1uI0I76+3W4xhlvoVRwOA0Fdl64HlJnxP6T8YpX/Lga4Wv4A3ErrU5oTfN7Mu/llXMl8RXEPji/lQkN3H7qXqgC2By47EXeU/7PJ/wPxRKMnuZwIeAAAAABJRU5ErkJggg==
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/O0stk35F2QS.rKItn4FCRpp"
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [MUA1]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/O0stk35F2QS.rKItn4FCRpp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Rafael J. Wysocki said:     (by the date of Tue, 05 Aug 2014 03:30:58 +0200)

> On Monday, August 04, 2014 09:06:52 AM Markus Gutschke wrote:
> > Thanks for checking in. And no, I have not heard from Zhang since my
> > last e-mail. I suspect he is still working on finding a solution. But
> > you are of course right, reverting the patch in the meantime might be
> > a good idea.
> 
> It has too many dependencies.  Besides, reverting it now (at the beginning of
> a merge window) won't be particularly useful anyway.
> 
> We need to fix it.


Hi, sorry for hijacking this thread, but apparently my other plead
for help got ignored in this very busy mailing list.

I have an up-to-date recently installed debian wheezy. I downloaded
https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz and compiled it using:

  cp /boot/config-`uname -r` ./.config
  make menuconfig
  fakeroot make-kpkg --initrd --append-to-version=-vanilla.1 kernel_image kernel_headers -j38
  dpkg -i linux-image-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb linux-headers-3.16.0-vanilla.1_3.16.0-vanilla.1-10.00.Custom_amd64.deb

where .config was taken from debian /boot/config-3.14-0.bpo.1-amd64

my PC has 64GB of RAM, 32 Xeon E5-2687W cores and motherboard SuperMicro MBD-X9DRI

I just did 25 tries of suspend/resume cycle. I tried 4 different
methods of hibernation, you will find a full summary of my tries
(including how many failures for each method) in attached script
SLEEP.sh which I always used to perform hibernation.

The failure was always a reboot after resume had almost succeeded. In
cases when there was a success there was a following ---[cut here]--- part:

Aug  4 17:58:28 absurd kernel: [  660.993238] ------------[ cut here ]------------
Aug  4 17:58:28 absurd kernel: [  660.993247] WARNING: CPU: 10 PID: 11371 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()
Aug  4 17:58:28 absurd kernel: [  660.993291] Modules linked in: parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs fscache lockd sunrpc loop hid_logitech_dj raid1 usb_storage snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel nvidia(PO) kvm joydev hid_generic snd_hda_codec_ca0132 crct10dif_pclmul iTCO_wdt crc32_pclmul iTCO_vendor_support usbhid ghash_clmulni_intel hid mxm_wmi evdev aesni_intel snd_hda_intel aes_x86_64 ablk_helper cryptd glue_helper lrw snd_hda_controller gf128mul snd_hda_codec pcspkr snd_hwdep sb_edac snd_pcm edac_core snd_seq i2c_i801 snd_seq_device snd_timer snd lpc_ich mei_me mfd_core soundcore mei ioatdma ipmi_si ipmi_msghandler tpm_tis tpm processor wmi thermal_sys button ext4 mbcache crc16 jbd2 sr_mod cdrom sg sd_mod crc_t10dif crct10dif_common dm_mod md_mod crc32c_intel isci ahci libsas libahci libata scsi_transport_sas scsi_mod igb usbcore i2c_a
Aug  4 17:58:28 absurd kernel: lgo_bit usb_common i2c_core dca ptp pps_core [last unloaded: ehci_hcd]
Aug  4 17:58:28 absurd kernel: [  660.993309] CPU: 10 PID: 11371 Comm: kworker/u66:1 Tainted: P        W  O  3.16.0-vanilla.1 #1
Aug  4 17:58:28 absurd kernel: [  660.993310] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
Aug  4 17:58:28 absurd kernel: [  660.993316] Workqueue: events_unbound async_run_entry_fn
Aug  4 17:58:28 absurd kernel: [  660.993318]  0000000000000000 0000000000000009 ffffffff814fd161 0000000000000000
Aug  4 17:58:28 absurd kernel: [  660.993319]  ffffffff810664f6 ffffffffa03ff09b ffff881056e35ae0 ffff881055168100
Aug  4 17:58:28 absurd kernel: [  660.993321]  ffff880882a2fc90 ffff88105796b000 ffffffff813a7d3b ffff881055182200
Aug  4 17:58:28 absurd kernel: [  660.993321] Call Trace:
Aug  4 17:58:28 absurd kernel: [  660.993329]  [<ffffffff814fd161>] ? dump_stack+0x41/0x51
Aug  4 17:58:28 absurd kernel: [  660.993334]  [<ffffffff810664f6>] ? warn_slowpath_common+0x86/0xb0
Aug  4 17:58:28 absurd kernel: [  660.993337]  [<ffffffff813a7d3b>] ? _request_firmware+0x9ab/0x9d0
Aug  4 17:58:28 absurd kernel: [  660.993339]  [<ffffffff813a7e45>] ? request_firmware+0x35/0x60
Aug  4 17:58:28 absurd kernel: [  660.993343]  [<ffffffffa03fe03f>] ? ca0132_init+0x1bf/0x10d0 [snd_hda_codec_ca0132]
Aug  4 17:58:28 absurd kernel: [  660.993350]  [<ffffffffa02cfe21>] ? snd_hda_codec_read+0x51/0xa0 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993354]  [<ffffffffa02cff17>] ? hda_set_power_state+0xa7/0x160 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993359]  [<ffffffff81089d70>] ? update_rmtp+0x60/0x60
Aug  4 17:58:28 absurd kernel: [  660.993363]  [<ffffffffa02cf951>] ? hda_call_codec_resume+0x1a1/0x1c0 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993366]  [<ffffffffa02d1776>] ? snd_hda_resume+0x76/0xa0 [snd_hda_codec]
Aug  4 17:58:28 absurd kernel: [  660.993370]  [<ffffffffa03ab070>] ? azx_init_chip+0xf0/0x1f0 [snd_hda_controller]
Aug  4 17:58:28 absurd kernel: [  660.993373]  [<ffffffffa0334c91>] ? azx_resume+0xb1/0x180 [snd_hda_intel]
Aug  4 17:58:28 absurd kernel: [  660.993377]  [<ffffffff812d9b10>] ? pci_pm_default_resume+0x30/0x30
Aug  4 17:58:28 absurd kernel: [  660.993380]  [<ffffffff813a128b>] ? dpm_run_callback+0x4b/0xc0
Aug  4 17:58:28 absurd kernel: [  660.993382]  [<ffffffff813a1cd3>] ? device_resume+0x93/0x1d0
Aug  4 17:58:28 absurd kernel: [  660.993384]  [<ffffffff813a1e24>] ? async_resume+0x14/0x40
Aug  4 17:58:28 absurd kernel: [  660.993385]  [<ffffffff8108d02d>] ? async_run_entry_fn+0x2d/0x120
Aug  4 17:58:28 absurd kernel: [  660.993388]  [<ffffffff81080adb>] ? process_one_work+0x16b/0x400
Aug  4 17:58:28 absurd kernel: [  660.993390]  [<ffffffff81081184>] ? worker_thread+0x114/0x510
Aug  4 17:58:28 absurd kernel: [  660.993393]  [<ffffffff814ff3f8>] ? __schedule+0x2c8/0x760
Aug  4 17:58:28 absurd kernel: [  660.993395]  [<ffffffff81081070>] ? rescuer_thread+0x2c0/0x2c0
Aug  4 17:58:28 absurd kernel: [  660.993397]  [<ffffffff810876cc>] ? kthread+0xbc/0xe0
Aug  4 17:58:28 absurd kernel: [  660.993398]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:58:28 absurd kernel: [  660.993400]  [<ffffffff81502f3c>] ? ret_from_fork+0x7c/0xb0
Aug  4 17:58:28 absurd kernel: [  660.993401]  [<ffffffff81087610>] ? flush_kthread_worker+0x80/0x80
Aug  4 17:58:28 absurd kernel: [  660.993402] ---[ end trace db395c2b3c06720c ]---


To start debugging this my first question is: how can I
retrieve some useful logs from a failed resume attempt?

best regards
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |

--MP_/O0stk35F2QS.rKItn4FCRpp
Content-Type: application/x-shellscript
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=SLEEP.sh

IyEvYmluL2Jhc2gKCmxvZ2dlciAiPT09PT09PT09PSB0b3VjaCBmb3JjZWZzY2sgPT09PT09PT09
PT0iCnRvdWNoIC9mb3JjZWZzY2sKL2Jpbi9zeW5jCnNsZWVwIDEKCmxvZ2dlciAiPT09PT09PT09
PSBTVEFSVCBISUJFUk5BVElPTiA9PT09PT09PT0iCiMjIyMjIyMjPT09IEJlbG93IGFyZSA0IGRp
ZmZlcmVudCBtZXRob2RzIG9mIHN0YXJ0aW5nIGhpYmVybmF0aW9uID09PSMjIyMjIyMjCiMjIyMj
IyMjIGh0dHBzOi8vaGVscC51YnVudHUuY29tL2NvbW11bml0eS9Qb3dlck1hbmFnZW1lbnQvSGli
ZXJuYXRlICMjIyMjIyMjCiMjIyMjIyMjPT09PT09PT09PT09PT09PT09PT09PSBCZWdpbiA0IG1l
dGhvZHM6ID09PT09PT09PT09PT09PT09PT09PSMjIyMjIyMjCiMjIG1ldGhvZCAxKSAgICBrZXJu
ZWwgMy4xMy4wICAgICAgICAgICAgLSBmYWlscyBhbHdheXMKIyMgICAgICAgICAgICAgIGtlcm5l
bCAzLjE2LjAtdmFuaWxsYS4xICAtIDUgc3VjY2Vzc2VzcywgMCBmYWlsdXJlcwovdXNyL3NiaW4v
aGliZXJuYXRlCgojIyBtZXRob2QgMikgICAga2VybmVsIDMuMTMuMCAgICAgICAgICAgIC0gZmFp
bHMgYWx3YXlzCiMjICAgICAgICAgICAgICBrZXJuZWwgMy4xNi4wLXZhbmlsbGEuMSAgLSA4IHN1
Y2Nlc3Nlc3MsIDIgZmFpbHVyZXMKIy91c3Ivc2Jpbi9zMmRpc2sKCiMjIG1ldGhvZCAzKSAgICBr
ZXJuZWwgMy4xMy4wICAgICAgICAgICAgLSBmYWlscyBhd2xheXMKIyMgICAgICAgICAgICAgIGtl
cm5lbCAzLjE2LjAtdmFuaWxsYS4xICAtIDAgc3VjY2Vzc2VzcywgNSBmYWlsdXJlcwojZWNobyBw
bGF0Zm9ybSA+IC9zeXMvcG93ZXIvZGlzawojZWNobyBkaXNrID4gL3N5cy9wb3dlci9zdGF0ZQoK
IyMgbWV0aG9kIDQpICAgIGtlcm5lbCAzLjIuMCAgICAgICAgICAgICAtIDgwJSBzdWNlc3NlcyAy
MCUgZmFpbHVyZXMgKEkgdXNlZCBpdCBmb3IgbW9udGhzKQojIyAgICAgICAgICAgICAga2VybmVs
IDMuMTItYnBvICAgICAgICAgIC0gZmFpbHMgYWx3YXlzCiMjICAgICAgICAgICAgICBrZXJuZWwg
My4xMy4wICAgICAgICAgICAgLSAzIHN1Y2Nlc3NlcywgMiBmYWlsdXJlcwojIyAgICAgICAgICAg
ICAga2VybmVsIDMuMTYuMC12YW5pbGxhLjEgIC0gMiBzdWNjZXNzZXNzLCAzIGZhaWx1cmVzCiNl
Y2hvIHNodXRkb3duID4gL3N5cy9wb3dlci9kaXNrCiNlY2hvIGRpc2sgPiAvc3lzL3Bvd2VyL3N0
YXRlCiMjIyMjIyMjPT09PT09PT09PT09PT09PT09PT09PT0gRU5EIDQgbWV0aG9kcyA9PT09PT09
PT09PT09PT09PT09PT09PSMjIyMjIyMjCgpzbGVlcCA1Ci9ldGMvaW5pdC5kL3JzeXNsb2cgcmVz
dGFydApsb2dnZXIgIj09PT09PT09PT0gcmVzdW1lIGNvbXBsZXRlID09PT09PT09PT09IgoK

--MP_/O0stk35F2QS.rKItn4FCRpp--
