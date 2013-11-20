Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3KTR04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:26:56 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:55131 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3KTR0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:26:54 -0500
Date: Wed, 20 Nov 2013 18:26:49 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: sclark46@earthlink.net
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: i915 driver gpu hung kernel 3.11
Message-ID: <20131120182649.1f2bd411@neptune.home>
In-Reply-To: <528B5581.8040006@earthlink.net>
References: <52896862.5000300@earthlink.net>
	<20131118184107.67d6c875@neptune.home>
	<528B5581.8040006@earthlink.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 19 November 2013 Stephen Clark <sclark46@earthlink.net> wrote:
> Thanks for the response. I have subscribed to the intel-gfx list. I didn't post 
> the error_state file since it huge.

It's best to submit a but report on bugs.freedesktop.org and attach the
error_state there (compressed if needed) - repeating the information you
provided in this thread.

Without the error_state chances of getting some developer look at it and
have a chance of understanding the cause are small. If they can reproduce
it's a bonus.

Once you have done so, replying with a reference to the bug might help
people who find your report in mailing list archives.

Bruno

> I was trying to play Myst Online using wine-1.3.24. I get started and start 
> moving my avatar fairly
> quickly I get the error.
> 
> I have built the latest X, mesa etc from the git repo and loaded the latest 
> kernel but still have the problem,
> though now my screen doesn't lose horizontal sync like it used to before I 
> uppgraded X etc.
> 
> Below is a lspci of my laptop.
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT 
> Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 
> 943/940GML Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML 
> Express Integrated Graphics Controller (rev 03)
> 00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio 
> Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 3 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller 
> #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller 
> #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller 
> #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller 
> #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller 
> (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge 
> (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE 
> Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 02)
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] 
> Network Connection (rev 02)
> 05:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
> 05:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host 
> Adapter (rev 19)
> 05:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 01)
> 05:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter 
> (rev 0a)
> 05:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC 
> Gigabit Ethernet (rev 10)
> 
> 
> On 11/18/2013 12:41 PM, Bruno Prémont wrote:
> > Hi Stephen,
> >
> > You may want to CC intel-gfx@lists.freedesktop.org  for i915 issues (even
> > if you are not subscribed and you mail will wait for a moderator to let
> > it go through).
> >
> > In case of intel GPU hangs you should at least include
> > /sys/kernel/debug/dri/0/i915_error_state, probably submitting as a
> > bug report on bugs.freedesktop.org due to its size.
> >
> > If you have any indication on what triggers the hang, please add!
> >
> > Bruno
> >
> > On Sun, 17 November 2013 Stephen Clark<sclark46@earthlink.net>  wrote:
> >> Hi List,
> >>
> >> I am getting this in kernel 3.11 x86_64
> >>
> >> Nov 17 18:56:19 joker4 kernel: [drm:i915_hangcheck_elapsed] *ERROR* stuck on
> >> render ring
> >> Nov 17 18:56:19 joker4 kernel: [drm] capturing error event; look for more
> >> information in /sys/kernel/debug/dri/0/i915_error_state
> >> Nov 17 18:56:19 joker4 kernel: swapper/1: page allocation failure: order:6,
> >> mode:0x200020
> >> Nov 17 18:56:19 joker4 kernel: CPU: 1 PID: 0 Comm: swapper/1 Not tainted
> >> 3.11.6-1.el6.elrepo.x86_64 #1
> >> Nov 17 18:56:19 joker4 kernel: Hardware name: To Be Filled By O.E.M. Z96F/Z96F,
> >> BIOS 080012  08/29/2006
> >> Nov 17 18:56:19 joker4 kernel: 0000000000000006 ffff8800b73038e0
> >> ffffffff815f7f89 0000000000000010
> >> Nov 17 18:56:19 joker4 kernel: 0000000000200020 ffff8800b7303970
> >> ffffffff8114243d ffff8800b778ab28
> >> Nov 17 18:56:19 joker4 kernel: 0000003000000001 ffff8800b7789000
> >> 0000000000000000 0000000600000002
> >> Nov 17 18:56:19 joker4 kernel: Call Trace:
> >> Nov 17 18:56:19 joker4 kernel:<IRQ>   [<ffffffff815f7f89>] dump_stack+0x49/0x60
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8114243d>] warn_alloc_failed+0xfd/0x160
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8114e98c>] ? wakeup_kswapd+0x10c/0x140
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff811455ae>]
> >> __alloc_pages_slowpath+0x4ae/0x7c0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff81142d9d>] ?
> >> get_page_from_freelist+0x2dd/0x710
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff81145bce>]
> >> __alloc_pages_nodemask+0x30e/0x330
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8118c437>] kmem_getpages+0x67/0x1e0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8118dea9>] fallback_alloc+0x189/0x270
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8118dc55>] ____cache_alloc_node+0x95/0x160
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8118e9b7>] __kmalloc+0x177/0x2c0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffffa0044a29>] ?
> >> i915_capture_error_state+0x379/0x720 [i915]
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffffa0044a29>]
> >> i915_capture_error_state+0x379/0x720 [i915]
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffffa0044dfb>] i915_handle_error+0x2b/0x80
> >> [i915]
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffffa004511e>]
> >> i915_hangcheck_elapsed+0x2ce/0x350 [i915]
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8101b019>] ? sched_clock+0x9/0x10
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8109d905>] ? sched_clock_local+0x25/0x90
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff814711f0>] ? usb_add_hcd+0x3d0/0x3d0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffffa0044e50>] ?
> >> i915_handle_error+0x80/0x80 [i915]
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff81073b19>] call_timer_fn+0x49/0x120
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8107470b>] run_timer_softirq+0x23b/0x2a0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff812b2660>] ? timerqueue_add+0x60/0xb0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffffa0044e50>] ?
> >> i915_handle_error+0x80/0x80 [i915]
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8106c147>] __do_softirq+0xf7/0x270
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8108e0c3>] ? hrtimer_interrupt+0x163/0x260
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff81606adc>] call_softirq+0x1c/0x30
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff81015885>] do_softirq+0x65/0xa0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8106be75>] irq_exit+0xc5/0xd0
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff8160757a>]
> >> smp_apic_timer_interrupt+0x4a/0x5a
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff81605e1d>] apic_timer_interrupt+0x6d/0x80
> >> Nov 17 18:56:19 joker4 kernel:<EOI>   [<ffffffff810bb1aa>] ?
> >> cpu_idle_loop+0x10a/0x210
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff810bb17c>] ? cpu_idle_loop+0xdc/0x210
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff810bb320>] cpu_startup_entry+0x70/0x80
> >> Nov 17 18:56:19 joker4 kernel: [<ffffffff810437bd>] start_secondary+0xcd/0xd0
> >> Nov 17 18:56:19 joker4 kernel: SLAB: Unable to allocate memory on node 0 (gfp=0x20)
> >> Nov 17 18:56:19 joker4 kernel:  cache: kmalloc-262144, object size: 262144, order: 6
> >> Nov 17 18:56:19 joker4 kernel:  node 0: slabs: 0/0, objs: 0/0, free: 0
> >> Nov 17 18:56:19 joker4 kernel: [drm:i915_set_reset_status] *ERROR* render ring
> >> hung inside bo (0x85c000 ctx 0) at 0x85c97c
> >>
> >> is this fixed in 3.12?
> >>
> >> Just checked get the same thing in 3.12 but no trace back.
> >>
> >>
> >> Nov 17 19:41:33 joker4 kernel: [drm] stuck on render ring
> >> Nov 17 19:41:33 joker4 kernel: [drm] capturing error event; look for more
> >> information in /sys/class/drm/card0/error
> >> Nov 17 19:41:33 joker4 kernel: [drm:i915_set_reset_status] *ERROR* render ring
> >> hung inside bo (0x7214000 ctx 0) at 0x72142e0
> >> Nov 17 19:41:33 joker4 kernel: [drm:i915_reset] *ERROR* Failed to reset chip.
