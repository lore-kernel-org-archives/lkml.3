Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaKDBHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:07:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12866 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKDBHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:07:39 -0500
X-AuditID: cbfee68e-f79b46d000002b74-04-545826d9ca8c
From: Jingoo Han <jg1.han@samsung.com>
To: "=?iso-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <16457372.FsSJIFmsla@diego>
In-reply-to: <16457372.FsSJIFmsla@diego>
Subject: Re: [PATCH] backlight: extend of_find_backlight_by_node stub-check to
 modules
Date: Tue, 04 Nov 2014 10:08:08 +0900
Message-id: <002401cff7cb$cbee5650$63cb02f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/3yh2n0LdyhMGKSpiT/LWf7MLEqAAAXpxA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zQ92bahEhBrvPS1oc3TmRyeL/o9es
	FpcXXmK1uP/1KKPF5V1z2BxYPXbOusvucefaHjaPvi2rGD22X5vH7PF5k1wAaxSXTUpqTmZZ
	apG+XQJXRs/1C6wFJ7gq5t/4y9TAeIeji5GTQ0LAROLb+V/sELaYxIV769lAbCGBZYwSl5vs
	uxg5wGpW/BHuYuQCCk9nlHjw8DAbhPMLqGb5NRaQBjYBNYkvXw6DDRIRsJC4/6MPbBCzQDej
	xI0bYRBD1SVm3J0BVs8poCHx+ckOsBphgQiJfXcbGEFsFgFViYOdj5lAbF4BW4mu54vYIWxB
	iR+T77FAzNSR6P3+jRnC1pZ48u4CK8Sh6hKP/upCnGAkcbpvFlSJiMS+F+8YQW6WELjGLjHh
	y18miF0CEt8mH2KB6JWV2HSAGRIOkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlWMYqmFiQX
	FCelFxnpFSfmFpfmpesl5+duYoTEad8OxpsHrA8xCnAwKvHwRkhGhAixJpYVV+YeYjQFumgi
	s5Rocj4wGeSVxBsamxlZmJqYGhuZW5opifMmSP0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cDY6RTwbXkGg+6lbXG3Np15P0sv3cT0yOtPXw9sZ3/H9Xz/te7u0nPXlUIfNdiyiuXvuqDS
	f2afmX7Z1oeLrLZzH7zrv2UZkxqnVFzNVGuT6jPRVpZfOd3YXNombczNFZxWnHXjgs72HYln
	WGPFTj6+bphRpO7rvDx3WU9HxDd9mU3Zdoyi51YpsRRnJBpqMRcVJwIAkYszQM4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xoO5NtYgQg3OnRS2O7pzIZPH/0WtW
	i8sLL7Fa3P96lNHi8q45bA6sHjtn3WX3uHNtD5tH35ZVjB7br81j9vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaPn+gXWghNcFfNv/GVqYLzD0cXIwSEhYCKx
	4o9wFyMnkCkmceHeerYuRi4OIYHpjBIPHh6Gcn4xSlxefo0FpIpNQE3iy5fD7CC2iICFxP0f
	fWwgNrNAN6PEjRthILaQgLrEjLszwOo5BTQkPj/ZAVYjLBAhse9uAyOIzSKgKnGw8zETiM0r
	YCvR9XwRO4QtKPFj8j0WiJk6Er3fvzFD2NoST95dYIU4Wl3i0V9diBOMJE73zYIqEZHY9+Id
	4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcBp5J7WBc
	2WBxiFGAg1GJhzdCMiJEiDWxrLgy9xCjBAezkgjvrN/hIUK8KYmVValF+fFFpTmpxYcYTYEe
	ncgsJZqcD0xReSXxhsYmZkaWRmYWRibm5krivAdarQOFBNITS1KzU1MLUotg+pg4OKUaGEOW
	xV9pfd2yoFtp7gLr9a88kj0M3/aeSg4NnNXaKx95zTPviol7uo2pN592dCGDk9ElLpNFz5+q
	+VdMb8iY+KJsFc9PK3abbC/7J/ufzQ4JynBT2F977Rf3r9mqUcrrxD78DYk7s0NM88tBjluq
	EivXn12z2fVOcU2S9JyX70I8FoUFh5ydpMRSnJFoqMVcVJwIAOJn0V4ZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 9:59 AM, Heiko Stübner wrote:
> 
> Commit de3d75dc2311 ("backlight: Use of_find_backlight_by_node stub when
> backlight class disabled") did not take into account that the backlight
> class can also be compiled as module. Extend the check to prevent
> redefinition warnings when the backlight device class is compiled as module.
> 
> Reported-by: kbuild test robot
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Jingoo Han <jg1.han@samsung.com>

If there is no objection, I hope that this patch is merged.
Thank you.

Best regards,
Jingoo Han

> ---
>  include/linux/backlight.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> index d9cb644..92b9817 100644
> --- a/include/linux/backlight.h
> +++ b/include/linux/backlight.h
> @@ -157,7 +157,8 @@ struct generic_bl_info {
>  	void (*kick_battery)(void);
>  };
> 
> -#if defined(CONFIG_OF) && defined(CONFIG_BACKLIGHT_CLASS_DEVICE)
> +#if defined(CONFIG_OF) && (defined(CONFIG_BACKLIGHT_CLASS_DEVICE) || \
> +			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
>  struct backlight_device *of_find_backlight_by_node(struct device_node *node);
>  #else
>  static inline struct backlight_device *
> --
> 2.0.1


