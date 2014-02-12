Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaBLJIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:08:15 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55974 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaBLJH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:07:57 -0500
Date: Wed, 12 Feb 2014 09:07:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 05/14] mfd: sec: Use consistent S2MPS11 RTC alarm
 interrupt indexes
Message-ID: <20140212090746.GR15081@lee--X1>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392123837-5517-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The S2MPS11 RTC has two alarms: alarm0 and alarm1 (corresponding
> interrupts are named similarly). Use consistent names for interrupts to
> limit possible errors.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-irq.c           |    8 ++++----
>  include/linux/mfd/samsung/irq.h |    4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)

<snip>

>  #define S2MPS11_IRQ_RTC60S_MASK		(1 << 0)
>  #define S2MPS11_IRQ_RTCA1_MASK		(1 << 1)
> -#define S2MPS11_IRQ_RTCA2_MASK		(1 << 2)
> +#define S2MPS11_IRQ_RTCA0_MASK		(1 << 2)

This doesn't look correct to me.

>  #define S2MPS11_IRQ_SMPL_MASK		(1 << 3)
>  #define S2MPS11_IRQ_RTC1S_MASK		(1 << 4)
>  #define S2MPS11_IRQ_WTSR_MASK		(1 << 5)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
