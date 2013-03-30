Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab3C3TP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 15:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab3C3TP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 15:15:28 -0400
Date: Sat, 30 Mar 2013 20:12:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, david@fromorbit.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] kthread: implement probe_kthread_data()
Message-ID: <20130330191222.GA31531@redhat.com>
References: <1364612447-6810-1-git-send-email-tj@kernel.org> <1364612447-6810-2-git-send-email-tj@kernel.org> <20130330143600.GA8650@redhat.com> <CAOS58YNOGggVmTazN86HHO7p7uNn78O19AOp0_9NmhjaZheXCg@mail.gmail.com> <20130330170023.GA30835@redhat.com> <CAOS58YNMbTY2fZzUXeyLwuA+nowW2AhgLvQwKf_0jWXDen6HzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YNMbTY2fZzUXeyLwuA+nowW2AhgLvQwKf_0jWXDen6HzQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Tejun Heo wrote:
>
> On Sat, Mar 30, 2013 at 10:00 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> > But I guess I missed the fact that this helper should be safe even this
> > @task can be the a vfork'ed user-space process, yes?
> >
>
> Yeap, we really don't know what to expect.

OK,

> > Or we can add to_live_kthread_safe() which checks "parent == kthreadd_task"
> > instead.
>
> But that would be more fragile than probe_read. I  mean, this thing will be
> called on BUGs and oopses.

OK, I agree.

Sorry for noise and thanks for your explanations, I really missed
the intent.

Oleg.

