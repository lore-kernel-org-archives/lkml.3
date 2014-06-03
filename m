Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaFCIES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:04:18 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49556 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaFCIEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:04:14 -0400
Date: Tue, 3 Jun 2014 09:04:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, broonie@kernel.org, sameo@linux.intel.com,
        mika.westerberg@linux.intel.com, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com,
        bin.yang@intel.com
Subject: Re: [PATCH v5 2/3] mfd: intel_soc_pmic: Crystal Cove support
Message-ID: <20140603080406.GB3060@lee--X1>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401773164-30326-3-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401773164-30326-3-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2014, Zhu, Lejun wrote:

> This patch provides chip-specific support for Crystal Cove. Crystal
> Cove is the PMIC in Baytrail-T platform.
> 
> Also adds Intel SoC PMIC support to the build files.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
> v2:
> - Add regmap_config for Crystal Cove.
> v3:
> - Convert IRQ config to regmap_irq_chip.
> v4:
> - Cleanup include files.
> - Remove useless init() function.
> - Remove useless .label and .init from struct intel_soc_pmic_config.
> - Fix various coding style issues.
> v5:
> - Use CRYSTAL_COVE_IRQ_ prefix for IRQ bits definition.
> - Merge build files patch to here.
> ---
>  drivers/mfd/Kconfig              |  12 +++
>  drivers/mfd/Makefile             |   3 +
>  drivers/mfd/intel_soc_pmic_crc.c | 158 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 173 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_crc.c

Looks good to me now, but the merge-window is imminent.  I'll apply
this for v3.17 if there are no more comments.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
