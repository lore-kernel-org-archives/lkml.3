Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3IXOYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:24:38 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:38537 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab3IXOYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:24:37 -0400
Date: Tue, 24 Sep 2013 14:24:36 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu
 ops
In-Reply-To: <20130924080347.GH28538@gmail.com>
Message-ID: <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
References: <20130923191256.584672290@linux.com> <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com> <20130924080347.GH28538@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Ingo Molnar wrote:

> During past review of your series Peter Zijlstra very explicitly told you
> to reuse (and unify with) the preempt checks in lib/smp_processor_id.c!
> See debug_smp_processor_id().

No he did not. He mentioned something about debug_smp_processor_id() at
the end of a post after talking about something else. Given your
comments now I see what was meant. That was not really obvious in the
first place.

> The problem isn't just that you are duplicating code and adding
> unnecessary #ifdefs into the wrong place, the bigger problem is that you
> are implementing weak checks which creates unnecessary raw_*() pollution
> all across the kernel.

what kind of idiotic comment is that? I am using a single function
preemptible(). How is that duplicating anything?

> Your lack of cooperation is getting ridiculous!

And this kind of insulting behavior is really discouraging people to do
work on the kernel.
