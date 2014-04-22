Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaDVJgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:36:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51967 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaDVJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:36:17 -0400
Date: Tue, 22 Apr 2014 10:36:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/2] mfd: sec-core: Remove duplicated device type from
 sec_pmic_dev
Message-ID: <20140422093611.GI17657@lee--X1>
References: <1398156970-9360-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398156970-9360-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The device type was stored in sec_pmic_dev state container twice:
>  - unsigned long type (initialized from of_device_id or i2c_device_id)
>  - int device_type (initialized as above or from board files when there
>    is no DTS)
> 
> The 'type' field was never used outside of probe so it can be safely
> removed.
> 
> Change also the device_type in sec_pmic_dev and sec_platform_data to
> unsigned long to avoid any casts.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Changes since v1:
>  - Change device_type field of sec_platform_data from int to unsigned long.
>  - Update commit msg.
> ---
>  drivers/mfd/sec-core.c           | 5 +++--
>  drivers/mfd/sec-irq.c            | 2 +-
>  include/linux/mfd/samsung/core.h | 3 +--
>  3 files changed, 5 insertions(+), 5 deletions(-)

Patch looks good now. Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
