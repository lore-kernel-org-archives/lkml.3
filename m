Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3BAIvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:51:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39325 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3BAIvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:51:10 -0500
Message-ID: <510B8237.7030605@ti.com>
Date: Fri, 1 Feb 2013 14:22:07 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <linaro-dev@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <rjw@sisk.pl>, <Steve.Bannister@arm.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 3/3] cpufreq: Remove unnecessary use of policy->shared_type
References: <1bf82454ab1f16b13212548d7c9605067c8b7a0d.1359700705.git.viresh.kumar@linaro.org> <902bed453159832925df76e24806f3b919fdfc74.1359700706.git.viresh.kumar@linaro.org> <510B6510.6060608@ti.com> <CAKohponEsSrwLWbi4WJ19i8XkzEiL0De2ShLePBdygunmGEo5g@mail.gmail.com> <510B6FC5.8030309@ti.com> <CAKohpomxi91kXR+th2BbruKigmLPmrDQf1s_Mf11C3Bs53aB3A@mail.gmail.com>
In-Reply-To: <CAKohpomxi91kXR+th2BbruKigmLPmrDQf1s_Mf11C3Bs53aB3A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2013 01:32 PM, Viresh Kumar wrote:
> On 1 February 2013 13:03, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> I am not talking about just notifiers. This is for external users who
>> has subscribed for notifiers. The point is whether the core CPUFReq
>> gets updated without that flag for all affected CPU.
>
> Yes, its safe. Follow this thread, yesterday i explained this to Tomasz Figa:
>
> http://www.spinics.net/lists/arm-kernel/msg221629.html
>
That part was very clear to me Viresh. Anyway thanks for the link.
 From what I read so far, it might just work but I would want to
try it out before acking the approach.

Regards,
Santosh



