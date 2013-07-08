Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3GHIjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:39:19 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37689 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3GHIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:39:18 -0400
Date: Mon, 8 Jul 2013 10:39:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
Message-ID: <20130708083914.GB3948@gmail.com>
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
 <20130626122408.GJ28407@twins.programming.kicks-ass.net>
 <20130626155325.GB7399@gmail.com>
 <51CB4328.7010006@oracle.com>
 <20130627090722.GC4398@gmail.com>
 <51CC4461.50207@oracle.com>
 <51DA127E.3040706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DA127E.3040706@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> >> The other issue is that with lock classes disabled you have to hit an 
> >> actual deadlock to trigger any output.
> >>
> >> I.e. much of the power of lockdep is diminished :-/ When actual 
> >> deadlocks are triggered then it's not particularly complex to debug 
> >> user-space apps: gdb the hung task(s) and look at the backtraces.
> >
> > Lock classes are disabled only if you're using the LD_PRELOAD method 
> > of testing. If you actually re-compile your code with the library (by 
> > just including the header and setting a #define to enable it) you will 
> > have lock classes.
> 
> Hi Ingo,
> 
> Just wondering if you're planning on pushing it over to Linus from your 
> tree, or should I go ahead and do it on my own?

PeterZ is in favor as well so I'll apply them after the merge window, for 
v3.12.

Thanks,

	Ingo
