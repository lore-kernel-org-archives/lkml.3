Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3KHPwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:52:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61407 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3KHPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:52:09 -0500
Date: Fri, 8 Nov 2013 15:52:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] mfd: sec: reorder params in API for regmap
 consistency
Message-ID: <20131108155202.GZ30901@lee--X1>
References: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Nov 2013, Krzysztof Kozlowski wrote:

> The last two parameters of certain register access functions were in
> different order than regmap API. This was confusing and error-prone.
> 
> Reorder parameters for register access API to match regmap API:
>  - sec_bulk_read() reorder count and buf,
>  - sec_bulk_write() reorder count and buf,
>  - sec_reg_update() reorder val and mask.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/sec-core.c           |    6 +++---
>  drivers/regulator/s5m8767.c      |   26 +++++++++++++-------------
>  include/linux/mfd/samsung/core.h |    6 +++---
>  3 files changed, 19 insertions(+), 19 deletions(-)

Seems to make sense.

For the MFD portion: Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
