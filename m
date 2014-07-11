Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbaGKOYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:24:14 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35742 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaGKOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:20 -0400
Date: Fri, 11 Jul 2014 11:16:16 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] ARM: shmobile: r8a7779 dtsi: Add SoC-specific
 thermal compatible property
Message-ID: <20140711091615.GN12420@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-10-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404908623-909-10-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:23:39PM +0200, Geert Uytterhoeven wrote:
> The thermal node used the generic compatible property only.
> Add the SoC-specific one, to make it future proof.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, please repost this once the binding has been
accepted by the maintainer.

> ---
>  arch/arm/boot/dts/r8a7779.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/r8a7779.dtsi b/arch/arm/boot/dts/r8a7779.dtsi
> index 94e2fc836492..aca1f9bd714e 100644
> --- a/arch/arm/boot/dts/r8a7779.dtsi
> +++ b/arch/arm/boot/dts/r8a7779.dtsi
> @@ -262,7 +262,7 @@
>  	};
>  
>  	thermal@ffc48000 {
> -		compatible = "renesas,rcar-thermal";
> +		compatible = "renesas,thermal-r8a7779", "renesas,rcar-thermal";
>  		reg = <0xffc48000 0x38>;
>  	};
>  
> -- 
> 1.9.1
> 
