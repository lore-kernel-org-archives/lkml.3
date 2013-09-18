Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3IRSmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:42:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55734 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751958Ab3IRSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:42:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/IUY95N5Fi/oQvT3Y/pDo7
Date: Wed, 18 Sep 2013 11:42:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Anoop Thomas Mathew <atm@profoundis.com>
Cc: santosh.shilimkar@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP4 SMP: Corrected a typo fucntions to functions
Message-ID: <20130918184204.GZ9994@atomide.com>
References: <20130907034728.GA28216@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130907034728.GA28216@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anoop Thomas Mathew <atm@profoundis.com> [130906 20:55]:
> Corrected the functions spelling mistake in the OMAP4 SMP source file.
> 
> Signed-off-by: Anoop Thomas Mathew <atm@profoundis.com>

Thanks applying into omap-for-v3.12/fixes.

Tony

> ---
>  arch/arm/mach-omap2/omap-smp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
> index 8708b2a..8912110 100644
> --- a/arch/arm/mach-omap2/omap-smp.c
> +++ b/arch/arm/mach-omap2/omap-smp.c
> @@ -1,5 +1,5 @@
>  /*
> - * OMAP4 SMP source file. It contains platform specific fucntions
> + * OMAP4 SMP source file. It contains platform specific functions
>   * needed for the linux smp kernel.
>   *
>   * Copyright (C) 2009 Texas Instruments, Inc.
> -- 
> 1.7.9.5
> 
