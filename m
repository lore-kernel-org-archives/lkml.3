Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbaGIP03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:26:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34630 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730AbaGIP0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:26:24 -0400
Message-ID: <53BD5F0C.2050509@ti.com>
Date: Wed, 9 Jul 2014 11:26:04 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH 09/14] cpufreq: cpu0: Move per-cluster initialization
 code to ->init()
References: <cover.1404231535.git.viresh.kumar@linaro.org>	<b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>	<53BD576F.2010408@ti.com> <CAKohpokz4eyw86Uxp_aA=9T9x-X=kTV=_=zx4dEuC2ZyR=3pKw@mail.gmail.com>
In-Reply-To: <CAKohpokz4eyw86Uxp_aA=9T9x-X=kTV=_=zx4dEuC2ZyR=3pKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 11:17 AM, Viresh Kumar wrote:
> On 9 July 2014 20:23, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> I scanned this patch and subsequent patches from the series. Since you are
>> modifying the interfaces and bindings, I just think its better if we can
>> address the cases where separate clock lines will be used by CPUs.
>>
>> Surely don't want to increase your work neither want hold the progress
>> of the series but if you look at the changes to the interfaces, they
>> give you a feeling of incompleteness.
> 
> Lets talk in the other thread you raised, 2/14 ..
> 
>>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>> ---
>> Would you able to give some idea about what will it take to address that one
>> remainder case as well as part of this series.
> 
> Which one? This:
> 
>> We still *don't* support platforms with separate clock/voltage lines for CPUs.
>> This would be done in a separate patch.
> 
> Its already fixed as part of this series.
> 
I suggest you word the commit in that case. Saying subsequent patch
adds support for the remainder case. Let me scan the remainder
patches again to see how its done.

Regards,
Santosh
