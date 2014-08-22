Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaHVXFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:05:02 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35263 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaHVXFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:05:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/nCAcEGU1/4vdgWl2D0EbX
Date: Fri, 22 Aug 2014 16:04:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Hans Wennborg <hans@hanshq.net>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] ARM: OMAP: fix %d confusingly prefixed with 0x in
 format string
Message-ID: <20140822230456.GK10066@atomide.com>
References: <1407111483-14512-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407111483-14512-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hans Wennborg <hans@hanshq.net> [140803 17:21]:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  arch/arm/mach-omap2/id.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> index d42022f..53841de 100644
> --- a/arch/arm/mach-omap2/id.c
> +++ b/arch/arm/mach-omap2/id.c
> @@ -663,7 +663,7 @@ void __init dra7xxx_check_revision(void)
>  
>  	default:
>  		/* Unknown default to latest silicon rev as default*/
> -		pr_warn("%s: unknown idcode=0x%08x (hawkeye=0x%08x,rev=0x%d)\n",
> +		pr_warn("%s: unknown idcode=0x%08x (hawkeye=0x%08x,rev=0x%x)\n",
>  			__func__, idcode, hawkeye, rev);
>  		omap_revision = DRA752_REV_ES1_1;
>  	}

Thanks applying into omap-for-v3.17/fixes.

Tony
