Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaEWKJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:09:06 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34358 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaEWKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:09:02 -0400
Date: Fri, 23 May 2014 11:08:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH RESEND v2 0/4] mfd: Intel SoC Power Management IC
Message-ID: <20140523100857.GQ19747@lee--X1>
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Devices based on Intel SoC products such as Baytrail have a Power
> Management IC. In the PMIC there are subsystems for voltage regulation,
> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
> Crystal Cove.
> 
> This series contains common code for these PMICs, and device specific
> support for Crystal Cove.
> 
> v2:
> - Use regmap instead of creating our own I2C read/write callbacks.
> - Add one missing EXPORT_SYMBOL.
> - Remove some duplicate code and put them into pmic_regmap_load_from_hw.
> 
> Zhu, Lejun (4):
>   mfd: intel_soc_pmic: Core driver
>   mfd: intel_soc_pmic: I2C interface
>   mfd: intel_soc_pmic: Crystal Cove support
>   mfd: intel_soc_pmic: Build files
> 
>  drivers/mfd/Kconfig                |  11 +
>  drivers/mfd/Makefile               |   3 +
>  drivers/mfd/intel_soc_pmic_core.c  | 521 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_core.h  |  83 ++++++
>  drivers/mfd/intel_soc_pmic_crc.c   | 165 ++++++++++++
>  drivers/mfd/intel_soc_pmic_i2c.c   | 148 +++++++++++
>  include/linux/mfd/intel_soc_pmic.h |  29 +++
>  7 files changed, 960 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_i2c.c
>  create mode 100644 include/linux/mfd/intel_soc_pmic.h

Why are you re-sending this?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
