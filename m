Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3CXVPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:15:04 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:56100 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab3CXVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:15:02 -0400
Message-ID: <514F6CD1.5010409@gmail.com>
Date: Sun, 24 Mar 2013 16:14:57 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Paolo Pisati <p.pisati@gmail.com>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] ARM: l2x0: don't set .set_debug in l310 case
References: <1364149654-16163-1-git-send-email-p.pisati@gmail.com>
In-Reply-To: <1364149654-16163-1-git-send-email-p.pisati@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2013 01:27 PM, Paolo Pisati wrote:
> From: Paolo Pisati <paolo.pisati@canonical.com>
> 
> commit 74ddcdb ("l2x0: Only set .set_debug on PL310 r3p0 and earlier")
> to actually work needs .set_debug to be not set during definition
> 
> Signed-off-by: Paolo Pisati <p.pisati@gmail.com>

Ah crap, missed this part. Can I add this into my fix and I'll put it in
Russell's patch system.

Rob

> ---
>  arch/arm/mm/cache-l2x0.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index d457653..37f1364 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -724,7 +724,6 @@ static const struct l2x0_of_data pl310_data = {
>  		.flush_all   = l2x0_flush_all,
>  		.inv_all     = l2x0_inv_all,
>  		.disable     = l2x0_disable,
> -		.set_debug   = pl310_set_debug,
>  	},
>  };
>  
> 

