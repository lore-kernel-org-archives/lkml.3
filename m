Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbaFSQDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:03:20 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58917 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbaFSQDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:03:16 -0400
Date: Thu, 19 Jun 2014 17:03:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [GIT PULL v2] LinusW - Immutable branch between MFD and GPIO
Message-ID: <20140619160310.GE26560@lee--X1>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
 <20140617150738.GL29841@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140617150738.GL29841@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Slight amendment.  I've applied a fix, as this branch broke PPC.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-gpio-v3.17

for you to fetch changes up to 8dbf2aa3c308ade864261e8047b0dce1f4ed9a7e:

  gpio: crystalcove: Fix implicit declaration of function 'seq_printf' error (2014-06-19 16:56:28 +0100)

----------------------------------------------------------------
Immutable branch between MFD and GPIO for v3.17.

----------------------------------------------------------------
Lee Jones (1):
      gpio: crystalcove: Fix implicit declaration of function 'seq_printf' error

Zhu, Lejun (3):
      mfd: intel_soc_pmic: Core driver
      mfd: intel_soc_pmic: Crystal Cove support
      gpio: Add support for Intel Crystal Cove PMIC

 drivers/gpio/Kconfig               |  13 ++
 drivers/gpio/Makefile              |   1 +
 drivers/gpio/gpio-crystalcove.c    | 380 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |  12 ++
 drivers/mfd/Makefile               |   3 +
 drivers/mfd/intel_soc_pmic_core.c  | 168 ++++++++++++++++
 drivers/mfd/intel_soc_pmic_core.h  |  32 ++++
 drivers/mfd/intel_soc_pmic_crc.c   | 158 +++++++++++++++
 include/linux/mfd/intel_soc_pmic.h |  30 +++
 9 files changed, 797 insertions(+)
 create mode 100644 drivers/gpio/gpio-crystalcove.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.c
 create mode 100644 drivers/mfd/intel_soc_pmic_core.h
 create mode 100644 drivers/mfd/intel_soc_pmic_crc.c
 create mode 100644 include/linux/mfd/intel_soc_pmic.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
