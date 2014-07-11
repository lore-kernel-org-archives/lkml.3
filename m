Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaGKOSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:18:38 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35776 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaGKOSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:35 -0400
Date: Fri, 11 Jul 2014 11:15:53 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] ARM: shmobile: r8a73a4 dtsi: Add SoC-specific
 thermal compatible property
Message-ID: <20140711091553.GM12420@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-9-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404908623-909-9-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:23:38PM +0200, Geert Uytterhoeven wrote:
> The thermal node used the generic compatible property only.
> Add the SoC-specific one, to make it future proof.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, please repost this once the binding has been
accepted by the maintainer.

> ---
>  arch/arm/boot/dts/r8a73a4.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/r8a73a4.dtsi b/arch/arm/boot/dts/r8a73a4.dtsi
> index f3bd3d4603d7..59145b267862 100644
> --- a/arch/arm/boot/dts/r8a73a4.dtsi
> +++ b/arch/arm/boot/dts/r8a73a4.dtsi
> @@ -165,7 +165,7 @@
>  	};
>  
>  	thermal@e61f0000 {
> -		compatible = "renesas,rcar-thermal";
> +		compatible = "renesas,thermal-r8a73a4", "renesas,rcar-thermal";
>  		reg = <0 0xe61f0000 0 0x14>, <0 0xe61f0100 0 0x38>,
>  			 <0 0xe61f0200 0 0x38>, <0 0xe61f0300 0 0x38>;
>  		interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>;
> -- 
> 1.9.1
> 
