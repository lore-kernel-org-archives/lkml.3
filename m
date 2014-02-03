Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaBCJnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:43:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41572 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaBCJnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:43:03 -0500
Date: Mon, 3 Feb 2014 09:42:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 08/18] mfd: max14577: Rename state container to maxim_core
Message-ID: <20140203094258.GI13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-9-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390911522-28209-9-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch continues the preparation for adding support for max77836
> device to existing max14577 driver.
> 
> The patch renames the struct "max14577" state container to "maxim_core".
> This is only a rename-like patch, new code is not added.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c     |   22 +++++------
>  drivers/mfd/max14577.c               |   68 +++++++++++++++++-----------------
>  drivers/power/max14577_charger.c     |   16 ++++----
>  drivers/regulator/max14577.c         |    6 +--
>  include/linux/mfd/max14577-private.h |    5 ++-
>  5 files changed, 60 insertions(+), 57 deletions(-)

Need some more maintainer Acks here.

> -struct max14577 {
> +/*
> + * State container for max14577-like drivers.
> + */

I don't think this comment is required.

Besides that, the code looks fine:
  Acked-by: Lee Jones <lee.jones@linaro.org>

> +struct maxim_core {
>  	struct device *dev;
>  	struct i2c_client *i2c; /* Slave addr = 0x4A */
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
