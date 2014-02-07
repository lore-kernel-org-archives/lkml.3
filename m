Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBGKtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:49:19 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:32973 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaBGKtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:49:18 -0500
Date: Fri, 7 Feb 2014 10:49:12 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 08/15] mfd: max77836: Add max77836 support to max14577
 driver
Message-ID: <20140207104912.GJ14727@lee--X1>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-9-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391767487-10017-9-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add Maxim 77836 support to max14577 driver. The chipsets have same MUIC
> component so the extcon, charger and regulators are almost the same. The
> max77836 however has also PMIC and Fuel Gauge.
> 
> The MAX77836 uses three I2C slave addresses and has additional interrupts
> (related to PMIC and Fuel Gauge). It has also Interrupt Source register,
> just like MAX77686 and MAX77693.
> 
> The MAX77836 PMIC's TOPSYS and INTSRC interrupts are reported in the
> PMIC block. The PMIC block has different I2C slave address and uses own
> regmap so another regmap_irq_chip is needed.
> 
> Since we have two regmap_irq_chip, use shared interrupts on MAX77836.
> 
> This patch adds additional defines and functions to the max14577 MFD core
> driver so the driver will handle both chipsets. Also this patch replaces
> "0x1 << N" with BIT(N) in defines for register masks.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

My Ack is missing from this patch too.

... and probably all the others? How will I know which ones I've
already Acked without reviewing them all again?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
