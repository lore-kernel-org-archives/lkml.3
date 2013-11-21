Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab3KUEHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:07:20 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:51533 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3KUEHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:07:17 -0500
Date: Thu, 21 Nov 2013 13:07:14 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/05] ARM: shmobile: Add r8a7790 thermal device node to
 DTS
Message-ID: <20131121040712.GJ31130@verge.net.au>
References: <20131120075921.23557.23231.sendpatchset@w520>
 <20131120075930.23557.3517.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120075930.23557.3517.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 04:59:30PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Hook up the r8a7790 thermal sensor to the DTS.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Thanks, I will queue this up.
Assuming all goes will I plan to push this and other updates
today or tomorrow.

> ---
> 
>  arch/arm/boot/dts/r8a7790.dtsi |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- 0004/arch/arm/boot/dts/r8a7790.dtsi
> +++ work/arch/arm/boot/dts/r8a7790.dtsi	2013-11-20 08:25:53.000000000 +0900
> @@ -162,6 +162,13 @@
>  		interrupt-controller;
>  	};
>  
> +	thermal@e61f0000 {
> +		compatible = "renesas,thermal-r8a7790", "renesas,rcar-thermal";
> +		reg = <0 0xe61f0000 0 0x14>, <0 0xe61f0100 0 0x38>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>;
> +	};
> +
>  	timer {
>  		compatible = "arm,armv7-timer";
>  		interrupts = <1 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
> 
