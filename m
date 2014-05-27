Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaE0QtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:49:19 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:57960 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaE0QtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:49:18 -0400
Date: Tue, 27 May 2014 17:49:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v3 4/4] mfd: intel_soc_pmic: Build files
Message-ID: <20140527164911.GE4227@lee--X1>
References: <1401163576-14872-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401163576-14872-5-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401163576-14872-5-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Devices based on Intel SoC products such as Baytrail have a Power Management IC. This patch adds Intel SoC PMIC support to the build files.
> 
> v2:
> - Add select REGMAP_I2C.
> v3:
> - Add select REGMAP_IRQ.

Please fix this, same as before.

> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
>  drivers/mfd/Kconfig  | 12 ++++++++++++
>  drivers/mfd/Makefile |  3 +++
>  2 files changed, 15 insertions(+)

Patch looks okay:

  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
