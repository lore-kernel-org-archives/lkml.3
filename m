Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab3EAKKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:10:12 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59030 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3EAKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:10:08 -0400
Date: Wed, 1 May 2013 12:10:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
Message-ID: <20130501101004.GA17360@gmail.com>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
 <20130501090718.GA28253@dyad.programming.kicks-ass.net>
 <m261z3uipb.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m261z3uipb.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Peter Zijlstra <peterz@infradead.org> writes:
> >
> > So you're saying that if two SMT siblings count the same MEM_*_RETIRED event
> > (on the same counter?) events can get accounted to the wrong sibling?
> 
> It can happen regardless of what event is enabled on the other counter.
> 
> > And when the other sibling doesn't have (the same counter?) enabled we
> > can loose events?
> 
> doesn't have any events enabled.
> 
> > This begs the question what happens when the sibling does have the (same?)
> > counter enabled but counting an all together different event; do we then still
> > 'loose' events from the one sibling and add then to the other counter?
> 
> Yes, that is what the patch fixes.
> 
> Of course only if you actually apply it, and not lose it as usual.

If your snide remark is referring to your pending Haswell patchset then 
you are dead wrong: the reason why they have not been picked up yet is not 
because they were ignored, but because they had to go through 11 review 
iterations already - still counting (!).

That is a huge amount of overhead on the maintainer side.

With such a negative track record you should not expect maintainers to 
fast-track your patches or trust your judgement too much - your patches 
are often sloppy, your changelogs incomplete or outright deceiving, your 
replies are often evasive and non-constructive.

Thanks,

	Ingo
