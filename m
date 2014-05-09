Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaEIOBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:01:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46037 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751520AbaEIOBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:01:20 -0400
Message-ID: <536CDFAE.8070208@free-electrons.com>
Date: Fri, 09 May 2014 16:01:18 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 3/7] mfd: add support for sun6i PRCM (Power/Reset/Clock
 Management) unit
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com> <1399633911-7094-4-git-send-email-boris.brezillon@free-electrons.com> <20140509135251.GY5767@lee--X1>
In-Reply-To: <20140509135251.GY5767@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/05/2014 15:52, Lee Jones wrote:
>> The PRCM (Power/Reset/Clock Management) block exposes several subdevices
>> in different subsystems (clk, reset ...)
>>
>> Add basic support for the PRCM unit with clk (AR100, AHB0, and APB0 clks)
>> and reset controller subdevices.
>>
>> Other subdevices might be added later (if needed).
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  drivers/mfd/Kconfig      |   8 +++
>>  drivers/mfd/Makefile     |   1 +
>>  drivers/mfd/sun6i-prcm.c | 134 +++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 143 insertions(+)
>>  create mode 100644 drivers/mfd/sun6i-prcm.c
> [...]
>
>> +/*
>> + * Copyright (C) 2014 Free Electrons
>> + *
>> + * License Terms: GNU General Public License v2
>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> + *
>> + * Allwinner PRCM (Power/Reset/Clock Management) driver
>> + *
>> + */
>> +
>> +#include <linux/mfd/core.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
> Ah, now isn't that better?

Absolutely :-).

> Acked-by: Lee Jones <lee.jones@linaro.org>
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

