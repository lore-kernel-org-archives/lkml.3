Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaCaHbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:31:31 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49559 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaCaHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1403282217070.1571@knanqh.ubzr>
References: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org> <alpine.LFD.2.11.1403282217070.1571@knanqh.ubzr>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 31 Mar 2014 09:31:09 +0200
Message-ID: <CAKfTPtBpjxMeZawC-K6vgvQhpu4Pc2A-jL59XsnPDikEcVUdvQ@mail.gmail.com>
Subject: Re: [RFC 0/4] sched: consolidation of cpu_power
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 March 2014 03:27, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Fri, 28 Mar 2014, Vincent Guittot wrote:
>
>> Part of this patchset was previously part of the larger tasks packing patchset
>> [1]. I have splitted the latter in 3 different patchsets (at least) to make the
>> thing easier.
>> -configuration of sched_domain topology [2]
>> -update and consolidation of cpu_power (this patchset)
>> -tasks packing algorithm
>>
>> SMT system is no more the only system that can have a CPUs with capacity that
>> is different from the default value. We need to extend the use of
>> cpu_power_orig to all kind of platform so the scheduler will have both the
>> maximum capacity (cpu_power_orig/power_orig) and the current capacity
>> (cpu_power/power) of CPUs and groups of the sched_domains.
> [...]
>
> Wouldn't it make sense to have a patch in this series that performs some
> s/power/capacity/ throughout the scheduler code before the other patches
> are applied?  That would help getting consistent terminology and avoid
> confusion before real power related metrics are eventually brought into
> the scheduler.

Fair point. I will add the changes in the next version.

Thanks
Vincent

>
>
> Nicolas
