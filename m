Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbaD2Jf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:35:58 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:37544 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbaD2Jfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:35:55 -0400
Message-ID: <535F71EA.6070604@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 15:03:30 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V3 1/2] mm: move FAULT_AROUND_ORDER to arch/
References: <1398675690-16186-1-git-send-email-maddy@linux.vnet.ibm.com> <1398675690-16186-2-git-send-email-maddy@linux.vnet.ibm.com> <20140428090649.GD27561@twins.programming.kicks-ass.net>
In-Reply-To: <20140428090649.GD27561@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042909-6102-0000-0000-000005776C98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 April 2014 02:36 PM, Peter Zijlstra wrote:
> On Mon, Apr 28, 2014 at 02:31:29PM +0530, Madhavan Srinivasan wrote:
>> +unsigned int fault_around_order = CONFIG_FAULT_AROUND_ORDER;
> 
> __read_mostly?
> 
Agreed. Will add it.

Thanks for review.
With regards
Maddy

