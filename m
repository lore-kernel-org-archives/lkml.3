Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaGIMb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:31:27 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:58247 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbaGIMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <1404908623-909-5-git-send-email-geert+renesas@glider.be>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
	<1404908623-909-5-git-send-email-geert+renesas@glider.be>
Date: Wed, 9 Jul 2014 14:31:23 +0200
Message-ID: <CAPDyKFoAm_XLe4EHUASsOHZzPMac-4f2YjWAk6HeMOk6QV2C9A@mail.gmail.com>
Subject: Re: [PATCH 04/13] mmc: tmio-mmc: Add renesas,sdhi-r8a7791 to binding documentation
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Molton <ian.molton@codethink.co.uk>, Chris Ball <chris@printf.net>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 14:23, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> The driver already supports the r8a7791 SoC, and "renesas,sdhi-r8a7791"
> is already in use.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Ian Molton <ian.molton@codethink.co.uk>
> Cc: Chris Ball <chris@printf.net>
> Cc: linux-mmc@vger.kernel.org

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  Documentation/devicetree/bindings/mmc/tmio_mmc.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
> index 6a2a1160a70d..fa0f327cde01 100644
> --- a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
> @@ -18,6 +18,7 @@ Required properties:
>                 "renesas,sdhi-r8a7778" - SDHI IP on R8A7778 SoC
>                 "renesas,sdhi-r8a7779" - SDHI IP on R8A7779 SoC
>                 "renesas,sdhi-r8a7790" - SDHI IP on R8A7790 SoC
> +               "renesas,sdhi-r8a7791" - SDHI IP on R8A7791 SoC
>
>  Optional properties:
>  - toshiba,mmc-wrprotect-disable: write-protect detection is unavailable
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
