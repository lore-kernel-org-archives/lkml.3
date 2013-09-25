Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3IYFyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 01:54:38 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42729 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3IYFyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 01:54:36 -0400
Date: Wed, 25 Sep 2013 14:54:34 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v5 7/7] ARM: shmobile: ape6evm-reference: enable DMA for
 the MMC interface
Message-ID: <20130925055433.GC6663@verge.net.au>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
 <1375455042-24093-8-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375455042-24093-8-git-send-email-g.liakhovetski@gmx.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 04:50:42PM +0200, Guennadi Liakhovetski wrote:
> This patch adds DMA slave bindings for the two required DMA channels
> for MMCIF0 to ape6evm-reference.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Does this patch depend on any of the other paches in this series?

> ---
>  arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts b/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts
> index 6797fac..631086a 100644
> --- a/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts
> +++ b/arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts
> @@ -112,6 +112,9 @@
>  	vmmc-supply = <&vcc_mmc0>;
>  	bus-width = <8>;
>  	non-removable;
> +	dmas = <&dmac 0xd1
> +		&dmac 0xd2>;
> +	dma-names = "tx", "rx";
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&mmc0_pins>;
>  	status = "okay";
> -- 
> 1.7.2.5
> 
