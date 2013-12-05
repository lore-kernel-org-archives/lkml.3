Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab3LEQbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:31:42 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33763 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab3LEQbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:31:39 -0500
Message-ID: <52A0AA5D.7080407@gmail.com>
Date: Fri, 06 Dec 2013 00:31:25 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-metag@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v3 10/19] smp, metag: kill SMP single function call
 interrupt
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com> <1386173591-28514-11-git-send-email-liuj97@gmail.com> <529F5A95.9050307@imgtec.com>
In-Reply-To: <529F5A95.9050307@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 12:38 AM, James Hogan wrote:
> On 04/12/13 16:13, Jiang Liu wrote:
>> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
>> similar to smp_call_function_single()" has unified the way to handle
>> single and multiple cross-CPU function calls. Now only one intterupt
> 
> s/intterupt/interrupt/
> 
>> is needed for architecture specific code to support generic SMP function
>> call interfaces, so kill the redundant single function call interrupt.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Shaohua Li <shli@kernel.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Jiri Kosina <trivial@kernel.org>
>> Cc: James Hogan <james.hogan@imgtec.com>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> 
> Acked-by: James Hogan <james.hogan@imgtec.com>
> 
> Do you want me to take this patch through the metag tree for v3.14 or
> let it go via another tree with the other patches?
Thanks for review. Appreciate if you could help to merge this patch
through metag gate.


> 
> Thanks
> James
> 

