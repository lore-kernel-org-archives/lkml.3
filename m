Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3CVNGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:06:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3CVNGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:06:41 -0400
Date: Fri, 22 Mar 2013 13:59:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
	.patch added to -mm tree
Message-ID: <20130322125900.GA12647@redhat.com>
References: <20130314162413.GA21344@redhat.com> <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com> <20130315134632.GA18335@redhat.com> <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com> <20130315165131.GA32065@redhat.com> <20130317172621.GQ3656@linux.vnet.ibm.com> <20130321170827.GA23539@redhat.com> <1363889025.4431.35.camel@edumazet-glaptop> <20130321183021.GA27586@redhat.com> <1363906618.4431.37.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363906618.4431.37.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Eric Dumazet wrote:
>
> On Thu, 2013-03-21 at 19:30 +0100, Oleg Nesterov wrote:
>
> > To me, it would be better to kill atomic_inc_not_zero_hint() or unify
> > unify it with atomic_inc_not_zero(). But this is another story.
>
> git is your friend.
>
> I suggest you read 3f9d35b9514 changelog before killing it, thanks.

Thanks Eric for your friendly suggestion.

But I didn't mean we should kill this optimization. Yes, I am wondering
if we can avoid inc_not_zero_hint _or_ unify with add_unless. But let me
repeat, this is another story.


Perhaps I misread your previous email... I understood it as if you think
the patch I sent is wrong. No?

If you meant that get_write_access() can predict the current value of
i_writecount... how? And even if we could, why we cant/shouldnt try to
optimize the generic atomic_inc_unless_negative()?

So what did you actually mean?

Oleg.

