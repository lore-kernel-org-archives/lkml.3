Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaKYKee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:34:34 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19762 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaKYKec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:34:32 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f2-54745b355805
Message-id: <54745B2F.70003@samsung.com>
Date: Tue, 25 Nov 2014 11:34:23 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
        linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH 1/2] media: v4l2-image-sizes.h: add SVGA,
 XGA and UXGA size definitions
References: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
In-reply-to: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xK7qm0SUhBoc7VSzeb5zHZLGr8Ter
	xeVdc9gsejZsZbW4uE7egdVjwa+tLB4fPsZ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bu
	8xPZCjZxVCxc28newPiArYuRk0NCwETi3cqfULaYxIV764FsLg4hgaWMEr3Nt5ghnE+MEusu
	tDCCVPEKaEhc7JjPCmKzCKhKnOl4wgJiswkYSvQe7QOrERWIkDh5dw87RL2gxI/J98BqRATk
	JWZfOAVmMwvkSNx9tARss7BArMTh30eA4hxAyxwltl/iBwlzCjhJTO14zAQSZhbQk7h/UQui
	U15i85q3zBMYBWYhWTALoWoWkqoFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULC9+sO
	xqXHrA4xCnAwKvHwVmgWhwixJpYVV+YeYpTgYFYS4X3vWRIixJuSWFmVWpQfX1Sak1p8iJGJ
	g1OqgfHIKXsOluwQyfj+Pbf9paTn/uLhi6y2uM18sTua69X3yMIN1efa508z2fP5W0P14akr
	Db1+lbf/eu267jOrvnHd9l0ZSuKpe5y47G4L3I6sOnSzdunt1k3ezsqXHVweHVK6uJjhca0O
	g2SJ9sn1D3WYsgN28DYH5P8t6Q6u1ZHZcy7tv/yuFCWW4oxEQy3mouJEAKT7J3I9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 25/11/14 09:54, Josh Wu wrote:
> Add SVGA, UXGA and XGA size definitions to v4l2-image-sizes.h.
> The definitions are sorted by alphabet order.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
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

I think this should be 600. With that fixed, for both patches:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

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

--
Regards,
Sylwester
