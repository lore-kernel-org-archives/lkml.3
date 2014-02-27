Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaB0WtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:49:16 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:53826 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaB0WtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:49:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@linaro.org>, devicetree@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH] spi: sh-msiof: Remove "renesas,msiof-sh7724" from bindings
Date: Thu, 27 Feb 2014 23:50:36 +0100
Message-ID: <3183546.lDudat1pu0@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393505238-11954-1-git-send-email-geert@linux-m68k.org>
References: <1393505238-11954-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Thursday 27 February 2014 13:47:17 Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> It's not implemented in the driver, so it's a bad example.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/spi/sh-msiof.txt |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/spi/sh-msiof.txt
> b/Documentation/devicetree/bindings/spi/sh-msiof.txt index
> 1f0cb33763a1..f24baf3b6cc1 100644
> --- a/Documentation/devicetree/bindings/spi/sh-msiof.txt
> +++ b/Documentation/devicetree/bindings/spi/sh-msiof.txt
> @@ -5,7 +5,6 @@ Required properties:
>  			 "renesas,sh-msiof" for SuperH, or
>  			 "renesas,sh-mobile-msiof" for SH Mobile series.
>  			 Examples with soctypes are:
> -			 "renesas,msiof-sh7724" (SH)
>  			 "renesas,msiof-r8a7790" (R-Car H2)
>  			 "renesas,msiof-r8a7791" (R-Car M2)
>  - reg                  : Offset and length of the register set for the
> device

-- 
Regards,

Laurent Pinchart

