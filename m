Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaKYWXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:23:39 -0500
Received: from mout.gmx.net ([212.227.15.15]:57678 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaKYWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:23:37 -0500
Date: Tue, 25 Nov 2014 23:23:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: v4l2-image-sizes.h: add SVGA, XGA and UXGA
 size definitions
In-Reply-To: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1411252318330.17362@axis700.grange>
References: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V03:K0:UAZz6mRdRROvQRPqs+dKgBpgtEeCUVv4wPRhOL2Ir+PVXkkGgEl
 dR40AHcKg77RFueQnlbjWpGKYOLBfe1eZ+EBLWw7JFmfMzBuw5rCWCL0HqI+JznxoS9JP+8
 0ZYkt3rJW3zStQhdRyvnmMwceCcviidT0pPkM9rP1XupqeytkLwyHCVWu7ty+ezPOxhtjPY
 Df2TQGa3+DjWnRvXebBVg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Tue, 25 Nov 2014, Josh Wu wrote:

> Add SVGA, UXGA and XGA size definitions to v4l2-image-sizes.h.
> The definitions are sorted by alphabet order.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Thanks for your patches. I'm ok with these two, but the second of them 
depends on the first one, and the first one wouldn't (normally) be going 
via the soc-camera tree. Mauro, how would you prefer to handle this? 
Should I pick up and push to you both of them or postpone #2 until the 
next merge window?

Thanks
Guennadi

> ---
>  include/media/v4l2-image-sizes.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/media/v4l2-image-sizes.h b/include/media/v4l2-image-sizes.h
> index 10daf92..c70c917 100644
> --- a/include/media/v4l2-image-sizes.h
> +++ b/include/media/v4l2-image-sizes.h
> @@ -25,10 +25,19 @@
>  #define QVGA_WIDTH	320
>  #define QVGA_HEIGHT	240
>  
> +#define SVGA_WIDTH	800
> +#define SVGA_HEIGHT	680
> +
>  #define SXGA_WIDTH	1280
>  #define SXGA_HEIGHT	1024
>  
>  #define VGA_WIDTH	640
>  #define VGA_HEIGHT	480
>  
> +#define UXGA_WIDTH	1600
> +#define UXGA_HEIGHT	1200
> +
> +#define XGA_WIDTH	1024
> +#define XGA_HEIGHT	768
> +
>  #endif /* _IMAGE_SIZES_H */
> -- 
> 1.9.1
> 
