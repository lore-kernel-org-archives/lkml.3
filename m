Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaKXNXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:23:35 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64407 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaKXNXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:23:33 -0500
MIME-Version: 1.0
In-Reply-To: <54727D03.4090909@gmail.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-10-git-send-email-vincent.guittot@linaro.org>
 <20140528105855.GR30445@twins.programming.kicks-ass.net> <CAKfTPtAvFEmAmPMQsEN-=ftudQwd0fHOxq4MRs3HDyHYjLPGZQ@mail.gmail.com>
 <54727D03.4090909@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 24 Nov 2014 14:23:12 +0100
Message-ID: <CAKfTPtARJwLXqUaKaTf5wNFK_gMEk8GiY3qerY2oSk=zrZx=tw@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] sched: test the cpu's capacity in wake affine
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2014 at 01:34, Wanpeng Li <kernellwp@gmail.com> wrote:
> Hi Vincent,
> On 5/28/14, 7:15 PM, Vincent Guittot wrote:
>>
>> On 28 May 2014 12:58, Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>> On Fri, May 23, 2014 at 05:53:03PM +0200, Vincent Guittot wrote:
>
> [snip]
>>>
>>> Now I'm only struggling to understand the rationale for this, its got
>>> LLC in there somewhere, but I'm failing to comprehend.
>>
>> Ah.. i have probably overestimated the fact that wake_affine was only
>> done at MC or SMT level but after reading more deeply the glags
>> configuration of all  sched_domain level , my assumption is not true.
>
>
> What's level the wake_affine should happen?

In 1st version of this patch, it was proposed to test the cpu_capacity
of idle CPU only if they were sharing their cache

Regards,
Vincent
>
> Regards,
> Wanpeng Li
>
>> So I need to test sd flag to make sure that their share their cache at
>> this level
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
