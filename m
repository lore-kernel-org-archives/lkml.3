Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaEHHxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:53:00 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:64432 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaEHHw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:52:59 -0400
Date: Thu, 8 May 2014 08:52:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] mfd/mmc: Fixes branch based on v3.15-rc4 (single revert)
Message-ID: <20140508075252.GA5307@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please find this single reversion which should be applied before v3.15.

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-mmc-fixes-3.15-rc4

for you to fetch changes up to 98fcc5762dcecbb264fa4af5a9ae51136858e299:

  mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req" (2014-05-08 08:44:50 +0100)

----------------------------------------------------------------
Fixes branch from MFD and MMC based on 3.15-rc4.

----------------------------------------------------------------
Micky Ching (1):
      mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"

 drivers/mfd/rtsx_pcr.c            | 132 ++++++++------------------------------
 drivers/mmc/host/rtsx_pci_sdmmc.c | 418 ++++++++++----------------------------
 include/linux/mfd/rtsx_common.h   |   1 -
 include/linux/mfd/rtsx_pci.h      |   6 ---
 4 files changed, 109 insertions(+), 448 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
