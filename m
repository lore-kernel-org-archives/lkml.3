Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaJGRtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:49:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:34513 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaJGRtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:49:33 -0400
Date: Tue, 7 Oct 2014 19:42:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hrtimer deadlock caused by nohz_full
In-Reply-To: <20141007173730.GA12147@redhat.com>
Message-ID: <alpine.DEB.2.11.1410071942100.4292@nanos>
References: <20140925141425.GA21702@redhat.com> <alpine.DEB.2.10.1409251630210.4604@nanos> <20140925234657.GB14870@lerouge> <20141002182409.GA29934@redhat.com> <20141007153024.GA14119@lerouge> <20141007173730.GA12147@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Dave Jones wrote:

> On Tue, Oct 07, 2014 at 05:30:27PM +0200, Frederic Weisbecker wrote:
> 
>  > >  > Right, this patchset fixes it: "[PATCH 0/8] nohz: Fix nohz kick irq work on tick v3"
>  > >  > 
>  > >  > I was about to make the pull request, the branch is acked by peterz.
>  > >  > Would you like to pull it? It's all merge window material.
>  > >  > 
>  > >  > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>  > >  > 	nohz/fixes-v3
>  > > 
>  > > I'm now hitting this with such regularity that it's preventing me from
>  > > tracking down other bugs.  Can we get this merged soon please ?
>  > 
>  > I asked Thomas to pull but he probably missed it. So I did a formal pull request
>  > to Ingo a few days later but he told me that the pull request was made too late
>  > as the merge window was too close. I told him it fixes annoying bugs but that was on IRC
>  > so this probably got lost.

Aarg. Lemme get this done.

Thanks,

	tglx
