Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaGRH3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:29:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34918 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760621AbaGRH3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:29:06 -0400
Date: Fri, 18 Jul 2014 08:28:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, chris@printf.net, ulf.hansson@linaro.org,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, rogerable@realtek.com,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH 0/2] mmc: rtsx: add support for async request
Message-ID: <20140718072858.GJ30888@lee--X1>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1402037562.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris, Ulf,

Sorry for the delay, things have been hectic.

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-mmc-v3.17

for you to fetch changes up to 6291e7153a173f85bbdb13bf0c72fa11b5d74bc0:

  mmc: rtsx: add support for async request (2014-07-09 14:17:15 +0100)

----------------------------------------------------------------
Immutable branch between MFD and MMC due for the v3.17 merge window.

----------------------------------------------------------------
Micky Ching (2):
      mfd: rtsx: Add dma transfer function
      mmc: rtsx: add support for async request

 drivers/mfd/rtsx_pcr.c            |  76 ++++++++++++++--------
 drivers/mmc/host/rtsx_pci_sdmmc.c | 133 ++++++++++++++++++++++++++++++++++++--
 include/linux/mfd/rtsx_pci.h      |   6 ++
 3 files changed, 181 insertions(+), 34 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
