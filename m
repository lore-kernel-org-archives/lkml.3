Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaJZNOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 09:14:38 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:46485 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZNOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 09:14:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: sh_tmu: Document r8a7778 binding
Date: Sun, 26 Oct 2014 15:14:38 +0200
Message-ID: <47146431.booHXpnU55@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1414150312-5542-1-git-send-email-geert+renesas@glider.be>
References: <1414150312-5542-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Friday 24 October 2014 13:31:52 Geert Uytterhoeven wrote:
> The r8a7778 is very similar to the r8a7779, and already handled by
> the current driver in the non-DT case.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> This depends on "clocksource: sh_tmu: Document R-Mobile r8a7740 binding"
> 
>  Documentation/devicetree/bindings/timer/renesas,tmu.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> b/Documentation/devicetree/bindings/timer/renesas,tmu.txt index
> 4ae7910af09ffcb4..cd5f20bf2582e742 100644
> --- a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> +++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
> @@ -10,6 +10,7 @@ Required Properties:
> 
>    - compatible: must contain one or more of the following:
>      - "renesas,tmu-r8a7740" for the r8a7740 TMU
> +    - "renesas,tmu-r8a7778" for the r8a7778 TMU
>      - "renesas,tmu-r8a7779" for the r8a7779 TMU
>      - "renesas,tmu" for any TMU.
>        This is a fallback for the above renesas,tmu-* entries

-- 
Regards,

Laurent Pinchart

