Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaHWKIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 06:08:07 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:36647 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaHWKID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 06:08:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAKszPgs3ULrDDTo=W+MsD-5PCd9yVNj3uxJ3LtGM9QTMT346aQ@mail.gmail.com>
References: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com>
 <CAG-aW06pKUeCddJCAN7cDDcs-T2jmjV33zxdh-jyVSx1uhq2Ww@mail.gmail.com>
 <CAKszPgvjBE5y35guVRXu7kp3nVZa4KPgh=AezVL-UXq=idRc-Q@mail.gmail.com>
 <53EC8579.1030008@redhat.com> <20140814220740.GA32475@xanatos>
 <CAKszPgservaZfMsV=c7c3yuPtm6cc2J14auDkG-pE-JPdrEXtQ@mail.gmail.com>
 <53F78B66.6040202@redhat.com> <CAKszPgs3ULrDDTo=W+MsD-5PCd9yVNj3uxJ3LtGM9QTMT346aQ@mail.gmail.com>
From: Claudio Bizzarri <claudio.bizzarri@gmail.com>
Date: Sat, 23 Aug 2014 12:07:41 +0200
Message-ID: <CAKszPgv4ML2byWtYCxHY0KNmW+VbPYWY3uQDr_XLg_9AFx960Q@mail.gmail.com>
Subject: Re: Kernel 3.16.0 USB crash
To: Hans de Goede <hdegoede@redhat.com>
Cc: "Nyman, Mathias" <mathias.nyman@intel.com>, Matt <jackdachef@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I must make a correction to what I said earlier: on kernel 3.16.1 if I
use a normal micro USB cable (not USB 3.0 one) I can mount my disk
(with uas module) BUT it not works properly. My computer does not
freeze but I obtain same kernel error

Aug 23 12:03:42 hp850ssd kernel: [   49.041091] usb 2-3.4: New USB
device found, idVendor=152d, idProduct=0567
Aug 23 12:03:42 hp850ssd kernel: [   49.041095] usb 2-3.4: New USB
device strings: Mfr=10, Product=11, SerialNumber=5
Aug 23 12:03:42 hp850ssd kernel: [   49.041098] usb 2-3.4: Product:
USB to ATA/ATAPI Bridge
Aug 23 12:03:42 hp850ssd kernel: [   49.041099] usb 2-3.4: Manufacturer: JMicron
Aug 23 12:03:42 hp850ssd kernel: [   49.041101] usb 2-3.4:
SerialNumber: 152D00539000
Aug 23 12:03:43 hp850ssd kernel: [   49.562449] usbcore: registered
new interface driver usb-storage
Aug 23 12:03:43 hp850ssd kernel: [   49.567258] scsi2 : uas
Aug 23 12:03:43 hp850ssd kernel: [   49.567591] usbcore: registered
new interface driver uas
Aug 23 12:03:47 hp850ssd kernel: [   53.566515] scsi 2:0:0:0:
Direct-Access     JMicron  Generic          0100 PQ: 0 ANSI: 6
Aug 23 12:03:47 hp850ssd kernel: [   53.567449] sd 2:0:0:0: Attached
scsi generic sg1 type 0
Aug 23 12:03:47 hp850ssd kernel: [   53.567544] sd 2:0:0:0: [sdb]
976773168 512-byte logical blocks: (500 GB/465 GiB)
Aug 23 12:03:47 hp850ssd kernel: [   53.567547] sd 2:0:0:0: [sdb]
4096-byte physical blocks
Aug 23 12:03:47 hp850ssd kernel: [   53.568326] sd 2:0:0:0: [sdb]
Write Protect is off
Aug 23 12:03:47 hp850ssd kernel: [   53.568329] sd 2:0:0:0: [sdb] Mode
Sense: 67 00 10 08
Aug 23 12:03:47 hp850ssd kernel: [   53.568662] sd 2:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, supports DPO and FUA
Aug 23 12:03:47 hp850ssd kernel: [   53.613054]  sdb: sdb1
Aug 23 12:03:47 hp850ssd kernel: [   53.614845] sd 2:0:0:0: [sdb]
Attached SCSI disk
Aug 23 12:03:47 hp850ssd udisksd[3189]: Mounted /dev/sdb1 at
/media/b0/HP850G1-external on behalf of uid 1000
Aug 23 12:03:47 hp850ssd kernel: [   53.868635] EXT4-fs (sdb1):
recovery complete
Aug 23 12:03:47 hp850ssd kernel: [   53.868640] EXT4-fs (sdb1):
mounted filesystem with ordered data mode. Opts: (null)
Aug 23 12:04:18 hp850ssd kernel: [   84.793627] sd 2:0:0:0: [sdb]
uas_eh_abort_handler ffff88023c242900 tag 32, inflight: CMD
Aug 23 12:04:21 hp850ssd kernel: [   87.790971] scsi host2:
uas_eh_task_mgmt: ABORT TASK timed out
Aug 23 12:05:08 hp850ssd kernel: [  134.726718] BUG: unable to handle
kernel paging request at 0000000008e809a6
Aug 23 12:05:08 hp850ssd kernel: [  134.726750] IP:
[<ffffffffc09fa155>] uas_log_cmd_state+0x35/0x340 [uas]
Aug 23 12:05:08 hp850ssd kernel: [  134.726776] PGD 0
Aug 23 12:05:08 hp850ssd kernel: [  134.726785] Oops: 0000 [#1] SMP
Aug 23 12:05:08 hp850ssd kernel: [  134.726800] Modules linked in: uas
usb_storage hid_generic hidp hid nvram vmnet(OE) parport_pc
vmw_vsock_vmci_transport vsock vmw_vmci vmmon(OE) ctr ccm btusb
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common
videodev media joydev arc4 intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm hp_wmi crct10dif_pclmul
sparse_keymap crc32_pclmul rfcomm bnep ghash_clmulni_intel aesni_intel
bluetooth 6lowpan_iphc aes_x86_64 lrw gf128mul glue_helper ablk_helper
iwlmvm cryptd mac80211 snd_seq_midi snd_hda_codec_idt
snd_seq_midi_event snd_hda_codec_generic serio_raw snd_hda_codec_hdmi
radeon i915 iwlwifi snd_hda_intel wmi snd_hda_controller snd_rawmidi
snd_hda_codec snd_seq snd_hwdep snd_seq_device hp_wireless ttm lpc_ich
intel_smartconnect drm_kms_helper hp_accel drm snd_pcm video
i2c_algo_bit lis3lv02d input_polldev tpm_infineon rtsx_pci_ms memstick
snd_timer cfg80211 snd soundcore mei_me binfmt_misc mac_hid mei ppdev
lp parport rtsx_pci_sdmmc psmouse e1000e ahci ptp rtsx_pci libahci
pps_core [last unloaded: vmnet]
Aug 23 12:05:08 hp850ssd kernel: [  134.727231] CPU: 3 PID: 5010 Comm:
scsi_eh_2 Tainted: G        W  OE 3.16.1-031601-generic #201408140014
Aug 23 12:05:08 hp850ssd kernel: [  134.727264] Hardware name:
Hewlett-Packard HP EliteBook 850 G1/198F, BIOS L71 Ver. 01.12
06/25/2014
Aug 23 12:05:08 hp850ssd kernel: [  134.727295] task: ffff8801f3a40a20
ti: ffff880096964000 task.ti: ffff880096964000
Aug 23 12:05:08 hp850ssd kernel: [  134.727321] RIP:
0010:[<ffffffffc09fa155>]  [<ffffffffc09fa155>]
uas_log_cmd_state+0x35/0x340 [uas]
Aug 23 12:05:08 hp850ssd kernel: [  134.727354] RSP:
0018:ffff880096967b98  EFLAGS: 00010082
Aug 23 12:05:08 hp850ssd kernel: [  134.727373] RAX: ffff88024a41e850
RBX: ffff88024a41e830 RCX: ffffffffc09fe720
Aug 23 12:05:08 hp850ssd kernel: [  134.727398] RDX: 000000004a41e828
RSI: ffffffffc09fe720 RDI: ffff88024a41e718
Aug 23 12:05:08 hp850ssd kernel: [  134.727422] RBP: ffff880096967c88
R08: 000000000000000a R09: 0000000000000490
Aug 23 12:05:08 hp850ssd kernel: [  134.727446] R10: 0000000000000000
R11: 000000000000048f R12: ffff88024a41e730
Aug 23 12:05:08 hp850ssd kernel: [  134.727471] R13: 0000000000000008
R14: ffff88024a41e818 R15: 0000000008e808e6
Aug 23 12:05:08 hp850ssd kernel: [  134.727496] FS:
0000000000000000(0000) GS:ffff88024aac0000(0000)
knlGS:0000000000000000
Aug 23 12:05:08 hp850ssd kernel: [  134.727523] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Aug 23 12:05:08 hp850ssd kernel: [  134.727543] CR2: 0000000008e809a6
CR3: 0000000001c12000 CR4: 00000000001407e0
Aug 23 12:05:08 hp850ssd kernel: [  134.727568] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Aug 23 12:05:08 hp850ssd kernel: [  134.727593] DR3: 0000000000000000
DR6: 00000000fffe0ff0 DR7: 0000000000000400
Aug 23 12:05:08 hp850ssd kernel: [  134.727617] Stack:
Aug 23 12:05:08 hp850ssd kernel: [  134.727624]  ffff880096967bf8
0000000000000000 000000000000009e ffffffffc09fe2f8
Aug 23 12:05:08 hp850ssd kernel: [  134.727654]  0000000000000009
ffffffffc09fa67a ffff880096967c28 ffffffff8177a82d
Aug 23 12:05:08 hp850ssd kernel: [  134.727684]  000000000000009e
ffffffff00000010 ffff880096967c38 ffff880096967bf8
Aug 23 12:05:08 hp850ssd kernel: [  134.727714] Call Trace:
Aug 23 12:05:08 hp850ssd kernel: [  134.727725]  [<ffffffffc09fa67a>]
? uas_mark_cmd_dead+0xda/0xf0 [uas]
Aug 23 12:05:08 hp850ssd kernel: [  134.727750]  [<ffffffff8177a82d>]
? printk+0x61/0x63
Aug 23 12:05:08 hp850ssd kernel: [  134.727769]  [<ffffffff8107208f>]
? warn_slowpath_common+0x9f/0xc0
Aug 23 12:05:08 hp850ssd kernel: [  134.727792]  [<ffffffffc09fa5d1>]
uas_mark_cmd_dead+0x31/0xf0 [uas]
Aug 23 12:05:08 hp850ssd kernel: [  134.727815]  [<ffffffffc09fa704>]
uas_abort_inflight+0x74/0xb0 [uas]
Aug 23 12:05:08 hp850ssd kernel: [  134.727839]  [<ffffffffc09fb154>]
uas_eh_bus_reset_handler+0x84/0x160 [uas]
Aug 23 12:05:08 hp850ssd kernel: [  134.727864]  [<ffffffff81512f23>]
scsi_try_bus_reset+0x53/0x110
Aug 23 12:05:08 hp850ssd kernel: [  134.727886]  [<ffffffff81515047>]
scsi_eh_bus_reset+0xf7/0x270
Aug 23 12:05:08 hp850ssd kernel: [  134.727908]  [<ffffffff81515b02>]
scsi_eh_ready_devs+0x72/0xa0
Aug 23 12:05:08 hp850ssd kernel: [  134.727930]  [<ffffffff81516afd>]
scsi_unjam_host+0x10d/0x1f0
Aug 23 12:05:08 hp850ssd kernel: [  134.727952]  [<ffffffff81516d45>]
scsi_error_handler+0x165/0x1d0
Aug 23 12:05:08 hp850ssd kernel: [  134.727974]  [<ffffffff81516be0>]
? scsi_unjam_host+0x1f0/0x1f0
Aug 23 12:05:08 hp850ssd kernel: [  134.727996]  [<ffffffff81096479>]
kthread+0xc9/0xe0
Aug 23 12:05:08 hp850ssd kernel: [  134.728015]  [<ffffffff810963b0>]
? flush_kthread_worker+0xb0/0xb0
Aug 23 12:05:08 hp850ssd kernel: [  134.728038]  [<ffffffff81793efc>]
ret_from_fork+0x7c/0xb0
Aug 23 12:05:08 hp850ssd kernel: [  134.728058]  [<ffffffff810963b0>]
? flush_kthread_worker+0xb0/0xb0
Aug 23 12:05:08 hp850ssd kernel: [  134.728079] Code: 81 ec f0 00 00
00 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 4c 8b
bf 00 01 00 00 48 89 75 a0 8b 97 18 01 00 00 <49> 8b 87 c0 00 00 00 48
85 c0 48 89 45 c8 48 c7 c0 2a e0 9f c0
Aug 23 12:05:08 hp850ssd kernel: [  134.728215] RIP
[<ffffffffc09fa155>] uas_log_cmd_state+0x35/0x340 [uas]
Aug 23 12:05:08 hp850ssd kernel: [  134.728241]  RSP <ffff880096967b98>
Aug 23 12:05:08 hp850ssd kernel: [  134.728264] CR2: 0000000008e809a6
Aug 23 12:05:08 hp850ssd kernel: [  134.734092] ---[ end trace
4bfad36e9bbe6ec8 ]---


2014-08-23 9:37 GMT+02:00 Claudio Bizzarri <claudio.bizzarri@gmail.com>:
> Ok, thank you Hans.
>
> When I connect my external USB disk I've 30 seconds before my laptop
> freezes: with top command I cannot view nothing: no abnormal cpu
> usage, no any strange memory usage.
> If I remove disk before 30 seconds my HP EliteBook 850G1 keeps working
> as usual. Can I use these 30 seconds to extract some informations that
> help to determine what's the problem? How?
> /var/log/syslog and dmesg haven't any messages.
>
> System lock is complete: also key CAPS LOCK does not work anymore.
>
> I've tried without X: when computer locks  3 lines appear on console
> that are not registered on syslog, I've copied them on paper.
>
> [ 1200.352042] IP: [<ffffffff8179393f>] _raw_spin_lock_irqsave+ 0x01f/0x060
> [ 1200.352045] PGD 0
> [ 1200.352048] Oops: 0002 [#1] SMP
>
> Ciao,
> Claudio
>
> 2014-08-22 20:26 GMT+02:00 Hans de Goede <hdegoede@redhat.com>:
>>...
>> There is no need to try my patch, since the descriptors already limit
>> qdepth to 32. No idea what is going on here then.
