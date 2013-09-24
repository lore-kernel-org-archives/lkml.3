Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3IXPpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:45:38 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:40203 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754309Ab3IXPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:45:37 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 11:45:37 EDT
Date: Tue, 24 Sep 2013 15:35:26 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu
 ops
In-Reply-To: <20130924151847.GB8494@gmail.com>
Message-ID: <00000141509c4346-586ca654-989b-4a6a-ae30-592d2f8f11a8-000000@email.amazonses.com>
References: <20130923191256.584672290@linux.com> <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com> <20130924080347.GH28538@gmail.com> <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
 <20130924151847.GB8494@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.24-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Ingo Molnar wrote:

> > No he did not. He mentioned something about debug_smp_processor_id() at
> > the end of a post after talking about something else. Given your
> > comments now I see what was meant. That was not really obvious in the
> > first place.
>
> Holy cow, this is what PeterZ wrote to you a week ago:
>
>      > +#ifdef CONFIG_PREEMPT
>      > +extern void this_cpu_preempt_check(void);
>      > +#else
>      > +static inline void this_cpu_preempt_check(void) { }
>      > +#endif
>
>      How about re-using debug_smp_processor_id() instead?
>
> Firstly, that sentence is as damn obvious as it gets.

No its not. This is a side comment and did not explain in detail what was
intended. There was another issue mentioned there. You did that in your
dysfunctional communication.

> Pointing out your repeated lack of cooperation in this matter is a
> statement of facts, not an 'insulting behavior'. Your wasting of other
> people's time is simply not acceptable.
>
> That I called you out on it might be embarrassing to you but there's a
> really easy solution to that: implement reviewer and maintainer requests
> and don't send sloppy patches repeatedly.

What is embarrasing here is your behavior. Usually I do not respond to
this kind of crap because its obvious that it is just that and it needs
to stand there for all to see not requiring a response.

And the patches were repeatedly send to you as well. You could have said
something earlier too when you realized that I did not note Peter's
comment.
