Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaIWONP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:13:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29847 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaIWONL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:13:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,580,1406592000"; 
   d="scan'208";a="175306581"
Date: Tue, 23 Sep 2014 15:11:08 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: <xen-devel@lists.xenproject.org>, Ian Campbell <ian.campbell@citrix.com>,
        <tim@xen.org>, <stefano.stabellini@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] arm{,64}/xen: Remove "EXPERIMENTAL" in the description
 of the Xen options
In-Reply-To: <1410988026-19949-1-git-send-email-julien.grall@linaro.org>
Message-ID: <alpine.DEB.2.02.1409231402320.15268@kaball.uk.xensource.com>
References: <1410988026-19949-1-git-send-email-julien.grall@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Julien Grall wrote:
> The Xen ARM API is stable since Xen 4.4 and everything has been
> upstreamed in Linux for ARM and ARM64. Therefore we can drop "EXPERIMENTAL"
> from the Xen option in the both Kconfig.
> 
> Signed-off-by: Julien Grall <julien.grall@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

Added to xentip


>  arch/arm/Kconfig   | 2 +-
>  arch/arm64/Kconfig | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 32cbbd5..aa97108 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1758,7 +1758,7 @@ config XEN_DOM0
>  	depends on XEN
>  
>  config XEN
> -	bool "Xen guest support on ARM (EXPERIMENTAL)"
> +	bool "Xen guest support on ARM"
>  	depends on ARM && AEABI && OF
>  	depends on CPU_V7 && !CPU_V6
>  	depends on !GENERIC_ATOMIC64
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fd4e81a..82bd86c 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -317,7 +317,7 @@ config XEN_DOM0
>  	depends on XEN
>  
>  config XEN
> -	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
> +	bool "Xen guest support on ARM64"
>  	depends on ARM64 && OF
>  	select SWIOTLB_XEN
>  	help
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://secure-web.cisco.com/10fMHoxLmpT7pslRQhVXoQ98BZM4058tWPAwjHIJFPjSWRzVkTCTZ5DW4mRyexHq4j8P3ydfhTL7AEFkQAPV_2GFn8ObgHE0PFjX8z37tMXWC2pHJcJIxV4gTr-DsOt-jvgxaFlv8DQjb8Lnuuu3eSqqEw4tVTIdc7nTFoE21Jso/http%3A%2F%2Fwww.tux.org%2Flkml%2F
> 
