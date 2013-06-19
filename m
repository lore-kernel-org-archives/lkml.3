Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644Ab3FSKw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:52:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38726 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011Ab3FSKwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:52:55 -0400
Message-ID: <51C18D65.6010009@ti.com>
Date: Wed, 19 Jun 2013 16:22:21 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] gpio: davinci: coding style correction
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com> <1371202532-14628-2-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1371202532-14628-2-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2013 3:05 PM, Philip Avinash wrote:
> Make some minor coding style fixes. Use proper multi-line
> commenting style, arrange include files alphabetically use
> macros for bit definitions.

Its a register offset, not bit definition.

> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
> Changes since v1:
> 	- Remove variable name replacement
> 	- Add line break after BINTEN macro definition
> 
>  drivers/gpio/gpio-davinci.c |   21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index 17df6db..e8d189c 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -9,12 +9,12 @@
>   * the Free Software Foundation; either version 2 of the License, or
>   * (at your option) any later version.
>   */
> -#include <linux/gpio.h>
> -#include <linux/errno.h>
> -#include <linux/kernel.h>
> +

This is unnecessary empty line. I made these fixes locally and added
this to my v3.11/gpio branch.

Thanks,
Sekhar
