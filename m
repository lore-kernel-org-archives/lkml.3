Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaICIl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:41:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47901 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaICIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:41:25 -0400
Message-ID: <5406D42A.8090209@linux.vnet.ibm.com>
Date: Wed, 03 Sep 2014 14:11:14 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v5 04/12] sched: Allow all archs to set the capacity_orig
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org> <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org> <540204DC.5090204@linux.vnet.ibm.com> <CAKfTPtCNPYOi9OY37nbG9o71n4i5mxxvrRow0SgL_9pVK1LpMA@mail.gmail.com>
In-Reply-To: <CAKfTPtCNPYOi9OY37nbG9o71n4i5mxxvrRow0SgL_9pVK1LpMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090308-6688-0000-0000-000004794A65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 01:35 PM, Vincent Guittot wrote:
> On 30 August 2014 19:07, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi Vincent,
>>
>> On 08/26/2014 04:36 PM, Vincent Guittot wrote:
>>> capacity_orig is only changed for system with a SMT sched_domain level in order
>>
>> I think I had asked this before, but why only capacity_orig? The
>> capacity of a group is also being updated the same way. This patch fixes
>> the capacity of a group to reflect the capacity of the heterogeneous
>> CPUs in it, this capacity being both the full capacity of the group:
>> capacity_orig and the capacity available for the fair tasks. So I feel
>> in the subject as well as the changelog it would suffice to say 'capacity'.
> 
> IIRC, we discussed that point on a former version. The patch changes
> only the behavior of capacity_orig but the behavior of capacity stays
> unchanged as all archs can already set the capacity whereas the
> capacity_orig was configurable only if the SD_SHARE_CPUCAPACITY was
> set in the sched_domain. This is no more the case with this patch
> which creates arch_scale_cpu_capacity for setting capacity_orig.

Yes, sorry I overlooked that.

Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>

Regards
Preeti U Murthy

