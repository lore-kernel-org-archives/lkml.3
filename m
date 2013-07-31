Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3GaGjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:39:24 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39202 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab3GaGjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:39:22 -0400
Date: Wed, 31 Jul 2013 15:39:19 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: r8a7740: add PMU information to
 r8a7740.dtsi
Message-ID: <20130731063918.GC5090@verge.net.au>
References: <20130724035909.30648.64982.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724035909.30648.64982.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:59:09PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add PMU information to r8a7740.dtsi. With this
> included Armadillo800eva DT reference may use the PMU.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Thanks, I will queue this up for v3.12 in the dt2 branch.

> ---
> 
>  Dry coded based on data sheet, not runtime tested.
> 
>  arch/arm/boot/dts/r8a7740.dtsi |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- 0001/arch/arm/boot/dts/r8a7740.dtsi
> +++ work/arch/arm/boot/dts/r8a7740.dtsi	2013-07-24 04:20:42.000000000 +0900
> @@ -32,6 +32,11 @@
>  		      <0xc2000000 0x1000>;
>  	};
>  
> +	pmu {
> +		compatible = "arm,cortex-a9-pmu";
> +		interrupts = <0 83 4>;
> +	};
> +
>  	/* irqpin0: IRQ0 - IRQ7 */
>  	irqpin0: irqpin@e6900000 {
>  		compatible = "renesas,intc-irqpin";
> 
