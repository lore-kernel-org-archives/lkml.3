Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaGHIQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:16:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23578 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaGHIQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:16:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OKLzboXdrkeZcxrP/uWzA
Date: Tue, 8 Jul 2014 01:16:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap16xx: Removes fixme no longer needed in ocpi_enable()
Message-ID: <20140708081606.GC28884@atomide.com>
References: <1404351079-5117-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404351079-5117-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Krause <xerofoify@gmail.com> [140702 18:33]:
> This removes the FIXME message above ocpi_enable being declared
> for proper locking in this function. As of the current kernel
> verisons there is no need for locking as only one driver uses
> this function currently and therefore there is no need for real
> locking requirements.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Thanks applying into omap-for-v3.17/fixes-not-urgent.

Tony

> ---
>  arch/arm/mach-omap1/ocpi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap1/ocpi.c b/arch/arm/mach-omap1/ocpi.c
> index 238170c..44a3d19 100644
> --- a/arch/arm/mach-omap1/ocpi.c
> +++ b/arch/arm/mach-omap1/ocpi.c
> @@ -55,7 +55,6 @@ static struct clk *ocpi_ck;
>  
>  /*
>   * Enables device access to OMAP buses via the OCPI bridge
> - * FIXME: Add locking
>   */
>  int ocpi_enable(void)
>  {
> -- 
> 1.9.1
> 
