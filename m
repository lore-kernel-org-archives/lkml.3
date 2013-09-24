Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3IXR0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:26:09 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:33300 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3IXR0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:26:04 -0400
Date: Tue, 24 Sep 2013 19:26:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130924172600.GD10261@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com>
 <20130924080347.GH28538@gmail.com>
 <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
 <20130924151847.GB8494@gmail.com>
 <00000141509c4346-586ca654-989b-4a6a-ae30-592d2f8f11a8-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141509c4346-586ca654-989b-4a6a-ae30-592d2f8f11a8-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 24 Sep 2013, Ingo Molnar wrote:
> 
> > > No he did not. He mentioned something about debug_smp_processor_id() at
> > > the end of a post after talking about something else. Given your
> > > comments now I see what was meant. That was not really obvious in the
> > > first place.
> >
> > Holy cow, this is what PeterZ wrote to you a week ago:
> >
> >      > +#ifdef CONFIG_PREEMPT
> >      > +extern void this_cpu_preempt_check(void);
> >      > +#else
> >      > +static inline void this_cpu_preempt_check(void) { }
> >      > +#endif
> >
> >      How about re-using debug_smp_processor_id() instead?
> >
> > Firstly, that sentence is as damn obvious as it gets.
> 
> No its not. This is a side comment and did not explain in detail what 
> was intended. There was another issue mentioned there. You did that in 
> your dysfunctional communication.

Sorry, if you cannot work it out from that very, clear plain sentence, or 
if you cannot at least ASK what it is about then you have absolutely ZERO 
business modifying core kernel code really...

> > Pointing out your repeated lack of cooperation in this matter is a 
> > statement of facts, not an 'insulting behavior'. Your wasting of other 
> > people's time is simply not acceptable.
> >
> > That I called you out on it might be embarrassing to you but there's a 
> > really easy solution to that: implement reviewer and maintainer 
> > requests and don't send sloppy patches repeatedly.
> 
> What is embarrasing here is your behavior. Usually I do not respond to 
> this kind of crap because its obvious that it is just that and it needs 
> to stand there for all to see not requiring a response.
> 
> And the patches were repeatedly send to you as well. You could have said 
> something earlier too when you realized that I did not note Peter's 
> comment.

I complained about it exactly when I noticed it. I usually don't assume 
that long-time contributors ignore very clear maintainer feedback, so I 
don't always notice such cases straight away.

> > > > Your lack of cooperation is getting ridiculous!
> > >
> > > And this kind of insulting behavior is really discouraging people to 
> > > do work on the kernel.

You can stop playing the victim card: you are not a newbie anymore by any 
definition, you've been hacking the Linux kernel for how long, 10+ years, 
writing hundreds of patches? People expect higher quality series from you 
and you need to learn to address criticism of your workflow as well.

You won't find a _single_ mail in the last 15+ years of lkml where I 
reacted strongly to a newbie being dense or abusive. Newbies can make all 
sorts of mistakes, it's part of the learning process - but after 10 years 
you are not a newbie anymore...

Thanks,

	Ingo
