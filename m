Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016AbaCSM3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:29:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35740 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbaCSM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140319115904.GJ27632@laptop.programming.kicks-ass.net>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-6-git-send-email-vincent.guittot@linaro.org> <20140319115904.GJ27632@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 19 Mar 2014 13:28:50 +0100
Message-ID: <CAKfTPtD-_u6WsiV_NJmJxe3iqL_Vw6Xu8wtkgGsB3yAFpbdbKg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
To: Peter Zijlstra <peterz@infradead.org>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 12:59, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Mar 18, 2014 at 06:56:47PM +0100, Vincent Guittot wrote:
>
>
>> @@ -5946,7 +5948,8 @@ static int sched_domains_curr_level;
>>       (SD_SHARE_CPUPOWER |            \
>>        SD_SHARE_PKG_RESOURCES |       \
>>        SD_NUMA |                      \
>> -      SD_ASYM_PACKING)
>> +      SD_ASYM_PACKING |              \
>> +      SD_SHARE_POWERDOMAIN)
>
> You forgot to update the pretty comment above that :-)

yes, i'm going to update it

>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
