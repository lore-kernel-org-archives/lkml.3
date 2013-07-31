Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab3GaGjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:39:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39198 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab3GaGjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:39:13 -0400
Date: Wed, 31 Jul 2013 15:39:10 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, koba@kmckk.co.jp, linux-sh@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: sh73a0: add PMU information to sh73a0.dtsi
Message-ID: <20130731063909.GB5090@verge.net.au>
References: <20130724034503.30609.21892.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724034503.30609.21892.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:45:03PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add PMU information to sh73a0.dtsi. With this
> included KZM9G DT reference may use the PMU.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Thanks, I will queue this up for v3.12 in the dt2 branch.

> ---
> 
>  arch/arm/boot/dts/sh73a0.dtsi |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- 0001/arch/arm/boot/dts/sh73a0.dtsi
> +++ work/arch/arm/boot/dts/sh73a0.dtsi	2013-07-24 04:12:57.000000000 +0900
> @@ -38,6 +38,12 @@
>  		      <0xf0000100 0x100>;
>  	};
>  
> +	pmu {
> +		compatible = "arm,cortex-a9-pmu";
> +		interrupts = <0 55 4>,
> +			     <0 56 4>;
> +	};
> +
>  	irqpin0: irqpin@e6900000 {
>  		compatible = "renesas,intc-irqpin";
>  		#interrupt-cells = <2>;
> 
