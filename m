Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937256Ab3DKDA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:00:28 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42837 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937194Ab3DKDAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:00:23 -0400
Date: Thu, 11 Apr 2013 12:00:20 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH/RFC 6/6] ARM: shmobile: kzm9g-reference: add DMA channels
 to the MMCIF DT
Message-ID: <20130411030020.GF21037@verge.net.au>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
 <1365632389-2249-7-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365632389-2249-7-git-send-email-g.liakhovetski@gmx.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 12:19:49AM +0200, Guennadi Liakhovetski wrote:
> The MMCIF driver can use DMA for data transfer, add suitable
> Device Tree bindings.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Hi Guennadi, this seems reasonable to me.

I guess the best thing is for you to repost it once the pre-requisites
are in place.

> ---
>  arch/arm/boot/dts/sh73a0-kzm9g-reference.dts |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
> index ed9dd45..e1d0d5d 100644
> --- a/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
> +++ b/arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
> @@ -156,6 +156,9 @@
>  	bus-width = <8>;
>  	vmmc-supply = <&reg_1p8v>;
>  	status = "okay";
> +	dmas = <&dma0 0xd1
> +		&dma0 0xd2>;
> +	dma-names = "tx", "rx";
>  };
>  
>  &sdhi0 {
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
