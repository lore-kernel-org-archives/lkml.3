Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab3JPNSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:18:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36681 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934240Ab3JPNSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:18:39 -0400
Message-ID: <525E9206.9010501@ti.com>
Date: Wed, 16 Oct 2013 18:47:58 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>
CC: <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from
 smps10_out1
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
In-Reply-To: <1381402195-29257-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit,

On Thursday 10 October 2013 04:19 PM, Kishon Vijay Abraham I wrote:
> smps10 should be enabled only in the case of host mode. So stop
> doing always_on, boot_on from smps10_out1. The driver will enable it in host
> mode.

Can you take this patch too?

Thanks
Kishon
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/omap5-uevm.dts |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
> index d784b3a..e06a04a 100644
> --- a/arch/arm/boot/dts/omap5-uevm.dts
> +++ b/arch/arm/boot/dts/omap5-uevm.dts
> @@ -334,8 +334,6 @@
>  					regulator-name = "smps10_out1";
>  					regulator-min-microvolt = <5000000>;
>  					regulator-max-microvolt = <5000000>;
> -					regulator-always-on;
> -					regulator-boot-on;
>  				};
>  
>  				ldo1_reg: ldo1 {
> 

