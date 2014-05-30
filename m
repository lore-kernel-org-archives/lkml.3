Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934321AbaE3UIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:08:17 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64123 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030517AbaE3UHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:07:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405301528530.17310@knanqh.ubzr>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
 <53888719.70604@arm.com> <CAKfTPtDWd5FKqSemFMFMMPz+t+aEnHWL_WH5grRoegtGnfD+bw@mail.gmail.com>
 <alpine.LFD.2.11.1405301528530.17310@knanqh.ubzr>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 30 May 2014 22:07:18 +0200
Message-ID: <CAKfTPtCuw4Gs5g-ujWzK3LEKz3UO7kd4tKsbXruE69md6iF60g@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher capacity
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 21:45, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Fri, 30 May 2014, Vincent Guittot wrote:
>
>> On 30 May 2014 15:26, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>> >> +     /*
>> >> +      * The group capacity is reduced probably because of activity from other
>> >
>> > Here 'group capacity' refers to sgs->group_power and not to
>> > sgs->group_capacity, right?
>>
>> yes, you're right it's cpu_power, i will correct the comment
>
> Note that peterz applied my rename patches so sgs->group_power has
> become sgs->group_capacity.

I will update the naming in the next version when i will rebase

Vincent

>
>
> Nicolas
