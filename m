Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab3BBEdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 23:33:13 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:45181 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab3BBEdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 23:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <1359774864.1666.30.camel@anish-Inspiron-N5050>
References: <1351933030-1462-1-git-send-email-anish198519851985@gmail.com>
	<CAFTL4hx8JRft0Xy02vRdOQptNcTA1TxhB+x_pzRphMxqUDgBMA@mail.gmail.com>
	<1359774864.1666.30.camel@anish-Inspiron-N5050>
Date: Sat, 2 Feb 2013 05:33:09 +0100
Message-ID: <CAFTL4hwoVRewqjLpYL8UQQ6oFHYiebxOramx9u_pX9C4KQVvjg@mail.gmail.com>
Subject: Re: [PATCH] IRQ CORE: irq_work_queue function return value not used.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/2 anish kumar <anish198519851985@gmail.com>:
> On Sat, 2013-01-26 at 17:24 +0100, Frederic Weisbecker wrote:
>> 2012/11/3 anish kumar <anish198519851985@gmail.com>:
>> > From: anish kumar <anish198519851985@gmail.com>
>> >
>> > As no one is using the return value of irq_work_queue function
>> > it is better to just make it void.
>> >
>> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
>> > Signed-off-by: anish kumar <anish198519851985@gmail.com>
>> > ---
>> >  kernel/irq_work.c |    5 ++---
>> >  1 files changed, 2 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/kernel/irq_work.c b/kernel/irq_work.c
>> > index 1588e3b..4829a31 100644
>> > --- a/kernel/irq_work.c
>> > +++ b/kernel/irq_work.c
>> > @@ -79,17 +79,16 @@ static void __irq_work_queue(struct irq_work *work)
>> >   *
>> >   * Can be re-enqueued while the callback is still in progress.
>> >   */
>> > -bool irq_work_queue(struct irq_work *work)
>> > +void irq_work_queue(struct irq_work *work)
>>
>> Please also update the headers in include/linux/irq_work.h accordingly.
> I have sent the patch again(some time back).Is it picked up?
> http://www.gossamer-threads.com/lists/linux/kernel/1667796

Yep, I'm applying it and if it passes basic tests I'll relay it to Ingo.

Thanks.
