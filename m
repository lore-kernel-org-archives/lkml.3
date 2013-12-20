Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab3LTN46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:56:58 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:54910 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030211Ab3LTN44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:56:56 -0500
Date: Fri, 20 Dec 2013 13:56:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: max77686: fix regmap resource leak on driver
 remove
Message-ID: <20131220135647.GE3709@lee--X1>
References: <1387532108-9813-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387532108-9813-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Krzysztof Kozlowski wrote:

> The regmap used by max77686 MFD driver was not freed with regmap_exit()
> on driver exit. This lead to leak of resources.
> 
> Replace regmap_init_i2c() call in driver probe with initialization of
> managed register map so the regmap will be properly freed by the device
> management code.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/max77686.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Always happy to move to managed resources.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
