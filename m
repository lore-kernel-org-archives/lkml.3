Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaAWCzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:55:00 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:52247 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaAWCy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:54:59 -0500
Message-ID: <52E08478.2080405@linux.vnet.ibm.com>
Date: Thu, 23 Jan 2014 10:54:48 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show soft lockup while running multiple
 VM
References: <52DF8101.6020903@linux.vnet.ibm.com> <20140122123643.GO31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140122123643.GO31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012302-1396-0000-0000-0000042E399E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 08:36 PM, Peter Zijlstra wrote:
> On Wed, Jan 22, 2014 at 04:27:45PM +0800, Michael wang wrote:
>> # CONFIG_PREEMPT_NONE is not set
>> CONFIG_PREEMPT_VOLUNTARY=y
>> # CONFIG_PREEMPT is not set
> 
> Could you try the patch here:
> 
>   lkml.kernel.org/r/20140122102435.GH31570@twins.programming.kicks-ass.net
> 
> I suspect its the same issue.

Yup, it works.

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

