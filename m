Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaBQBzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 20:55:25 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22001 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaBQBzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 20:55:22 -0500
X-AuditID: cbfee690-b7f266d00000287c-2e-53016c075b1c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1392376711-11290-1-git-send-email-tomi.valkeinen@ti.com>
 <1392376711-11290-3-git-send-email-tomi.valkeinen@ti.com>
In-reply-to: <1392376711-11290-3-git-send-email-tomi.valkeinen@ti.com>
Subject: Re: [PATCH RFC 3/3] video: Kconfig: move drm and fb into separate menus
Date: Mon, 17 Feb 2014 10:55:19 +0900
Message-id: <000e01cf2b83$4f7a29b0$ee6e7d10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8pdpY1vQEsWtRVRFOS7y1BTrpBcgCDDJ5g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zA132HMZggw8XxSx6z51ksrjy9T2b
	xbNbe5ksLi+8xGrROXEJu8WJvg+sFpd3zWGzWPfwBZPF+vm32Bw4PWZ3zGT1eHXhDovHocMd
	jB7bvz1g9bjffZzJo2/LKkaP4ze2M3l83iQXwBHFZZOSmpNZllqkb5fAlTHhwW+mgr88FTu3
	H2JpYNzG1cXIySEhYCJxf94sNghbTOLCvfVANheHkMAyRonX576zwRQdWTsLKrGIUaLz/hMW
	COcXo8TPrbfAqtgE1CS+fDnMDpIQEegCSnz8yA6SYBb4wCjxtC0foqORUWLlog1gHZwCbhKH
	e7pYQWxhgQCJ2dseM4HYLAKqEnM+/gaKc3DwCthKnO8oBAnzCghK/Jh8jwVippbE+p3HmSBs
	eYnNa94yg5RLCKhLPPqrCxIWETCS2HplOitEiYjEvhfvGEFOkBCYyiExqfMuM8QqAYlvkw+x
	QPTKSmw6wAzxsaTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UUmesWJucWl
	eel6yfm5mxghMT9hB+O9A9aHGJOB1k9klhJNzgemjLySeENjMyMLUxNTYyNzSzPShJXEedUe
	JQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJwta/O20yW0fuElfu7t+04xro5xnypruUcq
	fFoq77wrU2qYz29qeNWaeDKzUPjr+vNhPsWbo/5MPX73yaOwCdKb53xe+iLd9tzPP5IdnC5X
	mTcqFsbzN793cJ3PXSCim72nXZDpC8OawxUCt84dYtj55PaNt26iLlUzjwno73q3WuvQAk7b
	/cVKLMUZiYZazEXFiQD62BA9DwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJKsWRmVeSWpSXmKPExsVy+t9jAV32HMZgg4kfBC16z51ksrjy9T2b
	xbNbe5ksLi+8xGrROXEJu8WJvg+sFpd3zWGzWPfwBZPF+vm32Bw4PWZ3zGT1eHXhDovHocMd
	jB7bvz1g9bjffZzJo2/LKkaP4ze2M3l83iQXwBHVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SgkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFjwoPfTAV/eSp2bj/E0sC4jauLkZNDQsBE4sjaWWwQtpjEhXvrgWwuDiGB
	RYwSnfefsEA4vxglfm69BVbFJqAm8eXLYXaQhIhAF1Di40d2kASzwAdGiadt+RAdjYwSKxdt
	AOvgFHCTONzTxQpiCwsESMze9pgJxGYRUJWY8/E3UJyDg1fAVuJ8RyFImFdAUOLH5HssEDO1
	JNbvPM4EYctLbF7zlhmkXEJAXeLRX12QsIiAkcTWK9NZIUpEJPa9eMc4gVFoFpJJs5BMmoVk
	0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCeUZ1I7GFc2WBxiFOBgVOLhvfDr
	f5AQa2JZcWXuIUYJDmYlEV73OMZgId6UxMqq1KL8+KLSnNTiQ4zJQH9OZJYSTc4HJru8knhD
	YxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDkfce+9UTzz44nQT+2
	6olMmyy74t2S6uhrzjsdzQ4eFlDW090m9jSns3Fr45FFWW/n7ZOdLLbn6+Hr119wK1Q3fDo3
	4VPd6/7CtvOeph1bjsou3p55e3f5Eg+1NJezzJZ/A95P3VejcWP6YqvEKe93ZllzaHj/Mg2X
	ZQvq9z9i361TczrTWkxRiaU4I9FQi7moOBEAvTVLtGwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 14, 2014 8:19 PM, Tomi Valkeinen wrote:
> 
> At the moment the "Device Drivers / Graphics support" kernel config page
> looks rather messy, with DRM and fbdev driver selections on the same
> page, some on the top level Graphics support page, some under their
> respective subsystems.
> 
> If I'm not mistaken, this is caused by the drivers depending on other
> things than DRM or FB, which causes Kconfig to arrange the options in
> not-so-neat manner.
> 
> Both DRM and FB have a main menuconfig option for the whole DRM or FB
> subsystem. Optimally, this would be enough to arrange all DRM and FB
> options under the respective subsystem, but for whatever reason this
> doesn't work reliably.
> 
> This patch adds an explicit submenu for DRM and FB, making it much
> clearer which options are related to FB, and which to DRM.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

I tested this patch. Menu becomes clearer!
Thanks.

Best regards,
Jingoo Han

> ---
>  drivers/video/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index f0f26a0b746e..70d174090a54 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -21,9 +21,13 @@ source "drivers/gpu/vga/Kconfig"
> 
>  source "drivers/gpu/host1x/Kconfig"
> 
> +menu "Direct Rendering Manager"
>  source "drivers/gpu/drm/Kconfig"
> +endmenu
> 
> +menu "Framebuffer Devices"
>  source "drivers/video/fbdev/Kconfig"
> +endmenu
> 
>  source "drivers/video/backlight/Kconfig"
> 
> --
> 1.8.3.2


