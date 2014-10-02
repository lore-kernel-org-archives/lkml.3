Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaJBUAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:00:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43039 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJBUAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:00:42 -0400
Message-ID: <542DAEE9.7000906@infradead.org>
Date: Thu, 02 Oct 2014 13:00:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        trivial@kernel.org, joe@perches.com, akpm@linux-foundation.org,
        arend@broadcom.com, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the
 "
References: <542DA51C.1080209@free-electrons.com> <1412277870-4960-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1412277870-4960-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more then I'm done.

Thanks.

On 10/02/14 12:24, Michael Opdenacker wrote:

> diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
> index 82bbfa5a05b3..ccadbfd6645e 100644
> --- a/arch/xtensa/kernel/entry.S
> +++ b/arch/xtensa/kernel/entry.S
> @@ -384,7 +384,7 @@ common_exception:
>  	/* Save optional registers. */
>  
>  	save_xtregs_opt a1 a2 a4 a5 a6 a7 PT_XTREGS_OPT
> -	
> +
>  #ifdef CONFIG_TRACE_IRQFLAGS
>  	l32i	a4, a1, PT_DEPC
>  	/* Double exception means we came here with an exception
> @@ -433,7 +433,7 @@ common_exception_return:
>  	 * We need to check some flags for signal handling and rescheduling,
>  	 * and have to restore WB and WS, extra states, and all registers
>  	 * in the register file that were in use in the user task.
> -	 * Note that we don't disable interrupts here. 
> +	 * Note that we don't disable interrupts here.
>  	 */
>  
>  	_bbsi.l	a4, TIF_NEED_RESCHED, 3f
> @@ -830,14 +830,14 @@ ENDPROC(unrecoverable_exception)
>   * of the proper size instead.
>   *
>   * This algorithm simply backs out the register changes started by the user
> - * excpetion handler, makes it appear that we have started a window underflow
> + * exception handler, makes it appear that we have started a window underflow
>   * by rotating the window back and then setting the old window base (OWB) in
>   * the 'ps' register with the rolled back window base. The 'movsp' instruction
>   * will be re-executed and this time since the next window frames is in the
>   * active AR registers it won't cause an exception.
>   *
>   * If the WindowUnderflow code gets a TLB miss the page will get mapped
> - * the the partial windeowUnderflow will be handeled in the double exception
> + * and the partial windeowUnderflow will be handled in the double exception

                      windowUnderflow

>   * handler.
>   *
>   * Entry condition:



-- 
~Randy
