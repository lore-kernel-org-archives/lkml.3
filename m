Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3LEBnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:43:02 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49475 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3LEBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:42:57 -0500
Date: Wed, 4 Dec 2013 19:42:54 -0600
From: rkuo <rkuo@codeaurora.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v3 07/19] smp, hexagon: kill SMP single function call
 interrupt
Message-ID: <20131205014254.GA3188@codeaurora.org>
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
 <1386173591-28514-8-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386173591-28514-8-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 12:12:58AM +0800, Jiang Liu wrote:
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one intterupt
> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/hexagon/include/asm/smp.h | 1 -
>  arch/hexagon/kernel/smp.c      | 6 +-----
>  2 files changed, 1 insertion(+), 6 deletions(-)

Seems to work fine for Hexagon.  Thanks!


Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
