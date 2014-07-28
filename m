Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaG1IGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:06:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:30347 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaG1IF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:05:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="scan'208";a="576406448"
Message-ID: <53D60459.8040702@intel.com>
Date: Mon, 28 Jul 2014 16:05:45 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH] perf/x86/uncore: split Intel uncore driver to smaller
 files
References: <1406277655-21808-1-git-send-email-zheng.z.yan@intel.com> <20140728075623.GP19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140728075623.GP19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 03:56 PM, Peter Zijlstra wrote:
> On Fri, Jul 25, 2014 at 04:40:55PM +0800, Yan, Zheng wrote:
>> split Intel uncore driver into four files:
>>  - perf_event_intel_uncore.c: general functions of Intel uncore driver.
>>  - perf_event_intel_uncore_nhmex.c: hardware specific code for
>>    Nehalem-EX/Westmere-EX
>>  - perf_event_intel_uncore_snb.c: hardware specific code for
>>    Nehalem/SandBridge/Haswell
>>  - perf_event_intel_uncore_snbep.c: hardware specific code for
>>    SandyBridge-EP/IvyTown uncore
> 
> Did not apply properly to tip/master, also can you do that in 3 patches?
> 

the patch is based on tip/perf/core

> One breaking out the nhm/wsm-ex part, one breaking out the
> nhm/wsm/snb/ivb/hsw bits, and one for the snb/ivb-ep bits?
>
will do

Regards
Yan, Zheng
