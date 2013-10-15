Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3JOAhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:37:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16530 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3JOAhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:37:43 -0400
X-AuditID: cbfee68e-b7f486d0000040b6-17-525c8e536d49
From: Jingoo Han <jg1.han@samsung.com>
To: "=?ISO-8859-1?Q?'Maximilian_G=FCntner'?=" 
	<maximilian.guentner@gmail.com>
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'linux-leds'" <linux-leds@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <2819232.mPNW6mO2uH@titan>
In-reply-to: <2819232.mPNW6mO2uH@titan>
Subject: Re: [PATCH] leds: Added driver for the NXP PCA9685 I2C chip
Date: Tue, 15 Oct 2013 09:37:38 +0900
Message-id: <006b01cec93e$c00a2a10$401e7e30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7JA0krcX1xZ2cWTxyOTwA3HvAkkgAOh8xg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA93gvpggg7PnpCyO7pzIZHF54SVW
	i8u75rBZbH2zjtHi5smb7Ba7dz1ldWDz2DnrLrvHnvk/WD36tqxi9Pi8SS6AJYrLJiU1J7Ms
	tUjfLoErY/2j0+wFF7gqzp36ztbAuJmji5GTQ0LARGL73StsELaYxIV764FsLg4hgWWMEj9n
	NLLCFO26dZEZIrGIUWLx6ktgCSGBX4wSLe9zQGw2ATWJL18Os4PYIgLeEj/m7WIFaWAWOM0o
	cepEF1SDmsT9t4tYQGxOAXWJmxc6GUFsYQEXiY/rFoPZLAKqEnfW9IHV8ArYSnz78IINwhaU
	+DH5HlicWUBHYn/rNDYIW1viybsLQPM5gC5Vl3j0VxfiBiOJv5tXMkGUiEjse/GOEeQeCYF7
	7BLzdm9ihtglIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0
	tSC5oDgpvchIrzgxt7g0L10vOT93EyMkVvt2MN48YH2IMRlo/URmKdHkfGCs55XEGxqbGVmY
	mpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUXBzS/7Ro/Nmh/lM
	lercXKEWdD2Nw83nariolfFWJ/2Gt43bBYMPpR3NSJnWeo5lSofe61+VU2Ik9nzsk7+26scJ
	52WTjnLq/gl4d6ebo5HzgbzhClbFJZejm355WR7evGKBv3vBv6k5bzh6zVy+xF8Q2aa75bqx
	2fn6vbPYjzev5r0R188goMRSnJFoqMVcVJwIAL9hedvrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd3gvpggg/M7xCyO7pzIZHF54SVW
	i8u75rBZbH2zjtHi5smb7Ba7dz1ldWDz2DnrLrvHnvk/WD36tqxi9Pi8SS6AJaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWP9o9PsBRe4Ks6d+s7WwLiZo4uRk0NCwERi
	162LzBC2mMSFe+vZuhi5OIQEFjFKLF59iRUkISTwi1Gi5X0OiM0moCbx5cthdhBbRMBb4se8
	XawgDcwCpxklTp3ogmpQk7j/dhELiM0poC5x80InI4gtLOAi8XHdYjCbRUBV4s6aPrAaXgFb
	iW8fXrBB2IISPybfA4szC+hI7G+dxgZha0s8eXcBaD4H0KXqEo/+6kLcYCTxd/NKJogSEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGJ4JnU
	DsaVDRaHGAU4GJV4eH/wxgQJsSaWFVfmHmKU4GBWEuHNqQYK8aYkVlalFuXHF5XmpBYfYkwG
	enQis5Rocj4wSeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A+NEzf82a6+ZLxGVtso4Hxo7+cx95SezV4tOfdU1WXfZ5BX7f8rtWnLFP5//WOKdkNMly2+u
	NtzJbMxiu+uDzkm10h8+bhJvfwt+nqBkIVnXlHLocMij2zNO8/7ol2T/0BrFGsitIWQ/kb3k
	7Vv7gF0blFasuKYySWXLwd2pC8t+Mn6/Y2FrbvdbiaU4I9FQi7moOBEAJg4duUgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 15, 2013 2:32 AM, Maximilian Guntner wrote:
> 
> The NXP PCA9685 supports 16 channels/leds using a 12-bit PWM (4095
> levels of brightness)
> This driver supports configuration using platform_data.
> 
> Signed-off-by: Maximilian Güntner <maximilian.guentner@gmail.com>

I added some nit-picking comments. :-)

> ---
>  drivers/leds/Kconfig                       |  10 ++
>  drivers/leds/Makefile                      |   1 +
>  drivers/leds/leds-pca9685.c                | 219 +++++++++++++++++++++++++++++
>  include/linux/platform_data/leds-pca9685.h |  34 +++++
>  4 files changed, 264 insertions(+)
>  create mode 100644 drivers/leds/leds-pca9685.c
>  create mode 100644 include/linux/platform_data/leds-pca9685.h
> 

[.....]

> +
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/delay.h>
> +#include <linux/ctype.h>
> +#include <linux/leds.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/workqueue.h>
> +#include <linux/slab.h>
> +
> +#include <linux/platform_data/leds-pca9685.h>

Please, sort these header inclusions alphabetically for
better readability.

[.....]

> +#ifndef __LINUX_PCA9685_H
> +#define __LINUX_PCA9685_H

You can add one empty line here.

> +#include <linux/leds.h>
> +

Best regards,
Jingoo Han

