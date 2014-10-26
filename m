Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaJZNOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 09:14:19 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:46481 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZNOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 09:14:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] clocksource: sh_mtu2: Drop incorrect SoC family name
Date: Sun, 26 Oct 2014 15:14:19 +0200
Message-ID: <2748392.6fMSe2cx9z@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1414150178-4986-1-git-send-email-geert+renesas@glider.be>
References: <1414150178-4986-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Friday 24 October 2014 13:29:38 Geert Uytterhoeven wrote:
> The TPU2 hardware block is found in many Renesas SH and ARM SoCs, but

s/TPU2/MTU2/

With this fixed,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> not in R-Car.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Drop family name instead of changing it to RZ.
> ---
>  Documentation/devicetree/bindings/timer/renesas,mtu2.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt index
> d9a8d5af1a21270f..ba0a34d97eb80261 100644
> --- a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> +++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> @@ -1,4 +1,4 @@
> -* Renesas R-Car Multi-Function Timer Pulse Unit 2 (MTU2)
> +* Renesas Multi-Function Timer Pulse Unit 2 (MTU2)
> 
>  The MTU2 is a multi-purpose, multi-channel timer/counter with configurable
>  clock inputs and programmable compare match.

-- 
Regards,

Laurent Pinchart

