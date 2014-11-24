Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbaKXAeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:34:19 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44528 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaKXAeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:34:18 -0500
Message-ID: <54727D03.4090909@gmail.com>
Date: Mon, 24 Nov 2014 08:34:11 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 09/11] sched: test the cpu's capacity in wake affine
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-10-git-send-email-vincent.guittot@linaro.org> <20140528105855.GR30445@twins.programming.kicks-ass.net> <CAKfTPtAvFEmAmPMQsEN-=ftudQwd0fHOxq4MRs3HDyHYjLPGZQ@mail.gmail.com>
In-Reply-To: <CAKfTPtAvFEmAmPMQsEN-=ftudQwd0fHOxq4MRs3HDyHYjLPGZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,
On 5/28/14, 7:15 PM, Vincent Guittot wrote:
> On 28 May 2014 12:58, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, May 23, 2014 at 05:53:03PM +0200, Vincent Guittot wrote:
[snip]
>> Now I'm only struggling to understand the rationale for this, its got
>> LLC in there somewhere, but I'm failing to comprehend.
> Ah.. i have probably overestimated the fact that wake_affine was only
> done at MC or SMT level but after reading more deeply the glags
> configuration of all  sched_domain level , my assumption is not true.

What's level the wake_affine should happen?

Regards,
Wanpeng Li

> So I need to test sd flag to make sure that their share their cache at
> this level
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

