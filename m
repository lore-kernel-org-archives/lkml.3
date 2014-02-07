Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaBGKxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:53:35 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51194 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaBGKxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:53:33 -0500
Date: Fri, 7 Feb 2014 10:53:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 05/15] mfd: max14577: Add detection of device type
Message-ID: <20140207105327.GK14727@lee--X1>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391767487-10017-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch continues the preparation for adding support for max77836
> device to existing max14577 driver.
> 
> Add enum for types of devices supported by this driver. The device type
> will be detected by matching of_device_id, or i2c_device_id as a
> fallback.
> 
> The patch also moves to separate function the code related to displaying
> DeviceID register values.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mfd/max14577.c               |   64 ++++++++++++++++++++++++----------
>  include/linux/mfd/max14577-private.h |   12 ++++---
>  2 files changed, 53 insertions(+), 23 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
