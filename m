Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3COGjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:39:19 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:50946 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3COGjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:39:18 -0400
Date: Fri, 15 Mar 2013 08:39:13 +0200
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ir: IR_RX51 only works on OMAP2
Message-ID: <20130315063913.GC1638@itanic.dhcp.inet.fi>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
 <1363298204-8014-7-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363298204-8014-7-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.14 2013 22:56:44, Arnd Bergmann wrote:
> This driver can be enabled on OMAP1 at the moment, which breaks
> allyesconfig for that platform. Let's mark it OMAP2PLUS-only
> in Kconfig, since that is the only thing it builds on.
> 

Acked-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>

Thanks!

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org
> ---
> Mauro, please apply for 3.9
> 
>  drivers/media/rc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 19f3563..5a79c33 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -291,7 +291,7 @@ config IR_TTUSBIR
>  
>  config IR_RX51
>  	tristate "Nokia N900 IR transmitter diode"
> -	depends on OMAP_DM_TIMER && LIRC && !ARCH_MULTIPLATFORM
> +	depends on OMAP_DM_TIMER && ARCH_OMAP2PLUS && LIRC && !ARCH_MULTIPLATFORM
>  	---help---
>  	   Say Y or M here if you want to enable support for the IR
>  	   transmitter diode built in the Nokia N900 (RX51) device.
> -- 
> 1.8.1.2
> 
