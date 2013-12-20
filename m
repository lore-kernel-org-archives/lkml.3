Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266Ab3LTN6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:58:24 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52366 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190Ab3LTN6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:58:22 -0500
Date: Fri, 20 Dec 2013 13:58:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/2] mfd: max77693: Set proper maximum register for MUIC
 regmap
Message-ID: <20131220135816.GF3709@lee--X1>
References: <1387532108-9813-1-git-send-email-k.kozlowski@samsung.com>
 <1387532108-9813-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387532108-9813-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Krzysztof Kozlowski wrote:

> The MUIC block in max77693 has different I2C address than PMIC. The
> driver allocated two regmaps: for PMIC and MUIC. However it used the
> same regmap_config (with max_register field) for both regmaps. Actual
> maximum address of register for MUIC is different than for PMIC.
> 
> Define another regmap_config for MUIC with proper max_register value.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mfd/max77693.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
