Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaCMB4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:56:09 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:58090 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaCMB4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:56:07 -0400
Date: Thu, 13 Mar 2014 10:56:05 +0900
From: Simon Horman <horms@verge.net.au>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-media@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 1/5] r8a7790.dtsi: add vin[0-3] nodes
Message-ID: <20140313015605.GB16719@verge.net.au>
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
 <1394197299-17528-2-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394197299-17528-2-git-send-email-ben.dooks@codethink.co.uk>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:01:35PM +0000, Ben Dooks wrote:
> Add nodes for the four video input channels on the R8A7790.

Please update the prefix of this subject of this patch to:
ARM: shmobile: r8a7790: 

> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  arch/arm/boot/dts/r8a7790.dtsi | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
> index a1e7c39..4c3eafb 100644
> --- a/arch/arm/boot/dts/r8a7790.dtsi
> +++ b/arch/arm/boot/dts/r8a7790.dtsi
> @@ -395,6 +395,38 @@
>  		status = "disabled";
>  	};
>  
> +	vin0: vin@0xe6ef0000 {
> +		compatible = "renesas,vin-r8a7790";
> +		clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
> +		reg = <0 0xe6ef0000 0 0x1000>;
> +		interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
> +		status = "disabled";
> +	};
> +
> +	vin1: vin@0xe6ef1000 {
> +		compatible = "renesas,vin-r8a7790";
> +		clocks = <&mstp8_clks R8A7790_CLK_VIN1>;
> +		reg = <0 0xe6ef1000 0 0x1000>;
> +		interrupts = <0 189 IRQ_TYPE_LEVEL_HIGH>;
> +		status = "disabled";
> +	};
> +
> +	vin2: vin@0xe6ef2000 {
> +		compatible = "renesas,vin-r8a7790";
> +		clocks = <&mstp8_clks R8A7790_CLK_VIN2>;
> +		reg = <0 0xe6ef2000 0 0x1000>;
> +		interrupts = <0 190 IRQ_TYPE_LEVEL_HIGH>;
> +		status = "disabled";
> +	};
> +
> +	vin3: vin@0xe6ef3000 {
> +		compatible = "renesas,vin-r8a7790";
> +		clocks = <&mstp8_clks R8A7790_CLK_VIN3>;
> +		reg = <0 0xe6ef3000 0 0x1000>;
> +		interrupts = <0 191 IRQ_TYPE_LEVEL_HIGH>;
> +		status = "disabled";
> +	};
> +
>  	clocks {
>  		#address-cells = <2>;
>  		#size-cells = <2>;
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
