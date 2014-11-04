Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaKDLtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:49:53 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:43707 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKDLtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:49:52 -0500
MIME-Version: 1.0
In-Reply-To: <1415096920-1800-1-git-send-email-p.zabel@pengutronix.de>
References: <1415096920-1800-1-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 4 Nov 2014 19:49:51 +0800
Message-ID: <CAAQ0ZWTY6C-2Y3FWv8t=oEmBfya5koTjt1aNgQOWz6SznjT_2w@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add maintainer for IPUv3 core driver
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 6:28 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Add myself as maintainer for the IPUv3 core driver.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 34d3671..1c48287 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3917,6 +3917,13 @@ S:       Maintained
>  F:     include/linux/platform_data/video-imxfb.h
>  F:     drivers/video/fbdev/imxfb.c
>
> +FREESCALE IMX IPUv3 CORE DRIVER
> +M:     Philipp Zabel <p.zabel@pengutronix.de>
> +L:     dri-devel@lists.freedesktop.org
> +S:     Maintained
> +F:     drivers/gpu/ipu-v3/
> +F:     include/video/imx-ipu-v3.h
> +
>  FREESCALE SOC FS_ENET DRIVER
>  M:     Pantelis Antoniou <pantelis.antoniou@gmail.com>
>  M:     Vitaly Bordug <vbordug@ru.mvista.com>
> --
> 2.1.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
