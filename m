Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3DKEej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:34:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50558 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3DKEeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:34:36 -0400
X-AuditID: cbfee68d-b7f786d000005188-68-51663d5bdfe3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-14-git-send-email-arnd@arndb.de>
In-reply-to: <1365638712-1028578-14-git-send-email-arnd@arndb.de>
Subject: Re: [PATCH 13/30] video/s3c: move platform_data out of arch/arm
Date: Thu, 11 Apr 2013 13:34:34 +0900
Message-id: <003001ce366d$de38c280$9aaa4780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac42SHpvEpDekeWjQq2dvIBR/FGzVAAJQatg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zA91o27RAg3WrWSz+TjrGbvHykKbF
	5YWXWC16F1xls9j0+BqrxYm+D6wWl3fNYbOYcX4fk8X6+bfYHDg9fv+axOixeUm9R9+WVYwe
	x29sZ/L4vEkugDWKyyYlNSezLLVI3y6BK6Nph3bBS72KY1vfsDYwtql2MXJySAiYSDycv4kR
	whaTuHBvPVsXIxeHkMAyRokjH5ewwxRd7XrADGILCUxnlLjbzQJR9ItRomldA1iCTUBN4suX
	w2ANIgKeEmdOLgArYha4wSjRPeMdaxcjB1BHmcSBbn+QGk4BR4n7n2+C1QsLeEg8b73ABGKz
	CKhKdK//zgJSzitgK7HonQRImFdAUOLH5HssIDazgJbE5m1NrBC2vMTmNW+ZQcolBNQlHv3V
	hbjASGLjknvsECUiEvtevGMEuUZC4C+7xOKD3xkhVglIfJt8iAWiV1Zi0wFmiHclJQ6uuMEy
	gVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECInk3h2Mtw9Y
	H2JMBlo/kVlKNDkfmAjySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8q
	zUktPsTIxMEp1cAoKfOcaVa5mdqOL9PWPJ8X8ItbRXCqyQOuc6+um+7bkdNwTL74WH/DsniT
	b3e6Kpzc9DiMVr9X7XsjyrJnmYjLrkexF7o7VTRenTY+LCViavp94vrp3la7RctWLZp//zbr
	49UrGZdvWtdTbLfVU/ntMqfaFf982lojbqlwuqrpstzpP7P/1NmdSizFGYmGWsxFxYkA/Uxv
	ZPoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQd0o27RAg2OrbSz+TjrGbvHykKbF
	5YWXWC16F1xls9j0+BqrxYm+D6wWl3fNYbOYcX4fk8X6+bfYHDg9fv+axOixeUm9R9+WVYwe
	x29sZ/L4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWNG0w7tgpd6
	Fce2vmFtYGxT7WLk5JAQMJG42vWAGcIWk7hwbz0biC0kMJ1R4m43SxcjF5D9i1GiaV0DWBGb
	gJrEly+H2UFsEQFPiTMnF4AVMQvcYJTonvGOtYuRA6ijTOJAtz9IDaeAo8T9zzfB6oUFPCSe
	t15gArFZBFQlutd/ZwEp5xWwlVj0TgIkzCsgKPFj8j0WEJtZQEti87YmVghbXmLzmrfMIOUS
	AuoSj/7qQlxgJLFxyT12iBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5
	RnrFibnFpXnpesn5uZsYwWnimfQOxlUNFocYBTgYlXh4TzSkBgqxJpYVV+YeYpTgYFYS4eXa
	CRTiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGAKyyuJNzQ2MTOyNDKzMDIxNydNWEmc92Cr
	daCQQHpiSWp2ampBahHMFiYOTqkGRov5+UJP1q/dprr/V/8x5qVnb1+qTNx6rczqsqrIuyk6
	IgtKj+/mvzqt7vWC/c+dLrs8DmeSvD1ZwzRDZ4vwYf3DWaeZJObsDUxbuIW9+0naotmrboQl
	uzKkt91b+HW26wOLe0vkb2X/Ef/iE3oo8krwjEatRsmLr9gUi4xE2V63qxaz1yQksyixFGck
	GmoxFxUnAgA36SYLVwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 11, 2013 9:05 AM, Arnd Bergmann wrote:
> 
> The s3c-fb driver requires header files from the samsung platforms
> to find its platform_data definition, but this no longer works on
> multiplatform kernels, so let's move the data into a new header
> file under include/linux/platform_data.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-fbdev@vger.kernel.org
> Cc: Jingoo Han <jg1.han@samsung.com>

CC'ed Tomi Valkeinen.


Hi Arnd,
It looks good. Thank you for your patch. :)

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  arch/arm/plat-samsung/include/plat/fb.h | 50 +-----------------------------
>  drivers/video/s3c-fb.c                  |  3 +-
>  include/linux/platform_data/video_s3c.h | 54 +++++++++++++++++++++++++++++++++
>  3 files changed, 56 insertions(+), 51 deletions(-)
>  create mode 100644 include/linux/platform_data/video_s3c.h
> 
> diff --git a/arch/arm/plat-samsung/include/plat/fb.h b/arch/arm/plat-samsung/include/plat/fb.h
> index b885322..9ae5072 100644
> --- a/arch/arm/plat-samsung/include/plat/fb.h
> +++ b/arch/arm/plat-samsung/include/plat/fb.h
> @@ -15,55 +15,7 @@
>  #ifndef __PLAT_S3C_FB_H
>  #define __PLAT_S3C_FB_H __FILE__
> 
> -/* S3C_FB_MAX_WIN
> - * Set to the maximum number of windows that any of the supported hardware
> - * can use. Since the platform data uses this for an array size, having it
> - * set to the maximum of any version of the hardware can do is safe.
> - */
> -#define S3C_FB_MAX_WIN	(5)
> -
> -/**
> - * struct s3c_fb_pd_win - per window setup data
> - * @xres     : The window X size.
> - * @yres     : The window Y size.
> - * @virtual_x: The virtual X size.
> - * @virtual_y: The virtual Y size.
> - */
> -struct s3c_fb_pd_win {
> -	unsigned short		default_bpp;
> -	unsigned short		max_bpp;
> -	unsigned short		xres;
> -	unsigned short		yres;
> -	unsigned short		virtual_x;
> -	unsigned short		virtual_y;
> -};
> -
> -/**
> - * struct s3c_fb_platdata -  S3C driver platform specific information
> - * @setup_gpio: Setup the external GPIO pins to the right state to transfer
> - *		the data from the display system to the connected display
> - *		device.
> - * @vidcon0: The base vidcon0 values to control the panel data format.
> - * @vidcon1: The base vidcon1 values to control the panel data output.
> - * @vtiming: Video timing when connected to a RGB type panel.
> - * @win: The setup data for each hardware window, or NULL for unused.
> - * @display_mode: The LCD output display mode.
> - *
> - * The platform data supplies the video driver with all the information
> - * it requires to work with the display(s) attached to the machine. It
> - * controls the initial mode, the number of display windows (0 is always
> - * the base framebuffer) that are initialised etc.
> - *
> - */
> -struct s3c_fb_platdata {
> -	void	(*setup_gpio)(void);
> -
> -	struct s3c_fb_pd_win	*win[S3C_FB_MAX_WIN];
> -	struct fb_videomode     *vtiming;
> -
> -	u32			 vidcon0;
> -	u32			 vidcon1;
> -};
> +#include <linux/platform_data/video_s3c.h>
> 
>  /**
>   * s3c_fb_set_platdata() - Setup the FB device with platform data.
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index 968a625..2e7991c 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -24,10 +24,9 @@
>  #include <linux/uaccess.h>
>  #include <linux/interrupt.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/platform_data/video_s3c.h>
> 
>  #include <video/samsung_fimd.h>
> -#include <mach/map.h>
> -#include <plat/fb.h>
> 
>  /* This driver will export a number of framebuffer interfaces depending
>   * on the configuration passed in via the platform data. Each fb instance
> diff --git a/include/linux/platform_data/video_s3c.h b/include/linux/platform_data/video_s3c.h
> new file mode 100644
> index 0000000..fa40f96
> --- /dev/null
> +++ b/include/linux/platform_data/video_s3c.h
> @@ -0,0 +1,54 @@
> +#ifndef __PLATFORM_DATA_VIDEO_S3C
> +#define __PLATFORM_DATA_VIDEO_S3C
> +
> +/* S3C_FB_MAX_WIN
> + * Set to the maximum number of windows that any of the supported hardware
> + * can use. Since the platform data uses this for an array size, having it
> + * set to the maximum of any version of the hardware can do is safe.
> + */
> +#define S3C_FB_MAX_WIN	(5)
> +
> +/**
> + * struct s3c_fb_pd_win - per window setup data
> + * @xres     : The window X size.
> + * @yres     : The window Y size.
> + * @virtual_x: The virtual X size.
> + * @virtual_y: The virtual Y size.
> + */
> +struct s3c_fb_pd_win {
> +	unsigned short		default_bpp;
> +	unsigned short		max_bpp;
> +	unsigned short		xres;
> +	unsigned short		yres;
> +	unsigned short		virtual_x;
> +	unsigned short		virtual_y;
> +};
> +
> +/**
> + * struct s3c_fb_platdata -  S3C driver platform specific information
> + * @setup_gpio: Setup the external GPIO pins to the right state to transfer
> + *		the data from the display system to the connected display
> + *		device.
> + * @vidcon0: The base vidcon0 values to control the panel data format.
> + * @vidcon1: The base vidcon1 values to control the panel data output.
> + * @vtiming: Video timing when connected to a RGB type panel.
> + * @win: The setup data for each hardware window, or NULL for unused.
> + * @display_mode: The LCD output display mode.
> + *
> + * The platform data supplies the video driver with all the information
> + * it requires to work with the display(s) attached to the machine. It
> + * controls the initial mode, the number of display windows (0 is always
> + * the base framebuffer) that are initialised etc.
> + *
> + */
> +struct s3c_fb_platdata {
> +	void	(*setup_gpio)(void);
> +
> +	struct s3c_fb_pd_win	*win[S3C_FB_MAX_WIN];
> +	struct fb_videomode     *vtiming;
> +
> +	u32			 vidcon0;
> +	u32			 vidcon1;
> +};
> +
> +#endif
> --
> 1.8.1.2

