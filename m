Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaGKOSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:18:41 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35780 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaGKOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:39 -0400
Date: Fri, 11 Jul 2014 11:15:35 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/13] ARM: shmobile: r8a73a4 dtsi: Add SoC-specific irqc
 compatible property
Message-ID: <20140711091534.GL12420@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-8-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404908623-909-8-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:23:37PM +0200, Geert Uytterhoeven wrote:
> The interrupt controller used the generic compatible property only.
> Add the SoC-specific one, to make it future proof.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, please repost this once the binding has been
accepted by the maintainer.

> ---
>  arch/arm/boot/dts/r8a73a4.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r8a73a4.dtsi b/arch/arm/boot/dts/r8a73a4.dtsi
> index 82c5ac825386..f3bd3d4603d7 100644
> --- a/arch/arm/boot/dts/r8a73a4.dtsi
> +++ b/arch/arm/boot/dts/r8a73a4.dtsi
> @@ -51,7 +51,7 @@
>  	};
>  
>  	irqc0: interrupt-controller@e61c0000 {
> -		compatible = "renesas,irqc";
> +		compatible = "renesas,irqc-r8a73a4", "renesas,irqc";
>  		#interrupt-cells = <2>;
>  		interrupt-controller;
>  		reg = <0 0xe61c0000 0 0x200>;
> @@ -90,7 +90,7 @@
>  	};
>  
>  	irqc1: interrupt-controller@e61c0200 {
> -		compatible = "renesas,irqc";
> +		compatible = "renesas,irqc-r8a73a4", "renesas,irqc";
>  		#interrupt-cells = <2>;
>  		interrupt-controller;
>  		reg = <0 0xe61c0200 0 0x200>;
> -- 
> 1.9.1
> 
