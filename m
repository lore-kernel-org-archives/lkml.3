Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaFJLO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:14:26 -0400
Received: from mail001.aei.ca ([206.123.6.130]:36698 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaFJLOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:14:25 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Chris Mason <clm@fb.com>, jbacik@fb.com,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs: hang on boot due to tests
Date: Tue, 10 Jun 2014 07:14:17 -0400
Message-ID: <3216820.JOp565CquS@grover>
Organization: me
User-Agent: KMail/4.13.1 (Linux/3.15.0-1-git; KDE/4.13.1; x86_64; ; )
In-Reply-To: <5395DE2E.7080700@oracle.com>
References: <5395CFE6.10804@oracle.com> <5395D9D6.3080101@fb.com> <5395DE2E.7080700@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2014 12:17:50 Sasha Levin wrote:
> On 06/09/2014 11:59 AM, Chris Mason wrote:
> > On 06/09/2014 11:16 AM, Sasha Levin wrote:
> >> > Hi all,
> >> > 
> >> > It seems that some recent changes to btrfs tests make it hang during boot:
> >> > 
> >> > [   49.730033] NMI watchdog: BUG: soft lockup - CPU#34 stuck for 23s! [swapper/0:1]
> >> > [   49.730033] Modules linked in:
> >> > [   49.730033] hardirqs last enabled at (6389143): restore_args (arch/x86/kernel/entry_64.S:829)
> >> > [   49.730033] hardirqs last disabled at (6389144): apic_timer_interrupt (arch/x86/kernel/entry_64.S:1021)
> >> > [   49.730033] softirqs last enabled at (6389142): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
> >> > [   49.730033] softirqs last disabled at (6389139): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
> >> > [   49.730033] CPU: 34 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #597
> > 
> > This is 3.15-rc8 + linux-next?  I'll try to reproduce here, but the
> > tests were working for me.
> 
> Yes, it's the latest -next tree available.
> 
> Also note that it doesn't happen every time, so might be some sort of a race?

I've noticed that with -rc8 and now .15 btrfs fails to automount (or mount) about 1 in 2 times requiring a reboot to get it to work.
I have not seen anything in logs.  Might this be related?

Thanks,

Ed Tomlinson
