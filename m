Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3FKKhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:37:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55973 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3FKKhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:37:06 -0400
Message-ID: <51B6FDA2.8080003@ti.com>
Date: Tue, 11 Jun 2013 16:06:18 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] ARM: davinci: GPIO: Add platform data structure
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com> <1369206634-6778-2-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1369206634-6778-2-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2013 12:40 PM, Philip Avinash wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> Add struct davinci_gpio_platform_data davinci gpio module.
> 
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

As Linus commented before, this should be merged with 03/11.

> ---
>  include/linux/platform_data/gpio-davinci.h |   27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 include/linux/platform_data/gpio-davinci.h
> 
> diff --git a/include/linux/platform_data/gpio-davinci.h b/include/linux/platform_data/gpio-davinci.h
> new file mode 100644
> index 0000000..f1c8277
> --- /dev/null
> +++ b/include/linux/platform_data/gpio-davinci.h
> @@ -0,0 +1,27 @@
> +/*
> + * gpio-davinci.h

I would drop this unnecessary filename mention as well.

> + *
> + * DaVinci GPIO Platform Related Defines
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __ASM_ARCH_DAVINCI_GPIO_H
> +#define __ASM_ARCH_DAVINCI_GPIO_H

This should now be __PLATFORM_DATA_DAVINCI_GPIO_H__ or some such since
the file as been moved out of arch specific folder.

Thanks,
Sekhar
