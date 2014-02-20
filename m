Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaBTXXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:23:17 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59553 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaBTXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:23:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 01/11] ARM: shmobile: r8a7791 dtsi: Fix typo in msiof2 clock output name
Date: Fri, 21 Feb 2014 00:24:26 +0100
Message-ID: <2331215.fbDlSseAe0@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392907779-22053-2-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org> <1392907779-22053-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

(CC'ing Linus Walleij)

Thank you for the patch.

On Thursday 20 February 2014 15:49:29 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Introduced in commit cded80f869aef94853e056ab9c21e305b0c26138 ("ARM:
> shmobile: r8a7791: Add MSIOF clocks in device tree").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  arch/arm/boot/dts/r8a7791.dtsi |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
> index 1ab4f3d5a8c2..224f4a7ee52a 100644
> --- a/arch/arm/boot/dts/r8a7791.dtsi
> +++ b/arch/arm/boot/dts/r8a7791.dtsi
> @@ -667,7 +667,7 @@
>  				R8A7791_CLK_MSIOF1 R8A7791_CLK_SCIFB2
> 
>  			>;
> 
>  			clock-output-names =
> -				"scifa2", "scifa1", "scifa0", "misof2", "scifb0",
> +				"scifa2", "scifa1", "scifa0", "msiof2", "scifb0",
>  				"scifb1", "msiof1", "scifb2";
>  		};
>  		mstp3_clks: mstp3_clks@e615013c {

-- 
Regards,

Laurent Pinchart

