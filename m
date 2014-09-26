Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaIZJdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:33:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:32201 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbaIZJdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:33:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391931365"
From: Weike Chen <alvin.chen@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>, Alvin Chen <alvin.chen@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] SPI: spi-pxa2xx: Add support for Intel Quark X1000 SPI controller
Date: Fri, 26 Sep 2014 10:25:48 -0700
Message-Id: <1411752349-31490-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Intel Quark X1000 consists of two SPI controllers which can be PCI enumerated.
SPI-PXA2XX PCI layer doesn't support it. Thus, we add support for Intel Quark
X1000 SPI as well.

Weike Chen (1):
  SPI: spi-pxa2xx: SPI support for Intel Quark X1000

 drivers/spi/spi-pxa2xx-pci.c |    8 ++
 drivers/spi/spi-pxa2xx.c     |  251 +++++++++++++++++++++++++++++++++++-------
 drivers/spi/spi-pxa2xx.h     |    8 +-
 include/linux/pxa2xx_ssp.h   |   21 ++++
 4 files changed, 249 insertions(+), 39 deletions(-)

-- 
1.7.9.5

