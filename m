Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaETO6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:58:33 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55149 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaETO6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:58:32 -0400
Date: Tue, 20 May 2014 15:58:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH 1/4] mfd: intel_soc_pmic: Core driver
Message-ID: <20140520145827.GV24991@lee--X1>
References: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
 <1400079578-32329-2-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400079578-32329-2-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch provides the common code for the intel_soc_pmic MFD driver,
> such as read/write register and set up IRQ.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
>  drivers/mfd/intel_soc_pmic_core.c  | 543 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_core.h  |  83 ++++++
>  include/linux/mfd/intel_soc_pmic.h |  29 ++
>  3 files changed, 655 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>  create mode 100644 include/linux/mfd/intel_soc_pmic.h

This whole driver needs converting over to regmap.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
