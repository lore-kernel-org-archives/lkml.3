Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaFBLn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:43:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:30273 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbaFBLn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:43:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,956,1392192000"; 
   d="scan'208";a="439803169"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org, Chew Chiau Ee <chiau.ee.chew@intel.com>
Subject: [PATCH 0/2] Add common clk framework support for PCI mode SPI PXA2XX
Date: Tue,  3 Jun 2014 03:46:17 +0800
Message-Id: <1401738379-4107-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

SPI PXA2XX core layer depends on common clock framework to obtain
information on host supported clock rate. Thus, we setup and register
clock device for PCI mode host in SPI PXA2XX pci glue layer using
common clock APIs.

In addition, in order for PCI mode SPI PXA2XX with common clock framework
support to be built as module, we need to export clk_register_clkdev().

Chew, Chiau Ee (1):
  spi/pxa2xx-pci: Add common clock framework support in PCI glue layer

Darren Hart (1):
  clkdev: Export clk_register_clkdev

 drivers/clk/clkdev.c         |    1
 drivers/spi/spi-pxa2xx-pci.c |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

-- 
1.7.4.4

