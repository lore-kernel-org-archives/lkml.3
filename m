Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbaJVMfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:35:30 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42579 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaJVMf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:35:29 -0400
Date: Wed, 22 Oct 2014 14:35:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
Message-ID: <20141022123523.GA24499@gmail.com>
References: <20141020215633.717315139@infradead.org>
 <20141021162340.GA5508@gmail.com>
 <20141021172527.GH3219@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021172527.GH3219@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Oct 21, 2014 at 06:23:40PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > My Ivy Bridge EP (2*10*2) has a ~58% improvement in pagefault throughput:
> > > 
> > > PRE:
> > >        149,441,555      page-faults                  ( +-  1.25% )
> > >
> > > POST:
> > >        236,442,626      page-faults                  ( +-  0.08% )
> > 
> > > My Ivy Bridge EX (4*15*2) has a ~78% improvement in pagefault throughput:
> > > 
> > > PRE:
> > >        105,789,078      page-faults                 ( +-  2.24% )
> > >
> > > POST:
> > >        187,751,767      page-faults                 ( +-  2.24% )
> > 
> > I guess the 'PRE' and 'POST' numbers should be flipped around?
> 
> Nope, its the number of page-faults serviced in a fixed amount of time
> (60 seconds), therefore higher is better.

Ah, okay!

Thanks,

	Ingo
