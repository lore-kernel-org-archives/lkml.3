Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaDTRAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 13:00:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60794 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaDTRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 13:00:04 -0400
Message-ID: <5353FD09.6000701@infradead.org>
Date: Sun, 20 Apr 2014 09:59:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Terence Eden <terence.eden@gmail.com>, vgupta@synopsys.com
CC: linux-kernel@vger.kernel.org, trivial@rustcorp.com.au, kernel@shkspr.mobi,
        Terence Eden <github.com@shkspr.mobi>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Fixed spelling errors within comments
References: <1397997228-2701-1-git-send-email-terence.eden@gmail.com>
In-Reply-To: <1397997228-2701-1-git-send-email-terence.eden@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2014 05:33 AM, Terence Eden wrote:
> From: Terence Eden <github.com@shkspr.mobi>
> 
> This is my first patch submission. Please let me know if I have made a mistake anywhere.
> 
> Signed-off-by: Terence Eden <github.com@shkspr.mobi>

trivial's email address is trivial@kernel.org (cc-ed).

> ---
>  arch/arc/kernel/entry.S |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
> index 819dd5f..38ef91a 100644
> --- a/arch/arc/kernel/entry.S
> +++ b/arch/arc/kernel/entry.S
> @@ -156,7 +156,7 @@ ARCFP_DATA int1_saved_reg
>  int1_saved_reg:
>  	.zero 4
>  
> -/* Each Interrupt level needs it's own scratch */
> +/* Each Interrupt level needs its own scratch */
>  #ifdef CONFIG_ARC_COMPACT_IRQ_LEVELS
>  
>  ARCFP_DATA int2_saved_reg
> @@ -473,7 +473,7 @@ trap_with_param:
>  	lr  r0, [efa]
>  	mov r1, sp
>  
> -	; Now that we have read EFA, its safe to do "fake" rtie
> +	; Now that we have read EFA, it is safe to do "fake" rtie
>  	;   and get out of CPU exception mode
>  	FAKE_RET_FROM_EXCPN r11
>  
> @@ -676,9 +676,9 @@ not_exception:
>  	brne r9, event_IRQ2, 149f
>  
>  	;------------------------------------------------------------------
> -	; if L2 IRQ interrupted a L1 ISR,  we'd disbaled preemption earlier
> -	; so that sched doesnt move to new task, causing L1 to be delayed
> -	; undeterministically. Now that we've achieved that, lets reset
> +	; if L2 IRQ interrupted a L1 ISR,  we'd disabled preemption earlier

I would write:                  an L1 ISR,

anyway:
Acked-by: Randy Dunlap <rdunlap@infradead.org>


> +	; so that sched doesn't move to new task, causing L1 to be delayed
> +	; undeterministically. Now that we've achieved that, let's reset
>  	; things to what they were, before returning from L2 context
>  	;----------------------------------------------------------------
>  
> @@ -734,7 +734,7 @@ ENTRY(ret_from_fork)
>  	; put last task in scheduler queue
>  	bl   @schedule_tail
>  
> -	; If kernel thread, jump to it's entry-point
> +	; If kernel thread, jump to its entry-point
>  	ld   r9, [sp, PT_status32]
>  	brne r9, 0, 1f
>  
> 


-- 
~Randy
