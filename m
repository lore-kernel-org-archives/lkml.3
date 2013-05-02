Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794Ab3EBSd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:33:56 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:51478 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761776Ab3EBSdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:33:53 -0400
Message-ID: <5182B18C.4080404@gmail.com>
Date: Thu, 02 May 2013 20:33:48 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 08:25 PM, Sebastian Hesselbarth wrote:
> This patch adds an irqchip driver for the main interrupt controller found
> on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
> Corresponding device tree documentation is also added.
>
> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> ---
> Note: This patch triggers a checkpatch warning for
>    WARNING: Avoid CamelCase:<handle_IRQ>
>
[...]
> diff --git a/include/linux/irqchip/orion.h b/include/linux/irqchip/orion.h
> new file mode 100644
> index 0000000..04f7bab
> --- /dev/null
> +++ b/include/linux/irqchip/orion.h
> @@ -0,0 +1,18 @@
> +/*
> + * Marvell Orion SoCs IRQ chip driver header.
> + *
> + * Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef __LINUX_IRQCHIP_ORION_H
> +#define __LINUX_IRQCHIP_ORION_H
> +
> +#include<asm/exception.h>

First review by myself. The above include is a left-over and
will be removed in a v2.

> +
> +extern void orion_init_irq(void);
> +
> +#endif

