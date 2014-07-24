Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbaGXE2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:28:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39949 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaGXE2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:28:42 -0400
X-AuditID: cbfee68f-b7fef6d000003970-15-53d08b70f6a1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1406106243-20498-1-git-send-email-linus.walleij@linaro.org>
In-reply-to: <1406106243-20498-1-git-send-email-linus.walleij@linaro.org>
Subject: Re: [PATCH v2] fb: backlight: add driver for iPAQ micro backlight
Date: Thu, 24 Jul 2014 13:28:31 +0900
Message-id: <001501cfa6f7$b9b7ff10$2d27fd30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+mVVGwmxGsfw7SQEyLOSFuNi3fYAAofIzg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zQ92C7gvBBrO38Vkc3TmRyeLywkus
	Fve/HmW0mPJnOZC7aw6bA6vHzll32T3uXNvD5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	X1rvMBcs5atYf7mJpYHxDHcXIyeHhICJxItl15ghbDGJC/fWs3UxcnEICSxjlJjS8IIdpmhx
	0ysWiMQiRokNS6ZDVf1mlPi/6xILSBWbgJrEly+HwTpEBPQk3nxtAbOZBboZJW7cCAOxhQQ8
	JGZuusYEYnMKeEq8mPWDFcQWFvCS6H62iw3EZhFQldizbw3YTF4BW4ll3S1QtqDEj8n3WCBm
	akms33mcCcKWl9i85i3QCxxAl6pLPPqrC3GCkcTGpa/YIEpEJPa9eMcIcrOEwDl2ie6XDcwQ
	uwQkvk0+xALRKyux6QA0JCQlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y
	1itOzC0uzUvXS87P3cQIidD+HYx3D1gfYkwGWj+RWUo0OR8Y4Xkl8YbGZkYWpiamxkbmlmak
	CSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVHSb4vSFcX+6F1yj06msrLa7NfX
	5bvi+HDPnZ788OjTMiyvulMD1UOZa9h1mZVrGmWcLP8tMnkvIyvW3X8h9Klh4+Zjj3N609i3
	TN6n+juqJWHOgbZFfl19fUe9Uhd6LL7/Q2Nu1KPj7+aaFRwNz5rCcUF/+7qNp5+oXOcO/ibT
	/e5lwJ1p35VYijMSDbWYi4oTAa8r0TbmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG5B94Vgg0mvuCyO7pzIZHF54SVW
	i/tfjzJaTPmzHMjdNYfNgdVj56y77B53ru1h8+jbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygxUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjC+td5gLlvJVrL/cxNLAeIa7i5GTQ0LARGJx0ysWCFtM
	4sK99WxdjFwcQgKLGCU2LJkO5fxmlPi/6xJYFZuAmsSXL4fZQWwRAT2JN19bwGxmgW5GiRs3
	wkBsIQEPiZmbrjGB2JwCnhIvZv1gBbGFBbwkup/tYgOxWQRUJfbsWwM2k1fAVmJZdwuULSjx
	Y/I9FoiZWhLrdx5ngrDlJTavecvcxcgBdKm6xKO/uhAnGElsXPqKDaJERGLfi3eMExiFZiGZ
	NAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnD8P5PawbiyweIQowAH
	oxIPb8fe88FCrIllxZW5hxglOJiVRHhLSy8EC/GmJFZWpRblxxeV5qQWH2I0BXp0IrOUaHI+
	MDXllcQbGpuYGVkamVkYmZibK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgdPg812DbRNbq
	s38q8iXs+S68vW94LaJt5TeRNR9vegh538vZ8GXmdMODU0v0IqKuTvri5bxx4u5Wd7fsHDUO
	mZ0H5I48sbnumal4eM+fdeeKD/fPnu8m7FGheW3iW51zKgH7bPQZPzxsSTPK/PzsJZ+dlrWi
	dORx7lc5xvICsx4Evp1hllfPrcRSnJFoqMVcVJwIANKvpmMVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 6:04 PM, Linus Walleij wrote:
> 
> This adds a driver for the backlight controlled by the microcontroller
> on the Compaq iPAQ series of handheld computers: h3100, h3600
> and h3700.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Add a comment to clarify message format
> - Coding format and style fixes
> - Drop driver announce boilerplate
> - Drop empty remove() function
> ---
>  drivers/video/backlight/Kconfig         |  9 ++++
>  drivers/video/backlight/Makefile        |  1 +
>  drivers/video/backlight/ipaq_micro_bl.c | 83 +++++++++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+)
>  create mode 100644 drivers/video/backlight/ipaq_micro_bl.c

[.....]

> --- /dev/null
> +++ b/drivers/video/backlight/ipaq_micro_bl.c
> @@ -0,0 +1,83 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * iPAQ microcontroller backlight support
> + * Author : Linus Walleij <linus.walleij@linaro.org>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/backlight.h>
> +#include <linux/mfd/ipaq-micro.h>
> +#include <linux/fb.h>
> +#include <linux/err.h>

Would you re-order these headers alphabetically?
It enhances the readability.

[.....]

> +MODULE_LICENSE("GPL");

How about using "GPL v2" as below?
+MODULE_LICENSE("GPL v2");

Others look good. Thanks.
Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> +MODULE_DESCRIPTION("driver for iPAQ Atmel micro backlight");
> +MODULE_ALIAS("platform:ipaq-micro-backlight");
> --
> 1.9.3

