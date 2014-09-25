Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIYFDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:03:09 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52029 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaIYFDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:03:07 -0400
Date: Thu, 25 Sep 2014 07:03:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/20] arch atomic 'cleanup'
Message-ID: <20140925050301.GC20431@gmail.com>
References: <20140508135840.956784204@infradead.org>
 <20140924165405.GJ16244@arm.com>
 <20140924180623.GY6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924180623.GY6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Sep 24, 2014 at 05:54:06PM +0100, Will Deacon wrote:
> > Hi Peter,
> > 
> > On Thu, May 08, 2014 at 02:58:40PM +0100, Peter Zijlstra wrote:
> > > This series continues the arch atomic rework started with the smp_mb__
> > > interface cleanup.
> > > 
> > > In this series we (mostly) reduce the atomic implementations by eliminating
> > > repetition through use of CPP macros.
> > > 
> > > A future series will use these macros to implement more atomic ops. With these
> > > macros we can end up with more atomic ops while the total LoC still shrinks.
> > > 
> > > Furthermore, rewrite the asm-generic/atomic implementations to require less and
> > > provide more.
> > > 
> > > This series is compile tested on a number of archs, but only boot tested on
> > > x86_64.
> > 
> > What's the status on this series? I'm currently fleshing out 
> > an extension to the atomic API that allows more flexible 
> > acquire/release semantics and it doesn't make sense for me to 
> > copy-paste a bunch of code when I could build it on top of 
> > this instead.
> 
> Its in tip/locking/arch and I suppose its headed for the next 
> merge window.

Correct, there are no known regressions with the tip:locking/arch 
tree so I plan to send those changes to Linus in the merge 
window.

Thanks,

	Ingo
