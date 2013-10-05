Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3JEPWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:22:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59817 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3JEPWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:22:06 -0400
X-Spam-Score: -100.9
Message-ID: <52502E61.5000307@asianux.com>
Date: Sat, 05 Oct 2013 23:21:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/irq/proc.c: set MAX_NAMELEN 11 instead of 10 which
 express the maximize size of "%d" or "%u".
References: <52502E14.5040507@asianux.com>
In-Reply-To: <52502E14.5040507@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Al Viro:

Is this patch correct?  ;-)

Thanks.

On 10/05/2013 11:19 PM, Chen Gang wrote:
> Theoretically, the maximize size of "%d" or "%u" is 11 (10 + '\0'), so
> need set MAX_NAMELEN 11 instead of 10.
> 
> In real world, it may not cause issue, but still recommend to fix this
> 'theoretical' bug (especially original definition already considered
> about 'theoretical' using).
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/irq/proc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
> index 36f6ee1..4e9a9ee 100644
> --- a/kernel/irq/proc.c
> +++ b/kernel/irq/proc.c
> @@ -305,7 +305,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
>  
>  #undef MAX_NAMELEN
>  
> -#define MAX_NAMELEN 10
> +#define MAX_NAMELEN 11
>  
>  void register_irq_proc(unsigned int irq, struct irq_desc *desc)
>  {
> 


-- 
Chen Gang
