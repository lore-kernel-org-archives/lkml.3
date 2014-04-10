Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbaDJI3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:29:43 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:57194 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832AbaDJI3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:29:39 -0400
Message-ID: <53465669.80701@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2014 13:59:29 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH V2 1/2] mm: move FAULT_AROUND_ORDER to arch/
References: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com> <1396592835-24767-2-git-send-email-maddy@linux.vnet.ibm.com> <533EDB63.8090909@intel.com> <5344A312.80802@linux.vnet.ibm.com> <20140409082008.GA10526@twins.programming.kicks-ass.net> <53456BE2.90905@intel.com>
In-Reply-To: <53456BE2.90905@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041008-2000-0000-0000-000010B3B89C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2014 09:18 PM, Dave Hansen wrote:
> On 04/09/2014 01:20 AM, Peter Zijlstra wrote:
>> This still misses out on Ben's objection that its impossible to get this
>> right at compile time for many kernels, since they can boot and run on
>> many different subarchs.
> 
> Completely agree.  The Kconfig-time stuff should probably just be a knob
> to turn it off completely, if anything.
> 

ok. Here is my thought. So to address Ben's concern, it would be better
to have this as a variable with a default value (and the platform can
override ride it). And a mm/Kconfig to disable it?
Kindly let me know whether this will work.

Thanks for review comments.
With regards
Maddy

