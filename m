Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab3CFBKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:10:51 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55488 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755082Ab3CFBKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:10:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GC6ZMhinjtfUrNoX3OyCl
Date: Tue, 5 Mar 2013 17:10:47 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: Re: [PATCH 8/9] iommu: OMAP: build only on OMAP2+
Message-ID: <20130306011046.GK11806@atomide.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-9-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362521809-22989-9-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130305 14:21]:
> The OMAP IOMMU driver intentionally fails to build on OMAP1
> platforms, so we should not allow enabling it there.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: iommu@lists.linux-foundation.org
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Omar Ramirez Luna <omar.luna@linaro.org>

Makes sense, I doubt that anybody will work on omap1 version
at this point:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/iommu/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 5c514d07..c332fb9 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -130,7 +130,7 @@ config IRQ_REMAP
>  # OMAP IOMMU support
>  config OMAP_IOMMU
>  	bool "OMAP IOMMU Support"
> -	depends on ARCH_OMAP
> +	depends on ARCH_OMAP2PLUS
>  	select IOMMU_API
>  
>  config OMAP_IOVMM
> -- 
> 1.8.1.2
> 
