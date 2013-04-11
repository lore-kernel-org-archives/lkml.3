Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765006Ab3DKWlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:41:02 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:60615 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3DKWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:40:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130411184648.7915.17500@quantum>
References: <515D2D30.3000306@ti.com>
	<515EA9E3.1010409@ti.com>
	<20130405155851.GA10155@atomide.com>
	<5163E589.1040809@ti.com>
	<20130409164928.GL10155@atomide.com>
	<20130409174319.GP10155@atomide.com>
	<20130409204900.GA8815@kahuna>
	<20130410080630.14359.68178@quantum>
	<5165453E.6090503@ti.com>
	<20130410173921.GA31017@kahuna>
	<20130411184648.7915.17500@quantum>
Date: Thu, 11 Apr 2013 17:40:57 -0500
X-Google-Sender-Auth: pJmtcDvPrFUNRRuFFkPJX0WKVLw
Message-ID: <CAGo_u6qTuPsGWz0LYxoTVKeMY2TAvfbH_WR9NDS9XoTvSUOxfw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for AUXCLKs
From: Nishanth Menon <nm@ti.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Roger Quadros <rogerq@ti.com>, grygorii.strashko@ti.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        balbi@ti.com, linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 1:46 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Nishanth Menon (2013-04-10 10:39:21)
>> diff --git a/drivers/clk/omap/clk.c b/drivers/clk/omap/clk.c
>> new file mode 100644
>> index 0000000..63a4cce
>> --- /dev/null
>> +++ b/drivers/clk/omap/clk.c
>> @@ -0,0 +1,94 @@
>> +/*
>> + * Texas Instruments OMAP Clock driver
>> + *
>> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
>> + *     Nishanth Menon
>> + *     Tony Lindgren <tony@atomide.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/clkdev.h>
>> +#include <linux/clk-private.h>
>
> Please use clk-provider.h.  Otherwise this looks like an OK transitional
k. thanks for checking up on this. will update.
> solution.  Hopefully this will be replaced with a more legitimate clock
> driver for 3.11.
I hope so too. At least we should start debate with the direction we'd
like to take and start migrating towards that purpose.

Regards,
Nishanth Menon
