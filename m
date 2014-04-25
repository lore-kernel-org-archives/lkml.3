Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaDYOov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:44:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:55338 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaDYOot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="528343501"
Message-ID: <535A74DB.2070709@intel.com>
Date: Fri, 25 Apr 2014 22:44:43 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 4/4] perf/x86/uncore: modularize Intel uncore driver
References: <53548008.3040504@intel.com> <20140422113545.GA14950@gmail.com> <CABPqkBTHv3U6L4fKOvsFcaWR8HcOEaqGGxRMRn-+O68a0BLCuA@mail.gmail.com> <20140424081408.GA7709@gmail.com> <5358E6A2.3020505@intel.com> <CABPqkBRihMr=+X_Gb5dSYfForTpGA6XZGfTHOA3PZNAHTJDPkg@mail.gmail.com> <20140424112715.GQ11096@twins.programming.kicks-ass.net> <535A6070.90803@intel.com> <20140425135549.GF11096@twins.programming.kicks-ass.net> <535A6BD7.4090709@intel.com> <20140425143501.GH11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140425143501.GH11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 10:35 PM, Peter Zijlstra wrote:
> On Fri, Apr 25, 2014 at 10:06:15PM +0800, Yan, Zheng wrote:
>> the uncore driver does not support NHM/WSM-EP (I don't know the module numbers for NHM/WSM-EP, maybe I'm wrong)
> 
> My wsm-ep has /sys/bus/event_source/devices/uncore so I suppose the
> driver loaded. Its model 44 fwiw.
> 
> Also, from the uncore driver:
> 
> 	switch (boot_cpu_data.x86_model) {
> 	case 26: /* Nehalem */
> 	case 30:
> 	case 37: /* Westmere */
> 	case 44:
> 		msr_uncores = nhm_msr_uncores;
> 		break;
> 

looks like the uncore in NHM/WSM-EP is the same as uncore in desktop version NHM/WSM.

Regards
Yan, Zheng


