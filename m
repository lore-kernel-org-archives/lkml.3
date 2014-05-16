Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaEPVaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:30:19 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:53868 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaEPVaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:30:12 -0400
Date: Fri, 16 May 2014 17:30:00 -0400
From: "John L. Males" <jlmales@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Kernel Failure - 3.4.24 Similar USB MO To 3.4.89 Kernel Failure
Message-Id: <20140516173000.7aa5e7980c0c16e6a46d4283@gmail.com>
In-Reply-To: <20130130135815.33c9855b.jlmales@gmail.com>
References: <20130116184221.aaa9e2aa.jlmales@gmail.com>
	<51055256.6030602@linutronix.de>
	<20130128145708.3c241dc8.jlmales@gmail.com>
	<51084005.2050506@linutronix.de>
	<20130130135815.33c9855b.jlmales@gmail.com>
Reply-To: jlmales@gmail.com
Organization: Toronto, Ontario
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__16_May_2014_17_30_00_-0400_z59tagkgdEQnMgC1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Multipart=_Fri__16_May_2014_17_30_00_-0400_z59tagkgdEQnMgC1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

Please CC me in on replies as I am not part of the LKML.

As the prior round of discussion about this ongoing USB Kernel
problem was with Sebastian, I have CC'ed Sebastian in on this
posting as well.  Again this is because the Linux Kernel
information suggests CCing in someone that might be able to
assist for the area of concern.  My hope is that this will
assist in determining who should be the kernel developer that
needs to look at these Kernel failures and the crash/opps if
need be.

I have a very very busy and unpredictable schedule, so I would
ask for patience in a reply from me if one is so needed.

For the last few years I have had about a half dozen Kernel
failures that all appear to be related to USB devices being
plugged in.

The last occurrence a few months ago to the one today actually
caused a kernel crash/opps to the console resulting in the only
option was to power off the machine and power it back on. I
took a high quality DSLR image of the screen which clearly
has important information roll off as the screen was not
large enough to hold the information.  I also searched high
and low using a my tablet for a few days to see if I could
find out how I might be able to secure the information that
rolled off the screen, not to mention have it in a easy to
use form for the Kernel developers to work with.  I have
looked since powering up the machine from that event and many
times since and can only find references, as then, to using a
second machine connected to the machine had had the Kernel
crash/opps via serial using a debugger.  I do not have the
kernel experience or such at this point to know how to do this
and reading suggested some one or few Kernel options were
needed in the Kernel for this serial debugging approach to
work.  So on that note if anyone can advise me if there is a
way to find where a kernel crash/opps is stored that one can
collect and send to the Kernel Developers I would be most
appreciative.  I have and still do make efforts to find the
information.  It is possible I am not using the correct search
terms or know where I need to look to read the about the
information.

About 14:49 EDT my system experienced yet another Linux Kernel
failure.  Again it was related to inserting a basic USB, not a
MP3 player USB, just a plain data USB.  This followed my
removing a different USB after issuing a pumount command that
returned as successful.  I have attached a copy of the kernel
failure details.

If there is a desire to see the DSLR screen image of the prior
kernel crash/opps please advise me to do so.

Please be aware I do not use any drivers other than those in
the Linux Kernel other than those in the stock Kernel.  I do
not need any unique drivers for my machine or the devices I use
with my laptop.  Also be aware all of the 3.x Linux Kernels I
have used are from Kernel.org and I compile these myself using
the same configuration file plus any additional config file item
options I set that are added to the next 3.4.x kernel version
I compile. This means there is no reason for my kernel to ever
be tainted.  If my Linux 3.4.x Kernel is listed as tainted, it
is the stock Linux Kernel that has so decided for some reason.


Regards,

John L. Males
Toronto, Ontario
Canada
16 May 2014 17:30 -0400 EDT


================================================================

2014-05-16 16:56:58.344920846-0400-EDT Time: 1400273818

16 May 16:56:58 ntpdate[14149]: ntpdate 4.2.6p2@1.2194-o Sun
Oct 17 13:35:14 UTC 2010 (1)

16 May 16:57:12 ntpdate[14154]: step time server 208.80.96.70
offset 0.003026 sec

Linux 3.4.89-kernel.org-jlm-010-amd64 #1 SMP PREEMPT Wed May 7
22:33:10 EDT 2014

Modified Debian GNU/Linux 6.0.3 (squeeze)
(Alternative to Debian determined, work in progress)

cat /proc/cpuinfo (Selected):

model name	: Intel(R) Core(TM)2 CPU         T5600  @
1.83GHz

vmstat -s:

      3452464 K total memory
      3381088 K used memory
      2608984 K active memory
       570068 K inactive memory
        71376 K free memory
         2796 K buffer memory
       106480 K swap cache
      8225244 K total swap
      1875240 K used swap
      6350004 K free swap
     36725845 non-nice user cpu ticks
       692898 nice user cpu ticks
      4757452 system cpu ticks
     78815904 idle cpu ticks
      2909319 IO-wait cpu ticks
         5590 IRQ cpu ticks
      1678486 softirq cpu ticks
            0 stolen cpu ticks
     81758774 pages paged in
     66779328 pages paged out
      6643777 pages swapped in
      5417469 pages swapped out
    431124356 interrupts
    567863734 CPU context switches
   1399647013 boot time
       175501 forks

/proc/vmstat (Selected):

pgpgin 81758774
pgpgout 66779328
pswpin 6643777
pswpout 5417469
pgfree 776294670
pgfault 546643863
pgmajfault 2018217

/proc/meminfo (Selected):

Mlocked:            6604 kB
VmallocTotal:   34359738367 kB
VmallocChunk:   34359322080 kB
HugePages_Total:       0

vmstat --partition /dev/sda8 (Swap):

sda8          reads   read sectors  writes    requested writes
             3742213   53151675    1158726   43339752

sar -b:

Linux 3.4.89-kernel.org-jlm-010-amd64
(pwsdhhuesloejsgegsjwilastwhsk) 	05/16/2014
_x86_64_	(2 CPU)

12:00:01 AM  pgpgin/s pgpgout/s   fault/s  majflt/s  pgfree/s
pgscank/s pgscand/s pgsteal/s    %vmeff

04:35:01 PM    426.19    146.11   1143.15     21.68
1542.74    243.70     64.92    113.82     36.88 04:45:01 PM
1121.83    332.40    965.00     47.56   1442.54    526.49
108.97    300.88     47.35 04:55:02 PM    151.93     55.71
971.67      9.88   1745.04    103.53     28.38     42.41
32.16 Average:       294.06    141.73   1084.45     16.18
1411.21    163.03     22.25     80.41     43.40

ps -A:

%CPU  START   TIME  C CLS COMMAND             TIME  NI   PID
POL PRI    SZ   RSS    VSZ  SIZE  MAJFL  MINFL SCH STAT
TIME WCHAN

 0.1 May  9  14:26  0  TS kswapd0         00:14:26   0    26
TS   19     0     0      0     0      0      0   0 S
00:14:26 kswapd


Message replied to:

Date: Wed, 30 Jan 2013 13:58:15 -0500
From: "John L. Males" <jlmales@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re[04]: Kernel Failure - 3.4.24


> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Sebastian,
> 
> Message replied to:
> 
> Date: Tue, 29 Jan 2013 22:32:53 +0100
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> To: jlmales@gmail.com
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Kernel Failure - 3.4.24
> 
> 
> > On 01/28/2013 08:57 PM, John L. Males wrote:
> > > I was not suggesting you are responsible for the bug at
> > > all. On
> > Okay then :)
> > 
> > > I have no custom patches to the kernel.
> > okay. 
> > 
> > > I looked at the RedHat bug 468794.  The bug seems to
> > > indicate it was never fixed.  The bug was reported
> > > against 2.6.27.4-47.rc3.fc10.i686 #1 on 2008-10-27
> > > 21:34:04 EDT and was closed 2009-12-18 01:40:33 EST.  The
> > > differences are a bug of at least 5 years ago and a 2.6
> > > kernel verses 5 years later and current at time stable
> > > kernel 3.4.24 from kernel.org with no patches I applied
> > > when this kernel failure I encountered occurred.  If this
> > > is the same bug then there is a bug that may have been
> > > about for a while or perhaps a regression.  The fact is
> > > the RedHat bug 468794 was never fixed.
> > 
> > Lets see. According to the backtrace it seems that the
> > kernel was not able to write the buffer back to disk. The
> > RH bug says that someone unplugged the device without an
> > unmount of the disk.
> 
> Yes I read that someone unplugged the device without an
> unmount of the device in the RedHat log.
> 
> > 
> > My question are:
> > - what were you doing by the time this happened?
> 
> I plugged the USB device into my laptop, then removed it.
> There was no user activity related to activity on the
> device.  If there was activity, as opposed to user based
> activity, to warrant the kernel needing to write a buffer to
> the USB flash drive it was not a result of any user activity
> to the USB drive.  Based on your findings in the back trace
> the kernel was not able to write a buffer to the USB device
> from what happened at the time.  I would be concerned that
> the kernel thought there was a buffer to write when the user,
> which was me, performed no activity upon the USB device.  The
> person who owns the USB device knows next to nothing about
> computers, let alone Windows or Linux, so I would be the only
> one performing any actions related to the device.
> 
> 
> > - can you reproduce it (reliably)?
> 
> No, I did try exactly what I did when the kernel failure
> happened and sadly could not recreate the issue.  I know how
> important that question is and tried a few times to cause the
> problem.  I was hoping the kernel failure information would
> have information indicating the cause of the failure.  I often
> placed my system in hibernate such that my system will go a
> month or bit more before I will reboot my kernel or to boot a
> newly compiled kernel.  I know for a while in the early 3.2.x
> releases doing so caused the kernel some issues and the system
> would need to be rebooted or would just reboot on its own.
> There are a number of variable to this.  I do not know if this
> USB failure is an artifact of that often necessary practive I
> have to place my system in hibernate almost daily, sometimes a
> few times during the day.
> 
> As an FYI I had a full kernel opps a few 3.2.x versions ago.
> It was my first one in years.  I was hoping there would be a
> file of the information that displayed on the screen.  My
> research after the kernel opps suggests one has to write down
> the information on the screen from a kernel opps, which I did
> not do as I did not think I would need to anymore.  The
> reason I mention this is that kernel opps was with a USB
> device as well.  The difference was it was a USB Wireless BGN
> device that I have used many times over the last 12 months
> with a number of 3.2.x kernels with no kernel opps/failure,
> just odd functional issues that seem to resolve in later
> kernel versions. The kernel opps that occurred with this
> Wireless BGN device only occurred once with that exact older
> 3.2.x kernel version and I have no clue why.  I have no
> information I know of about that kernel opps that might help
> with this kernel failure.  I did not know I needed to write
> down the screen from the opps.  I therefore cannot provide
> the kernel opps information that might share some common
> findings with the kernel failure of this issue.  I suspect
> there may be nothing in common, but without the kernel opps
> information we will not know for certain. 
> 
> The USB device was a MP3 player that acts like a flash USB
> drive when it is plugged into a computer.  This means one can
> copy to/from, rename, delete files using the command line or
> any file manager one uses.
> 
> > - Is this *new* meaning is there a kernel where did not
> > happen?
> 
> I am not sure where the "new" reference you are referring to
> is from.  That said, the only time this person's MP3
> player/USB flash was used was with the kernel.org 3.2.24
> kernel I noted.
> 
> The only other USB problem I had was once with a USB Wireless
> BGN device that has see alot of activity on my system and had
> one opps on a 3.2.x kernel prior to 3.2.24 and again only once
> on that kernel version. 
> 
> > 
> > Sebastian
> 
> I know you know, but for those that do not, I am not on the
> LKML.  It would be appreciated if I was copied in on any LKML
> replies.
> 
> As always if there is more information or clarification needed
> please ask.
> 
> 
> Regards,
> 
> John L. Males
> Toronto, Ontario
> Canada
> 30 January 2013 13:58
> 
> 
> ==============================================================
> 2013-01-30 13:09:05.479017366-0500-EST
> 
> 30 Jan 13:09:05 ntpdate[17854]: ntpdate 4.2.6p2@1.2194-o Sun
> Oct 17 13:35:14 UTC 2010 (1)
> 
> 30 Jan 13:09:32 ntpdate[17863]: step time server 142.4.209.106
> offset -7.350323 sec
> 
> Linux 3.4.24-kernel.org-jlm-010-amd64 #1 SMP PREEMPT Sun Dec
> 23 10:06:41 EST 2012
> 
> Modified Debian GNU/Linux 6.0.3 (squeeze)
> (Evaluating alternatives to Debian)
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> 
> iEYEARECAAYFAlEJbUcACgkQ
> +V/XUtB6aBAh4ACeKQIM7vMWliG9iHpUfmhwQPKo
> 58sAoMiUS1AgNtfj0oBBPydcP60m3dyH =8sUO
> -----END PGP SIGNATURE-----
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlN2g1gACgkQ+V/XUtB6aBBBWACgyCfzfETF9d1GNI6Ci2MIbIvA
nwEAn1Q+k+ogNczAoBOvZGWEQp2YUdhs
=MxB8
-----END PGP SIGNATURE-----

--Multipart=_Fri__16_May_2014_17_30_00_-0400_z59tagkgdEQnMgC1
Content-Type: text/plain;
 name="kernel-linux-failure-20140516-1449-PerLXDE-WithNotes.txt"
Content-Disposition: attachment;
 filename="kernel-linux-failure-20140516-1449-PerLXDE-WithNotes.txt"
Content-Transfer-Encoding: 7bit

20140516 14:49 Window of LXDE popped up saying had kernel failure.

Failure occurred yet again as handful of times prior versions in past couple years related to USB

Last time was USB TV adaptor was inserted after had been removed.

This time umounted wip 8gb ArchLinux USB created on T5730 with umount command in system since early hours of this morning,
then inserted 2gb USB that has boot/install image of ArchLinux used on T5730 to create the WIP ArchLinux on 8GB flash
at which point kernel failure occurred.

unmount was done via console which already has console logging enabled:

20140516 14:47:26 -0400 EDT keypunch@pwsdhhuesloejsgegsjwilastwhsk:/vm/ISOs/linux/ArchLinux/archlinux/2014.05.01 tty0 $ pumount /media/0ad46398-13a0-4c3d-93f9-34e67510f053
20140516 14:47:42 -0400 EDT keypunch@pwsdhhuesloejsgegsjwilastwhsk:/vm/ISOs/linux/ArchLinux/archlinux/2014.05.01 tty0 $ cd /vm/ISOs/linux/debian/debian/debian-cd/7.5.0-live/i386/iso-hybrid


Choose not to send, but show details of:


Kernel failure message 1:
[619141.142769] ------------[ cut here ]------------
[619141.142784] WARNING: at block/genhd.c:1573 disk_clear_events+0x11f/0x130()
[619141.142788] Hardware name: HP Compaq nc6400 (RM100AW#ABA)
[619141.142791] Modules linked in: ext4 jbd2 ufs isofs nls_iso8859_1 nls_utf8 nls_cp437 vfat fat cryptd aes_x86_64 aes_generic snd_hrtimer kvm_intel kvm ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative bridge stp bnep rfcomm bluetooth crc16 ppdev lp binfmt_misc i915 drm_kms_helper drm i2c_algo_bit i2c_core uinput fuse loop snd_hda_codec_si3054 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss arc4 snd_mixer_oss snd_pcm iwl3945 snd_seq_dummy snd_seq_oss iwlegacy snd_seq_midi tpm_infineon snd_rawmidi snd_seq_midi_event mac80211 snd_seq usbhid snd_timer pcmcia hid snd_seq_device cfg80211 coretemp yenta_socket hp_wmi irda pcmcia_rsrc snd sparse_keymap microcode joydev psmouse pcmcia_core tifm_7xx1 parport_pc rfkill tpm_tis soundcore tifm_core crc_ccitt tpm evdev parport pcspkr rng_core hp_accel snd_page_alloc serio_raw tpm_bios acpi_cpufreq lis3lv02d container battery wmi ac input_polldev video mperf power_supply processor button ext2 mbcache dm_mod btrfs zlib_deflate crc32c libcrc32c usb_storage sg sd_mod sr_mod cdrom crc_t10dif ata_generic pata_acpi ata_piix libata uhci_hcd scsi_mod ide_pci_generic ide_core ehci_hcd sdhci_pci sdhci mmc_core usbcore usb_common tg3 libphy fan thermal thermal_sys [last unloaded: scsi_wait_scan]
[619141.143003] Pid: 13035, comm: hald-probe-volu Not tainted 3.4.89-kernel.org-jlm-010-amd64 #1
[619141.143007] Call Trace:
[619141.143018]  [<ffffffff8105275f>] warn_slowpath_common+0x7f/0xc0
[619141.143024]  [<ffffffff810527ba>] warn_slowpath_null+0x1a/0x20
[619141.143029]  [<ffffffff8125e12f>] disk_clear_events+0x11f/0x130
[619141.143039]  [<ffffffff811c1461>] check_disk_change+0x31/0x80
[619141.143051]  [<ffffffffa01a0215>] sd_open+0xb5/0x1f0 [sd_mod]
[619141.143058]  [<ffffffff811c0a71>] __blkdev_get+0x341/0x4b0
[619141.143064]  [<ffffffff8125ec79>] ? disk_get_part+0x19/0xa0
[619141.143071]  [<ffffffff811c0924>] __blkdev_get+0x1f4/0x4b0
[619141.143076]  [<ffffffff811c0f70>] ? blkdev_get+0x390/0x390
[619141.143081]  [<ffffffff811c0c34>] blkdev_get+0x54/0x390
[619141.143086]  [<ffffffff811c0f70>] ? blkdev_get+0x390/0x390
[619141.143093]  [<ffffffff814c5619>] ? sub_preempt_count+0xa9/0xe0
[619141.143098]  [<ffffffff811c0f70>] ? blkdev_get+0x390/0x390
[619141.143103]  [<ffffffff814c17d5>] ? _raw_spin_unlock+0x35/0x60
[619141.143109]  [<ffffffff811c0f70>] ? blkdev_get+0x390/0x390
[619141.143114]  [<ffffffff811c0fe1>] blkdev_open+0x71/0x90
[619141.143120]  [<ffffffff81185213>] __dentry_open+0x2c3/0x3d0
[619141.143125]  [<ffffffff81185421>] nameidata_to_filp+0x71/0x80
[619141.143132]  [<ffffffff81194c88>] do_last+0x3f8/0x840
[619141.143137]  [<ffffffff811963b9>] path_openat+0xd9/0x3e0
[619141.143144]  [<ffffffff8101cce9>] ? sched_clock+0x9/0x10
[619141.143150]  [<ffffffff8108c2bf>] ? local_clock+0x6f/0x80
[619141.143156]  [<ffffffff811967d9>] do_filp_open+0x49/0xa0
[619141.143161]  [<ffffffff814c5619>] ? sub_preempt_count+0xa9/0xe0
[619141.143166]  [<ffffffff814c17d5>] ? _raw_spin_unlock+0x35/0x60
[619141.143173]  [<ffffffff811a4915>] ? alloc_fd+0x105/0x130
[619141.143178]  [<ffffffff8118650a>] do_sys_open+0x10a/0x1f0
[619141.143183]  [<ffffffff81186631>] sys_open+0x21/0x30
[619141.143189]  [<ffffffff814c9169>] system_call_fastpath+0x16/0x1b
[619141.143193] ---[ end trace 809f92614ebeaf75 ]---



--Multipart=_Fri__16_May_2014_17_30_00_-0400_z59tagkgdEQnMgC1--
