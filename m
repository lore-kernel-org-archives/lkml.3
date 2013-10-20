Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3JTIuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 04:50:39 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44338 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3JTIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 04:50:37 -0400
Date: Sun, 20 Oct 2013 10:50:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched/fair.c: remove kernel-doc warning
Message-ID: <20131020085034.GC16236@gmail.com>
References: <5263001C.1060109@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5263001C.1060109@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Remove @balance parameter that is no longer used in the function to
> remove a kernel-doc warning.
> 
> Warning(kernel/sched/fair.c:4704): Excess function parameter 'balance' description in 'update_sd_lb_stats'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  kernel/sched/fair.c |    1 -

I think that should be solved already by this pending tip:sched/core 
commit:

 62e947cb0cd2 sched: Remove bogus parameter in structured comment

Thanks,

	Ingo
