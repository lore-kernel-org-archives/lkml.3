Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbaDVQjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:39:24 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47514 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbaDVQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:39:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Phil Edworthy <phil.edworthy@renesas.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-SH <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh-pfc: r8a7791: Fix definition of MOD_SEL3
Date: Tue, 22 Apr 2014 18:39:29 +0200
Message-ID: <5799320.HL6Fc0SWev@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398184685-31670-1-git-send-email-phil.edworthy@renesas.com>
References: <1398184685-31670-1-git-send-email-phil.edworthy@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phil,

Thank you for the patch.

On Tuesday 22 April 2014 17:38:05 Phil Edworthy wrote:
> There is a missing 0 entry from the MOD_SEL3 table.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c index 56f62dc..a823b5b 100644
> --- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
> @@ -5305,7 +5305,7 @@ static const struct pinmux_cfg_reg
> pinmux_config_regs[] = { /* SEL_SCIF3 [2] */
>  		FN_SEL_SCIF3_0, FN_SEL_SCIF3_1, FN_SEL_SCIF3_2, FN_SEL_SCIF3_3,
>  		/* SEL_IEB [2] */
> -		FN_SEL_IEB_0, FN_SEL_IEB_1, FN_SEL_IEB_2,
> +		FN_SEL_IEB_0, FN_SEL_IEB_1, FN_SEL_IEB_2, 0,
>  		/* SEL_MMC [1] */
>  		FN_SEL_MMC_0, FN_SEL_MMC_1,
>  		/* SEL_SCIF5 [1] */

-- 
Regards,

Laurent Pinchart

