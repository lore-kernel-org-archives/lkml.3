Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaJVPAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:00:09 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:42872 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaJVPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:00:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: sh_mtu2: Correct SoC family name
Date: Wed, 22 Oct 2014 18:00:19 +0300
Message-ID: <1593823.SBtdMLb0Ra@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413969978-15946-1-git-send-email-geert+renesas@glider.be>
References: <1413969978-15946-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Wednesday 22 October 2014 11:26:18 Geert Uytterhoeven wrote:
> r7s72100 is a member of the RZ family, not of the R-Car family
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/timer/renesas,mtu2.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt index
> d9a8d5af1a21270f..55484a77a6ae54d0 100644
> --- a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> +++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
> @@ -1,4 +1,4 @@
> -* Renesas R-Car Multi-Function Timer Pulse Unit 2 (MTU2)
> +* Renesas RZ Multi-Function Timer Pulse Unit 2 (MTU2)
> 
>  The MTU2 is a multi-purpose, multi-channel timer/counter with configurable
>  clock inputs and programmable compare match.

-- 
Regards,

Laurent Pinchart

