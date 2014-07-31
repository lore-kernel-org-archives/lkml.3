Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaGaHSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:18:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:35332 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040AbaGaHSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="463472348"
Message-ID: <53D9EDB5.6020304@intel.com>
Date: Thu, 31 Jul 2014 15:18:13 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com> <20140731071625.GA4209@gmail.com>
In-Reply-To: <20140731071625.GA4209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 03:16 PM, Ingo Molnar wrote:
> 
> * Yan, Zheng <zheng.z.yan@intel.com> wrote:
> 
>> This patch series implements large PEBS interrupt threshold. For some
>> limited cases, it can significantly reduce the sample overhead. Please
>> read patch 6's commit message for more information.
>>
>> changes since v1:
>>   - drop patch 'perf, core: Add all PMUs to pmu_idr'
>>   - add comments for case that multiple counters overflow simultaneously
>> changes since v2:
>>   - rename perf_sched_cb_{enable,disable} to perf_sched_cb_user_{inc,dec} 
>>   - use flag to indicate auto reload mechanism
>>   - move codes that setup PEBS sample data to separate function
>>   - output the PEBS records in batch 
>>   - enable this for All (PEBS capable) hardware 
>>   - more description for the multiplex
>> changes since v3:
>>   - ignore conflicting PEBS record
> 
> Please include performance measurements, 'significantly reduces sample 
> overhead' is a totally inadequate description to judge this patch set.

patch 6 contains performance data.

> 
> Please also include total diffstat in the 0/N mail.
> 

will do.

Regards
Yan, Zheng

> Thanks,
> 
> 	Ingo
> 

