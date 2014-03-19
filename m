Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbaCSJHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:07:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47565 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbaCSJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:07:31 -0400
Date: Wed, 19 Mar 2014 09:07:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: tps65910: Fix regmap_irq_chip_data leak on
 mfd_add_devices fail
Message-ID: <20140319090726.GE31687@lee--X1>
References: <1394639445-7737-1-git-send-email-k.kozlowski@samsung.com>
 <1394639445-7737-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394639445-7737-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The tps65910_i2c_probe() allocates regmap_irq_chip in
> tps65910_irq_init() but it does not clean this up in case of
> mfd_add_devices() failure.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/tps65910.c |    1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
