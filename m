Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3A1T5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:57:30 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:40219 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3A1T51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:57:27 -0500
Date: Mon, 28 Jan 2013 14:57:08 -0500
From: "John L. Males" <jlmales@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re[02]: Kernel Failure - 3.4.24
Message-Id: <20130128145708.3c241dc8.jlmales@gmail.com>
In-Reply-To: <51055256.6030602@linutronix.de>
References: <20130116184221.aaa9e2aa.jlmales@gmail.com>
	<51055256.6030602@linutronix.de>
Reply-To: jlmales@gmail.com
Organization: Toronto, Ontario
X-Mailer: Sylpheed 3.1.3 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sebastian,


Message replied to:

Date: Sun, 27 Jan 2013 17:14:14 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: jlmales@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Failure - 3.4.24


> On 01/17/2013 12:42 AM, John L. Males wrote:
> > Hello,
> 
> Hi,
> 
> > I copied Sebastian in on the post my review of Changelogs
> > suggests Sebastian is the one who will want to know about
> > this kernel failure or will know who should be.
> 
> I did what? I reviewed patches since they went in this
> problem occurs?

I was not suggesting you are responsible for the bug at all. On
various links I looked at for reporting kernel bugs it is
suggested it is best to copy in a kernel person in when posting
to the LKML otherwise the posting will likely not receive a
response.  When I looked through recent ChangeLogs your name was
often related to USB issues. As I believed this kernel failure
was a USB related I copied you in. I was expecting upon your
review of the kernel failure you determined that you knew who
best to look at the kernel failure you could then direct
the issue to that person.  Doing so I would have been be very
grateful.  I am not a kernel developer and I therefore do not
know how to read these failures, let alone know what code
failed.  I also therefore do not know who this kernel failure
should be directed to.  I was hoping your higher Linux kernel
and LKML knowledge would assist me in ensuring this kernel
failure was directed to the correct kernel developer. 

> 
> > I am not on the LKML so it would be appreciated if I was CC
> > on any related replies to this kernel failure which
> > appeared to occur when a USB MP3 player was inserted or
> > removed from the HP NC6400 laptop.
> 
> Next time you post logs try to format them like this (or
> people might ignore it because it is too hard to read):

Thank you for the formatting tip.

> 
> > The kernel failure trace information was:
> > 
> > Kernel failure message 1: [327619.690505] ------------[ cut
> > here ]------------ [327619.690518] WARNING: at
> > fs/buffer.c:1106 mark_buffer_dirty +0x8b/0xb0()
> > [327619.690523]
> Hardware name: HP Compaq nc6400 (RM100AW#ABA)
> [327619.690526] Modules linked in: nls_utf8
> > nls_cp437 vfat fat usb_storage option usb_wwan usbserial 
> > snd_hrtimer ip6table_filter ip6_tables iptable_filter
> > ip_tables kvm_intel kvm ebtable_nat ebtables x_tables
> > cpufreq_userspace cpufreq_stats cpufreq_powersave
> > cpufreq_conservative bridge stp bnep rfcomm bluetooth crc16
> > ppdev lp binfmt_misc i915 drm_kms_helper drm i2c_algo_bit
> > i2c_core uinput fuse loop snd_hda_codec_si3054
> > snd_hda_codec_analog snd_hda_intel snd_hda_codec
> > tpm_infineon arc4 snd_hwdep snd_pcm_oss snd_mixer_oss
> > snd_pcm iwl3945 snd_seq_dummy iwlegacy snd_seq_oss usbhid
> > snd_seq_midi snd_rawmidi coretemp hid snd_seq_midi_event
> > snd_seq mac80211 pcmcia snd_timer irda snd_seq_device
> > microcode snd cfg80211 yenta_socket psmouse joydev
> > parport_pc tifm_7xx1 tpm_tis soundcore pcmcia_rsrc
> > tifm_core pcspkr evdev snd_page_alloc pcmcia_core parport
> > tpm crc_ccitt hp_wmi hp_accel lis3lv02d sparse_keymap
> > serio_raw acpi_cpufreq tpm_bios rng_core rfkill mperf
> > input_polldev wmi battery ac container power_supply
> > processor video button ext2 mbcache dm_mod btrfs
> > zlib_deflate crc32c libcrc32c sg sr_mod cdrom sd_mod
> > crc_t10dif ata_generic pata_acpi uhci_hcd ata_piix libata
> > ehci_hcd sdhci_pci scsi_mod ide_pci_generic tg3 ide_core
> > sdhci mmc_core libphy usbcore thermal usb_common fan
> > thermal_sys
> 
> [last unloaded: scsi_wait_scan]
> 
> [327619.690737] Pid: 31574, comm: sync Tainted: G  W
> 3.4.24-kernel.org-jlm-010-amd64 #1
> 
> This line looks like you have custom patches on your tree.

I have no custom patches to the kernel.

For the last several kernels over about 12 months I download the
kernel source directly from kernel.org.  The first time I
downloaded a kernel from kernel.org I used the kernel
configuration GUI and configured the kernel from scratch.
Thereafter as was the case with this kernel I use "make
oldconfig" using the last kernel configuration I used with the
new items added since the last kernel I compiled that "make
oldconfig" identifies.

> 
> [327619.690741] Call Trace:
> [327619.690751] [<ffffffff8105177f>] warn_slowpath_common
> +0x7f/0xc0 [327619.690757] [<ffffffff810517da>]
> warn_slowpath_null+0x1a/0x20 [327619.690762]
> [<ffffffff811b67fb>] mark_buffer_dirty+0x8b/0xb0
> [327619.690774] [<ffffffffa028b734>] ext2_sync_super
> +0x94/0x100 [ext2] [327619.690784] [<ffffffffa028b809>]
> ext2_sync_fs+0x69/0x80 [ext2] [327619.690790]
> [<ffffffff811b4480>] ? __sync_filesystem+0x90/0x90
> [327619.690795] [<ffffffff811b4453>] __sync_filesystem
> +0x63/0x90 [327619.690801] [<ffffffff811b449f>] sync_one_sb
> +0x1f/0x30 [327619.690807] [<ffffffff81188c77>] iterate_supers
> +0xb7/0xf0 [327619.690812] [<ffffffff811b44fa>] sys_sync
> +0x4a/0x70 [327619.690819] [<ffffffff814c51a9>]
> system_call_fastpath+0x16/0x1b [327619.690942] ---[ end trace
> 7e4761e5ee97ad0c ]---
> 
> > If you need additional information please advise.
> 
> This looks like
> https://bugzilla.redhat.com/show_bug.cgi?id=468794
> 
> I think that I am innocent here. You probably unpluged the
> device before the content was written back to the media.
> Could it be?

I looked at the RedHat bug 468794.  The bug seems to indicate
it was never fixed.  The bug was reported against
2.6.27.4-47.rc3.fc10.i686 #1 on 2008-10-27 21:34:04 EDT and
was closed 2009-12-18 01:40:33 EST.  The differences are a bug
of at least 5 years ago and a 2.6 kernel verses 5 years later
and current at time stable kernel 3.4.24 from kernel.org with no
patches I applied when this kernel failure I encountered
occurred.  If this is the same bug then there is a bug that may
have been about for a while or perhaps a regression.  The fact
is the RedHat bug 468794 was never fixed.

At no point was I suggesting you were to blame for the kernel
failure.  My eM2008-10-27 21:34:04 EDT ail with you copied in
was simply my best guess after looking at the last few
ChangLogs as a good place to start in copying in someone more
in the know that me that could determine who is best to look at
this kernel failure.

No content was written to the device by me.  The device was
simply plugged in and then removed just to confirm the device
was seen by my system.  After this kernel failure the device
was plugged back in a few minutes later, browsed, a file copied
from, a file copied/erased as part of validating this device
behaved like a USB flash device.  The device was then removed
with no issue or kernel failure.  The exact same device has
been plugged in/out on two seperate days since the day of the
kernel failure with no kernel failures or issues associated
with the device.

> 
> > 
> > Regards,
> > 
> > John L. Males Toronto, Ontario Canada 16 January 2013 18:42
> 
> Sebastian

Again if there is further information required please advise.


Regards,

John L. Males
Toronto, Ontario
Canada
28 January 2013 14:57


==============================================================
2013-01-28 14:04:01.922357120-0500-EST

28 Jan 14:04:01 ntpdate[5798]: ntpdate 4.2.6p2@1.2194-o Sun Oct
17 13:35:14 UTC 2010 (1)

28 Jan 14:04:25 ntpdate[5803]: step time server 199.102.46.72
offset -7.091489 sec

Linux 3.4.24-kernel.org-jlm-010-amd64 #1 SMP PREEMPT Sun Dec 23
10:06:41 EST 2012

Modified Debian GNU/Linux 6.0.3 (squeeze)
(Evaluating alternatives to Debian)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEG2BQACgkQ+V/XUtB6aBA2+ACggsK4Zeu0ApJ1Qn5wtXX4rXp8
RyMAnjfKg0G08E2tViOA9UFQRBcworK6
=vgDl
-----END PGP SIGNATURE-----
