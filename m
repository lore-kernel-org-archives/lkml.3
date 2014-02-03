Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBCJiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:38:17 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38167 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaBCJiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:38:16 -0500
Date: Mon, 3 Feb 2014 09:38:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 07/18] mfd: max14577: Rename and add MAX14577 symbols to
 prepare for max77836
Message-ID: <20140203093809.GH13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-8-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390911522-28209-8-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch prepares for adding support for max77836 device to existing
> max14577 driver:
> 1. Renames most of symbols and defines prefixed with MAX14577 to MAXIM.
> 2. Adds prefixes (MAXIM or MAX14577) to defines without any MAX* prefix.
> 
> This is only a rename-like patch, new code is not added.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c     |  105 ++++-----
>  drivers/mfd/max14577.c               |   51 ++---
>  drivers/power/max14577_charger.c     |   81 +++----
>  drivers/regulator/max14577.c         |   44 ++--
>  include/linux/mfd/max14577-private.h |  399 ++++++++++++++++------------------
>  include/linux/mfd/max14577.h         |    2 +-
>  6 files changed, 333 insertions(+), 349 deletions(-)

I think the name changes instil some clarity here.

I still need the other Acks before applying the patch though.

For now you can have my:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
