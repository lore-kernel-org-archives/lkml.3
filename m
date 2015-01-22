Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbbAVHS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:18:29 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:32992 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAVHSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:18:22 -0500
Date: Thu, 22 Jan 2015 07:18:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v2 0/9] mfd: rtsx: add support for new rts524A and rts525A
Message-ID: <20150122071817.GI22024@x1>
References: <cover.1421909642.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1421909642.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you reworked all of these patches?

If not, why haven't my Acks been carried forward?

Please [RESEND] with the Acks applied.

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> v2:
> - remove debug info when access failed.
> - using macro list for phy register init.
> - rename function for multi chip prefix with rtsx_base_
> - save pcie_cap offset when init chip, not calling pci_find_capacity()
>   every time.
> - add pcr->ops: write_phy/read_phy for special chip.
> 
> This patchset including re-format some coding-style and add two new chip
> rts524A and rts525A.
> 
> 
> Micky Ching (9):
>   mfd: rtsx: replace TAB by SPC after #define
>   mfd: rtsx: place register address and values togather
>   mfd: rtsx: update PETXCFG address
>   mfd: rtsx: update driving settings
>   mfd: rtsx: update phy register
>   mfd: rtsx: remove LCTLR defination
>   mfd: rtsx: add support for rts524A
>   mfd: rtsx: add support for rts525A
>   mfd: rtsx: using pcr_dbg replace dev_dbg
> 
>  drivers/mfd/Makefile         |    2 +-
>  drivers/mfd/rtl8411.c        |   11 +-
>  drivers/mfd/rts5209.c        |    4 +-
>  drivers/mfd/rts5227.c        |   12 +-
>  drivers/mfd/rts5229.c        |    4 +-
>  drivers/mfd/rts5249.c        |  368 +++++++++++---
>  drivers/mfd/rtsx_gops.c      |   37 --
>  drivers/mfd/rtsx_pcr.c       |  110 +++--
>  drivers/mfd/rtsx_pcr.h       |    8 +
>  include/linux/mfd/rtsx_pci.h | 1109 ++++++++++++++++++++++--------------------
>  10 files changed, 966 insertions(+), 699 deletions(-)
>  delete mode 100644 drivers/mfd/rtsx_gops.c
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
