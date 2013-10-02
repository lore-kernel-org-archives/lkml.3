Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3JBFyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:54:51 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:43076 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3JBFyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:54:49 -0400
Date: Wed, 2 Oct 2013 07:54:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "#3.9.." <stable@vger.kernel.org>, Paul Mackerras <paulus@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL v2] irq fix for 3.12-rc
Message-ID: <20131002055437.GB31122@gmail.com>
References: <1380552959-9396-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFy5YJkchyfCjbCKLGQMo34wcba9AVr2JMNPXZa5vKNT3g@mail.gmail.com>
 <20130930165059.GA9889@localhost.localdomain>
 <20131001065516.GA19718@gmail.com>
 <20131001110355.GA24825@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001110355.GA24825@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > Yeah, I did such things sporadically before. Well, it summed up to 
> > > simply remove the timestamps from backtraces but yeah, then I've 
> > > become less patient about that and now I simply paste the raw thing.
> > > 
> > > I'll take care of that and prune these things on my future patches.
> > 
> > Mind fixing your commit log in this tree? The raw oops really 
> > dominates the changelog unnecessarily.
> 
> Ok so I made a new branch that cleans that up by removing the printk 
> time column and the ip column that were all irrelevant.
> 
> I onlt kept the stack pointer value column, which I think is still very 
> useful because it shows we deal with the same stack throughout the whole 
> call trace.
> 
> And of course the functions symbols.
> 
> Here is the new changelog below. The new pullable branch is 
> irq/urgent-v2

Pulled, thanks a lot Frederic!

	Ingo
