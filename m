Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaETOzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:55:17 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:60976 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaETOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:55:13 -0400
Date: Tue, 20 May 2014 15:55:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH 0/4] mfd: Intel SoC Power Management IC
Message-ID: <20140520145507.GU24991@lee--X1>
References: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, Zhu, Lejun wrote:

> Devices based on Intel SoC products such as Baytrail have a Power
> Management IC. In the PMIC there are subsystems for voltage regulation,
> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
> Crystal Cove.
> 
> This series contains common code for these PMICs, and device specific
> support for Crystal Cove.
> 
> Lejun Zhu (4):
>   mfd: intel_soc_pmic: Core driver
>   mfd: intel_soc_pmic: I2C interface
>   mfd: intel_soc_pmic: Crystal Cove support
>   mfd: intel_soc_pmic: Build files

I'm missing the build files patch.  Can you ensure I was on the
distribution list please?  Also, what's the reason for splitting the
files out instead of having one single driver?

>  drivers/mfd/Kconfig                |  10 +
>  drivers/mfd/Makefile               |   3 +
>  drivers/mfd/intel_soc_pmic_core.c  | 543 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_core.h  |  83 ++++++
>  drivers/mfd/intel_soc_pmic_crc.c   | 157 +++++++++++
>  drivers/mfd/intel_soc_pmic_i2c.c   | 158 +++++++++++
>  include/linux/mfd/intel_soc_pmic.h |  29 ++
>  7 files changed, 983 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_i2c.c
>  create mode 100644 include/linux/mfd/intel_soc_pmic.h
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
