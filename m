Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab3GRLAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:00:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:55486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770Ab3GRLAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:00:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="347708597"
Message-ID: <51E7CABD.3040105@intel.com>
Date: Thu, 18 Jul 2013 19:00:13 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com> <51E77F90.3040007@intel.com> <20130718084249.GD27075@twins.programming.kicks-ass.net>
In-Reply-To: <20130718084249.GD27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 04:42 PM, Peter Zijlstra wrote:
> On Thu, Jul 18, 2013 at 01:39:28PM +0800, Yan, Zheng wrote:
>> On 07/18/2013 01:36 PM, Yan, Zheng wrote:
>>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>>
>>> Compare to old atom, Silvermont has offcore and has more events
>>> that support PEBS.
>>>
>>> Silvermont has two offcore response configuration MSRs, but the
>>> event code for OFFCORE_RSP_1 is 0x02b7. To avoid complicating
>>> intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to define offcore
>>> MSRs. So intel_fixup_er() can find the code for OFFCORE_RSP_1
>>> by x86_pmu.extra_regs[1].event.
>>>
>>
>> Document is at http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf, but it has no PEBS event list.
> 
> Why isn't this in the regular SDM like all the other stuff?
> 

I don't know, probably they still haven't finished the document yet. (above PDF has no PEBS event list). 

