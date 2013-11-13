Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3KMPoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:44:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab3KMPo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:44:26 -0500
Date: Wed, 13 Nov 2013 16:45:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] sched: Check TASK_DEAD rather than EXIT_DEAD in
	schedule_debug()
Message-ID: <20131113154516.GA15810@redhat.com>
References: <20131113143552.GA10517@redhat.com> <20131113144856.GL26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113144856.GL26898@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13, Peter Zijlstra wrote:
>
> On Wed, Nov 13, 2013 at 03:35:52PM +0100, Oleg Nesterov wrote:
> >
> > As for "nobody should use exit_state". I'll try to recheck, but iirc
> > we already discussed this... do you remember any reason why
> > schedule_debug() can't check prev->state == TASK_DEAD instead of
> > ->exit_state?
>
> I have no such memories :/ but a quick test shows that such a kernel
> does boot without issue.

probably my memory fools me. OK, it seems that you agree with this change,
hopefully we both can't be wrong ;)

> Acked-by: Peter Zijlstra <peterz@infradead.org>

Thanks! And since picked this series, perhaps you can also queue this
one?

Oleg.

