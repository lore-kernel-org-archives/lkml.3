Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaCCWPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:15:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:4626 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbaCCWPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:15:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,580,1389772800"; 
   d="scan'208";a="465937362"
Message-ID: <5314FEF3.70908@linux.intel.com>
Date: Tue, 04 Mar 2014 06:15:15 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/2] x86: IOSF: Add loadable module support
References: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com> <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com> <531428D9.1060101@linux.intel.com> <20140303155850.GA2879@linux.intel.com>
In-Reply-To: <20140303155850.GA2879@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/3 23:58, David E. Box wrote:
> On Mon, Mar 03, 2014 at 03:01:45PM +0800, Li, Aubrey wrote:
>> Hi David,
>>
>> I'm probably too late to catch this thread. Just one question, what's
>> the relationship between
>> 	arch/x86/kernel/iosf_mbi.c
>> and
>> 	drivers/platform/x86/intel_baytrail.c
>>
> iosf_mbi.c is the version that went upstream, no longer specific to baytrail.

Then should we remove the latter?

Thanks,
-Aubrey

> 
> david box
> 
> 

