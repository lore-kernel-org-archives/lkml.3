Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965240Ab3DHVqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:46:47 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30324 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965175Ab3DHVqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:46:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+CA/EK7VcfIfkpBoYOXHDK
Date: Mon, 8 Apr 2013 14:46:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap2+: Remove useless Makefile line
Message-ID: <20130408214640.GB10155@atomide.com>
References: <1365156992.1830.63.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365156992.1830.63.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [130405 03:21]:
> Merge commit 952414505f55afe5cd6dc004765076aa22b3ed7e ("Merge branch
> 'next/cleanup' of git://git.linaro.org/people/arnd/arm-soc") added
> references to CONFIG_MACH_PCM049 and board-omap4pcm049.o to this
> Makefile. But there's no Kconfig symbol MACH_PCM049 and there's no file
> board-omap4pcm049.c. This line can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Note that MACH_PCM049 was removed from mach-types in v3.5.
> 
>  arch/arm/mach-omap2/Makefile | 2 --
>  1 file changed, 2 deletions(-)

Thanks applying into omap-for-v3.10/board.

Tony
 
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 3d0697c..62bb352 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -254,8 +254,6 @@ obj-$(CONFIG_MACH_TOUCHBOOK)		+= board-omap3touchbook.o
>  obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o
>  obj-$(CONFIG_MACH_OMAP4_PANDA)		+= board-omap4panda.o
>  
> -obj-$(CONFIG_MACH_PCM049)		+= board-omap4pcm049.o
> -
>  obj-$(CONFIG_MACH_OMAP3517EVM)		+= board-am3517evm.o
>  
>  obj-$(CONFIG_MACH_CRANEBOARD)		+= board-am3517crane.o
> -- 
> 1.7.11.7
> 
