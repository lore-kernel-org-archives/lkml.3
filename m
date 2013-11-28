Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3K1JjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:39:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45742 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3K1JjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:39:10 -0500
Date: Thu, 28 Nov 2013 10:38:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
Message-ID: <20131128093858.GI10022@twins.programming.kicks-ass.net>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
 <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
 <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
 <20131121150344.GG10022@twins.programming.kicks-ass.net>
 <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
 <CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
 <alpine.DEB.2.02.1311271902230.5120@chino.kir.corp.google.com>
 <CAE9FiQUVLT3PL3ON_VRrNB6p9TxFU_-X_dkcb6dLvzonmmW7ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUVLT3PL3ON_VRrNB6p9TxFU_-X_dkcb6dLvzonmmW7ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:07:04PM -0800, Yinghai Lu wrote:
> On Wed, Nov 27, 2013 at 7:02 PM, David Rientjes <rientjes@google.com> wrote:
> > On Thu, 21 Nov 2013, Yinghai Lu wrote:
> >
> >> original one in linus's tree:
> >>
> >> [    8.952728] NMI watchdog: enabled on all CPUs, permanently consumes
> >> one hw-PMU counter.
> >> [    8.965697] BUG: unable to handle kernel NULL pointer dereference
> >> at 0000000000000010
> >> [    8.969495] IP: [<ffffffff810d7b53>] update_group_power+0x1d3/0x250
> >
> > This should have been fixed by Srikar's patch, no?
> 
> maybe not related, now in another system, linus's tree + Srikar's patch.

And this another such -EX system? And from what I can tell its during
boot, right?

Totally weird.
