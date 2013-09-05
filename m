Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935603Ab3IEKAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:00:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25582 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763535Ab3IEKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:00:28 -0400
X-AuditID: cbfee68e-b7f756d000004512-89-5228563a72b6
From: Inki Dae <inki.dae@samsung.com>
To: "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'David Herrmann'" <dh.herrmann@gmail.com>,
        "'H. Peter Anvin'" <hpa@linux.intel.com>
Cc: "'David Airlie'" <airlied@linux.ie>,
        "'Geoff Levand'" <geoff@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1378369230-7786-1-git-send-email-geert@linux-m68k.org>
In-reply-to: <1378369230-7786-1-git-send-email-geert@linux-m68k.org>
Subject: RE: [PATCH] video/drm: Drop superfluous "select VT_HW_CONSOLE_BINDING"
Date: Thu, 05 Sep 2013 19:00:26 +0900
Message-id: <010b01ceaa1e$beba1510$3c2e3f30$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6qEODqFeYzbqeETVeA6Ct/UJxkuAADbWQg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsWyRsSkWNcqTCPI4O9ZG4vecyeZLOa1HmWx
	uPL1PZvFs1t7mSyWvLSzuPnjMovFib4PrBaXd81hc+Dw2DnrLrvH5hVaHocOdzB6bP/2gNVj
	3slAj/vdx5k8Pm+SC2CP4rJJSc3JLEst0rdL4Mpob1/HWLCNv+Lo9K3sDYw3eLoYOTkkBEwk
	Ts57yQhhi0lcuLeerYuRi0NIYCmjxNmHcxhhiv58WcYCYgsJLGKU2HQ+G6LoN6PEpPO32UAS
	bAKqEhNX3AfrFhFoZ5T49P8HmMMssJpR4tj+E8wQ7c4Su7v3gNmcAi4Svx9vZwKxhQX8JR62
	94JNYgGa1P1xO1ANBwevgK3EiVMGIGFeAUGJH5PvgV3BLKAlsX7ncSYIW15i85q3YOUSAuoS
	j/7qgoRFBIwk2o7PhCoRkdj34h0jyDkSAn/ZJVr2/WKCWCUg8W3yIRaIXlmJTQeYIR6WlDi4
	4gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzCuT/97
	1reD8eYB60OMyUDrJzJLiSbnA9NCXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoYy+6fnW3zRjvrqPryVee/Cd+YeGhjR2O1W+ycC4kPdKwffylK
	sy8LWXw9xGKfvcVG5g9cKn+u5ybfaGqaZ7LwY/ub7kmfhGKnvtuYcyqXWzVy++VdvEe8eSef
	sw8qVd4mcHp73RP3487aoorn+FcdPScTe20qN/tC42S9b4mhFjdPKLN8mKJ2U4mlOCPRUIu5
	qDgRAHFotK4BAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAV2rMI0gg/nLTSx6z51kspjXepTF
	4srX92wWz27tZbJY8tLO4uaPyywWJ/o+sFpc3jWHzYHDY+esu+wem1doeRw63MHosf3bA1aP
	eScDPe53H2fy+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jRnv7
	OsaCbfwVR6dvZW9gvMHTxcjJISFgIvHnyzIWCFtM4sK99WwgtpDAIkaJTeezuxi5gOzfjBKT
	zt8GS7AJqEpMXHGfDSQhItDOKPHp/w8wh1lgNaPEsf0nmCHanSV2d+8BszkFXCR+P97OBGIL
	C/hLPGzvBZvEAjSp++N2oBoODl4BW4kTpwxAwrwCghI/Jt8Du4hZQEti/c7jTBC2vMTmNW/B
	yiUE1CUe/dUFCYsIGEm0HZ8JVSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOGk8k9rBuLLB4hCjAAejEg9vg7F6kBBrYllxZe4hRgkOZiUR
	XouVQCHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OBya0vJJ4Q2MTMyNLI3NDCyNjc9KElcR5
	D7RaBwoJpCeWpGanphakFsFsYeLglGpgLHn2X2BGXsJSDTVVmdWNj12WntrBxrRUYJpKcait
	04My3QXLpxt4662SVSlqj7VVDYhLfx5ep7FOfM2DX+KKZzdrn2WJ1Huva1NX46Nwav6k8L/W
	c+bMT1S9Gjfx47QNcodv8E+wYODy5TJJLqt1UGu2TFsYs+Fgg72lQMj0J5Lmh5Zx+GQpsRRn
	JBpqMRcVJwIAaoW9Z14DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Geert Uytterhoeven [mailto:geert@linux-m68k.org]
> Sent: Thursday, September 05, 2013 5:21 PM
> To: David Herrmann; H. Peter Anvin
> Cc: Inki Dae; David Airlie; Geoff Levand; dri-devel@lists.freedesktop.org;
> linux-fbdev@vger.kernel.org; linux-kernel@vger.kernel.org; Geert
> Uytterhoeven
> Subject: [PATCH] video/drm: Drop superfluous "select
> VT_HW_CONSOLE_BINDING"
> 
> commit 765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92 ("fbdev: fbcon: select
> VT_HW_CONSOLE_BINDING") made FRAMEBUFFER_CONSOLE always select
> VT_HW_CONSOLE_BINDING, but forgot to remove
> 
> 	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
> 
> from the individual drivers' sections that already did this before.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/gpu/drm/exynos/Kconfig |    1 -
>  drivers/video/Kconfig          |    1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/Kconfig
> b/drivers/gpu/drm/exynos/Kconfig
> index 772c62a..1344d34 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -5,7 +5,6 @@ config DRM_EXYNOS
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> -	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>  	help
>  	  Choose this option if you have a Samsung SoC EXYNOS chipset.
>  	  If M is selected the module will be called exynosdrm.
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 9788340..f60e3fa 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2174,7 +2174,6 @@ config FB_PS3
>  	select FB_SYS_COPYAREA
>  	select FB_SYS_IMAGEBLIT
>  	select FB_SYS_FOPS
> -	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
>  	---help---
>  	  Include support for the virtual frame buffer in the PS3 platform.

Signed-off-by: Inki Dae <inki.dae@samsung.com>

Thanks,
Inki Dae

> 
> --
> 1.7.9.5

