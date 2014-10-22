Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaJVO7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:59:15 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:42864 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaJVO7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:59:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] clocksource: sh_tmu: Document R-Mobile r8a7740 binding
Date: Wed, 22 Oct 2014 17:59:25 +0300
Message-ID: <6890235.hnMLlLN6KA@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413970709-26607-2-git-send-email-geert+renesas@glider.be>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be> <1413970709-26607-2-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Wednesday 22 October 2014 11:38:27 Geert Uytterhoeven wrote:
> Compared to the r8a7779, the r8a7740 lacks the input capture register,
> which is not used by the driver (the current driver already handles the
> r8a7740 in the non-DT case).
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/timer/renesas,tmu.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> b/Documentation/devicetree/bindings/timer/renesas,tmu.txt index
> 7db89fb2544411b5..4ae7910af09ffcb4 100644
> --- a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> +++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> @@ -1,4 +1,4 @@
> -* Renesas R-Car Timer Unit (TMU)
> +* Renesas R-Mobile/R-Car Timer Unit (TMU)
> 
>  The TMU is a 32-bit timer/counter with configurable clock inputs and
>  programmable compare match.
> @@ -9,6 +9,7 @@ are independent. The TMU hardware supports up to three
> channels. Required Properties:
> 
>    - compatible: must contain one or more of the following:
> +    - "renesas,tmu-r8a7740" for the r8a7740 TMU
>      - "renesas,tmu-r8a7779" for the r8a7779 TMU
>      - "renesas,tmu" for any TMU.
>        This is a fallback for the above renesas,tmu-* entries

-- 
Regards,

Laurent Pinchart

