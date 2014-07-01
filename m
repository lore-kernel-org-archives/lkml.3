Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbaGAOAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:00:12 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39684 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaGAOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:00:11 -0400
Date: Tue, 1 Jul 2014 15:00:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, broonie@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 1/4] mfd: sec-core: Add support for S2MPU02 device
Message-ID: <20140701140004.GI27971@lee--X1>
References: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
 <1403680487-12141-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403680487-12141-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Chanwoo Choi wrote:

> Add support for Samsung S2MPU02 PMIC device to the MFD sec-core driver.
> The S2MPU02 device includes PMIC/RTC/Clock devices.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c              |  46 ++++++---
>  drivers/mfd/sec-irq.c               | 110 +++++++++++++++++---
>  include/linux/mfd/samsung/core.h    |   1 +
>  include/linux/mfd/samsung/irq.h     |  24 +++++
>  include/linux/mfd/samsung/s2mpu02.h | 201 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 352 insertions(+), 30 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mpu02.h

I like what you've done, but really this patch should be split into 3
separate patches.  One to consolidate the mfd_add_devices() calls, one
to consolidate the regmap_add_irq_chip() calls and the final one to
add support for the S2MPU02.

When you submit them, you can apply my:

  Acked-by: Lee Jones <lee.jones@linaro.org>

... to each of them.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
