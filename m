Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaJJHSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:18:54 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:40290 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaJJHSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:18:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtCQzdDuNmifU3sobqSke0Mri0jDVpJTwuKytaNs_RLM1w@mail.gmail.com>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org>
 <20141009121643.GQ4750@worktop.programming.kicks-ass.net> <CAKfTPtCX687FkGgxLO7spfGvDxhDWeFDERLRZ-NakO2Jrpmnhw@mail.gmail.com>
 <20141009151820.GX10832@worktop.programming.kicks-ass.net> <CAKfTPtCQzdDuNmifU3sobqSke0Mri0jDVpJTwuKytaNs_RLM1w@mail.gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 10 Oct 2014 09:18:23 +0200
Message-ID: <CAKfTPtATuTWSU+R289Q8qpVR4b+D1HdrKjKHZNz7b_ahAiWOWA@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 October 2014 09:17, Vincent Guittot <vincent.guittot@linaro.org> wrote:
>
> yes i think it latter because it give a more stable view of the

s/latter/matter/

> "overload state" and "have  free capacity state" of the CPU.
> One additional point is that the imbalance_pct will ensure that a
> cpu/group will not been seen as having capacity if its available
> capacity is only 1-5% which will generate spurious task migration
>
> I will add these details in the commit log and in a comment in the code
