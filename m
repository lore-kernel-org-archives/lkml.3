Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab3LDQiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:38:52 -0500
Received: from multi.imgtec.com ([194.200.65.239]:9590 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab3LDQiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:38:50 -0500
Message-ID: <529F5A95.9050307@imgtec.com>
Date: Wed, 4 Dec 2013 16:38:45 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-metag@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, <linux-arch@vger.kernel.org>
Subject: Re: [RFC PATCH v3 10/19] smp, metag: kill SMP single function call
 interrupt
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com> <1386173591-28514-11-git-send-email-liuj97@gmail.com>
In-Reply-To: <1386173591-28514-11-git-send-email-liuj97@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_04_16_38_46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/13 16:13, Jiang Liu wrote:
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one intterupt

s/intterupt/interrupt/

> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

Acked-by: James Hogan <james.hogan@imgtec.com>

Do you want me to take this patch through the metag tree for v3.14 or
let it go via another tree with the other patches?

Thanks
James

