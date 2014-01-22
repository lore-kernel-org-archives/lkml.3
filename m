Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaAVNuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:50:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbaAVNuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:50:19 -0500
Message-ID: <52DFCC79.6080402@redhat.com>
Date: Wed, 22 Jan 2014 14:49:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Michael wang <wangyun@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show soft lockup while running multiple
 VM
References: <52DF8101.6020903@linux.vnet.ibm.com> <20140122123643.GO31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140122123643.GO31570@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/01/2014 13:36, Peter Zijlstra ha scritto:
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
>

Yes, looks like the same thing.  Thanks Peter.

Paolo
