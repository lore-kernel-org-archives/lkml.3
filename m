Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaJJJAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:00:35 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:57042 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJJJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:00:33 -0400
Date: Fri, 10 Oct 2014 10:00:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/4] mfd: max77693: Remove unused define
Message-ID: <20141010090027.GE26795@lee--X1>
References: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, Krzysztof Kozlowski wrote:

> Remove old MAX77693_NUM_IRQ_MUIC_REGS define. Not used anywhere.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  include/linux/mfd/max77693-private.h | 1 -
>  1 file changed, 1 deletion(-)

Applied for v3.19.

> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index 4f1a80b66ecf..3c51c4d01306 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -26,7 +26,6 @@
>  
>  #include <linux/i2c.h>
>  
> -#define MAX77693_NUM_IRQ_MUIC_REGS	3
>  #define MAX77693_REG_INVALID		(0xff)
>  
>  /* Slave addr = 0xCC: PMIC, Charger, Flash LED */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
