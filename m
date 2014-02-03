Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaBCJp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:45:26 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39540 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBCJpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:45:24 -0500
Date: Mon, 3 Feb 2014 09:45:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 09/18] mfd: max14577: Add "muic" suffix to regmap and
 irq_chip
Message-ID: <20140203094518.GJ13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-10-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390911522-28209-10-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch continues the preparation for adding support for max77836
> device to existing max14577 driver.
> 
> Add "muic" suffix to regmap and irq_data fields in maxim_core state
> container to prepare for max77836 support.
> This is only a rename-like patch, new code is not added.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c     |   17 +++++++++--------
>  drivers/mfd/max14577.c               |   22 +++++++++++-----------
>  drivers/power/max14577_charger.c     |    8 ++++----
>  drivers/regulator/max14577.c         |    2 +-
>  include/linux/mfd/max14577-private.h |    4 ++--
>  5 files changed, 27 insertions(+), 26 deletions(-)

Happy to apply this with maintainer Acks.
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
