Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3GRI1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:27:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:2908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab3GRI1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,691,1367996400"; 
   d="scan'208";a="269976348"
Message-ID: <51E7A6F3.10109@intel.com>
Date: Thu, 18 Jul 2013 16:27:31 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com> <20130718082324.GA27075@twins.programming.kicks-ass.net>
In-Reply-To: <20130718082324.GA27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 04:23 PM, Peter Zijlstra wrote:
> On Thu, Jul 18, 2013 at 01:36:07PM +0800, Yan, Zheng wrote:
>> +static struct event_constraint intel_slm_event_constraints[] __read_mostly =
>> +{
>> +	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
>> +	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
>> +	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
>> +	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
> 
> So the normal event 0x13c and the fixed counter 2 are normally _not_ the
> same. Are they for slm? Are you sure?
> 

yes, I'm sure. see page 15-15 of http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf

Regards
Yan, Zheng

