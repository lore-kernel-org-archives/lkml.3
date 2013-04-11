Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab3DKSq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:46:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61782 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3DKSqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:46:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>, Roger Quadros <rogerq@ti.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130410173921.GA31017@kahuna>
Cc: Tony Lindgren <tony@atomide.com>, <linux-usb@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <grygorii.strashko@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <515D2D30.3000306@ti.com> <515EA9E3.1010409@ti.com>
 <20130405155851.GA10155@atomide.com> <5163E589.1040809@ti.com>
 <20130409164928.GL10155@atomide.com> <20130409174319.GP10155@atomide.com>
 <20130409204900.GA8815@kahuna> <20130410080630.14359.68178@quantum>
 <5165453E.6090503@ti.com> <20130410173921.GA31017@kahuna>
Message-ID: <20130411184648.7915.17500@quantum>
User-Agent: alot/0.3.4
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for AUXCLKs
Date: Thu, 11 Apr 2013 11:46:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2013-04-10 10:39:21)
> diff --git a/drivers/clk/omap/clk.c b/drivers/clk/omap/clk.c
> new file mode 100644
> index 0000000..63a4cce
> --- /dev/null
> +++ b/drivers/clk/omap/clk.c
> @@ -0,0 +1,94 @@
> +/*
> + * Texas Instruments OMAP Clock driver
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *     Nishanth Menon
> + *     Tony Lindgren <tony@atomide.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clkdev.h>
> +#include <linux/clk-private.h>

Please use clk-provider.h.  Otherwise this looks like an OK transitional
solution.  Hopefully this will be replaced with a more legitimate clock
driver for 3.11.

Regards,
Mike
