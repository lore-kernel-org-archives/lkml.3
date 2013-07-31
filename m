Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3GaGjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:39:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39192 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab3GaGjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:39:06 -0400
Date: Wed, 31 Jul 2013 15:39:04 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, koba@kmckk.co.jp, linux-sh@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: emev2: add PMU information to emev2.dtsi
Message-ID: <20130731063900.GA5090@verge.net.au>
References: <20130724034240.30596.52917.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724034240.30596.52917.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:42:40PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add PMU information to emev2.dtsi. With this
> included KZM9D DT reference may use the PMU.

Thanks, I will queue this up for v3.12 in the dt2 branch.

> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  arch/arm/boot/dts/emev2.dtsi |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- 0009/arch/arm/boot/dts/emev2.dtsi
> +++ work/arch/arm/boot/dts/emev2.dtsi	2013-07-02 17:32:45.000000000 +0900
> @@ -46,6 +46,12 @@
>  		      <0xe0020000 0x0100>;
>  	};
>  
> +	pmu {
> +		compatible = "arm,cortex-a9-pmu";
> +		interrupts = <0 120 4>,
> +			     <0 121 4>;
> +	};
> +
>  	sti@e0180000 {
>  		compatible = "renesas,em-sti";
>  		reg = <0xe0180000 0x54>;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
