Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaJGRiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaJGRiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:38:13 -0400
Date: Tue, 7 Oct 2014 13:37:30 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hrtimer deadlock caused by nohz_full
Message-ID: <20141007173730.GA12147@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20140925141425.GA21702@redhat.com>
 <alpine.DEB.2.10.1409251630210.4604@nanos>
 <20140925234657.GB14870@lerouge>
 <20141002182409.GA29934@redhat.com>
 <20141007153024.GA14119@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007153024.GA14119@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:30:27PM +0200, Frederic Weisbecker wrote:

 > >  > Right, this patchset fixes it: "[PATCH 0/8] nohz: Fix nohz kick irq work on tick v3"
 > >  > 
 > >  > I was about to make the pull request, the branch is acked by peterz.
 > >  > Would you like to pull it? It's all merge window material.
 > >  > 
 > >  > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
 > >  > 	nohz/fixes-v3
 > > 
 > > I'm now hitting this with such regularity that it's preventing me from
 > > tracking down other bugs.  Can we get this merged soon please ?
 > 
 > I asked Thomas to pull but he probably missed it. So I did a formal pull request
 > to Ingo a few days later but he told me that the pull request was made too late
 > as the merge window was too close. I told him it fixes annoying bugs but that was on IRC
 > so this probably got lost.
 > 
 > It will probably be delayed to 3.18
 > Sorry I don't have much control myself on merging patches upstream.

I got fed up of hitting it this morning and pull this into 3.17, and got
a bunch of rejects, as that tree is against rc5.  Is there an updated
patchset somewhere else?

	Dave

