Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3H0QTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:19:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3H0QTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:19:31 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F0my4ousGMIA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8 a=V07Exb4nAAAA:8 a=PYlIwqpHQhItnczddXEA:9 a=CjuIK1q_8ugA:10 a=HtqoY-A-dQYA:10 a=Qbg8LneXD70A:10 a=MSl-tDqOz04A:10 a=6uQODOVjHeUA:10 a=4-xxbH0N3QMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 27 Aug 2013 12:19:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Abhay Sachan <sachan.abhay@gmail.com>
Cc: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kent Overstreet <kmo@daterainc.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>, Carsten Emde <C.Emde@osadl.org>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
Message-ID: <20130827121928.415b620f@gandalf.local.home>
In-Reply-To: <CAFfPn7iqf5EntPKdRO3cFhd=PFostp3mVLGEtt3ksLQHonMhkw@mail.gmail.com>
References: <20130812163413.GI23040@linutronix.de>
	<520D212F.7030400@localhost>
	<20130815152210.5ed93696@gandalf.local.home>
	<520DCE5F.1040402@linutronix.de>
	<521254A0.6050603@localhost>
	<20130819202903.692097ea@gandalf.local.home>
	<5213BC45.6020900@localhost>
	<CAFfPn7iqf5EntPKdRO3cFhd=PFostp3mVLGEtt3ksLQHonMhkw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 01:12:02 +0530
Abhay Sachan <sachan.abhay@gmail.com> wrote:

> Hi All,
> I have installed 3.10.6 kernel on my HP laptop. I keep getting this message
> in dmesg after a few hours of usage. I was getting the similar messages in
> stable-3.9 too.

So this is with vanilla 3.10.6 and not the -rt version?

> 
> 
> 
> [ 3274.234305] ------------[ cut here ]------------
> [ 3274.234332] WARNING: at kernel/workqueue.c:803
> wq_worker_waking_up+0x53/0x70()
> [ 3274.234335] Modules linked in: fuse autofs4 8021q garp stp llc
> cpufreq_ondemand ipv6 dm_mirror dm_region_hash dm_log dm_mod uinput ppdev
> parport_pc parport iTCO_wdt iTCO_vendor_support sg hp_wmi sparse_keymap
> btusb bluetooth tpm_infineon acpi_cpufreq freq_table mperf coretemp
> kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode arc4 iwldvm pcspkr
> mac80211 serio_raw intel_ips lpc_ich mfd_core iwlwifi cfg80211 rfkill
> snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep
> snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc
> e1000e ptp pps_core wmi pata_pcmcia(F) ext4(F) jbd2(F) mbcache(F)
> yenta_socket(F) sdhci_pci(F) sdhci(F) mmc_core(F) firewire_ohci(F)
> firewire_core(F) crc_itu_t(F) sr_mod(F) cdrom(F) sd_mod(F) crc_t10dif(F)
> aesni_intel(F) ablk_helper(F) cryptd(F) lrw(F) gf128mul(F) glue_helper(F)
> aes_x86_64(F) ahci(F) libahci(F) i915(F) drm_kms_helper(F) drm(F)
> i2c_algo_bit(F) i2c_core(F) video(F)
> [ 3274.234474] CPU: 0 PID: 7 Comm: migration/0 Tainted: GF
> 3.10.6 #2
> [ 3274.234477] Hardware name: Hewlett-Packard HP EliteBook 8440p, BIOS
> 68CCU Ver. F.12 03/09/2011
> [ 3274.234489]  ffffffff817caae0 ffff880133389bf8 ffffffff8153af15
> ffff880133389c38
> [ 3274.234495]  ffffffff810414a0 ffff88013060c080 0000000000000003
> ffff880137cd2c80
> [ 3274.234500]  ffff88013060c86c 0000000000000000 0000000000000092
> ffff880133389c48
> [ 3274.234505] Call Trace:
> [ 3274.234523]  [<ffffffff8153af15>] dump_stack+0x19/0x1c
> [ 3274.234531]  [<ffffffff810414a0>] warn_slowpath_common+0x70/0xa0
> [ 3274.234536]  [<ffffffff810414ea>] warn_slowpath_null+0x1a/0x20
> [ 3274.234540]  [<ffffffff8105e273>] wq_worker_waking_up+0x53/0x70

We've been trying to debug this for a while, but we are having trouble
triggering it. If you can download trace-cmd from:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

compile it and install it, and then run:

trace-cmd record -m 100000 -e all -l warn_slowpath_null:traceoff

And let it run till you see that warning again, and then I can set up a
place to send the trace.dat file that's created to me.

Thanks,

-- Steve


> [ 3274.234557]  [<ffffffff8107498e>] ttwu_activate+0x3e/0x50
> [ 3274.234563]  [<ffffffff8107559d>] ttwu_do_activate.clone.0+0x3d/0x60
> [ 3274.234567]  [<ffffffff81078b46>] try_to_wake_up+0x216/0x2b0
> [ 3274.234572]  [<ffffffff81078bf2>] default_wake_function+0x12/0x20
> [ 3274.234585]  [<ffffffff81070229>] __wake_up_common+0x59/0x90
> [ 3274.234590]  [<ffffffff810722d7>] complete+0x47/0x60
> [ 3274.234595]  [<ffffffff81075240>] ? __migrate_task+0x150/0x150
> [ 3274.234604]  [<ffffffff810bc240>] cpu_stopper_thread+0xd0/0x150
> [ 3274.234618]  [<ffffffff8153c921>] ? __schedule+0x3d1/0x6d0
> [ 3274.234623]  [<ffffffff8106f5ed>] smpboot_thread_fn+0xfd/0x180
> [ 3274.234627]  [<ffffffff8106f4f0>] ? smpboot_create_threads+0x80/0x80
> [ 3274.234632]  [<ffffffff8106749e>] kthread+0xce/0xe0
> [ 3274.234637]  [<ffffffff810673d0>] ?
> kthread_freezable_should_stop+0x70/0x70
> [ 3274.234653]  [<ffffffff81546c5c>] ret_from_fork+0x7c/0xb0
> [ 3274.234657]  [<ffffffff810673d0>] ?
> kthread_freezable_should_stop+0x70/0x70
> [ 3274.234661] ---[ end trace fc26accd680695d5 ]---
> [ 3304.064987] Bridge firewalling registered
> [ 3317.239403] nr_pdflush_threads exported in /proc is scheduled for removal
> [ 3317.239550] sysctl: The scan_unevictable_pages sysctl/node-interface has
> been disabled for lack of a legitimate use case.  If you have one, please
> send an email to linux-mm@kvack.org.
> 
