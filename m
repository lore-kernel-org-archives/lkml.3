Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab3BSKZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:25:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42892 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab3BSKY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:24:59 -0500
Message-ID: <51235337.60209@ti.com>
Date: Tue, 19 Feb 2013 15:55:59 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Afzal Mohammed <afzal@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 4/8] ARM: am33xx: ll debug config help
References: <cover.1361186097.git.afzal@ti.com> <bfe941adb98a5000c2817f9fd6160070e59e53c9.1361186097.git.afzal@ti.com>
In-Reply-To: <bfe941adb98a5000c2817f9fd6160070e59e53c9.1361186097.git.afzal@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013 05:07 PM, Afzal Mohammed wrote:
> Selecting DEBUG_AM33XXUART1 routes low level debug messages to first
> UART instance of AM335x based SoC's. This selection is valid for
> upcoming AM43 based SoC's too. Make this information available upon
> configuring.
>
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
>   arch/arm/Kconfig.debug | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index acdddda..b717b78 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -542,6 +542,9 @@ choice
>
>   	config DEBUG_AM33XXUART1
>   		bool "AM33XX UART1"
> +		help
> +		  Route low level debug messages to first uart instance
> +		  for boards based on am335 and am43 family of SoC's
>
>   	config DEBUG_ZOOM_UART
>   		bool "Zoom2/3 UART"
>
With DT, IIRC DEBUGLL is broken. So did you hack debug-macro.S
to get the earlyprintk working ?

Regards,
Santosh
