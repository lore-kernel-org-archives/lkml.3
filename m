Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaFXGC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:02:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:56158 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaFXGBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,536,1400050800"; 
   d="scan'208";a="552376157"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Chris Ball <chris@printf.net>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH v2] mmc: sdhci-pci: Add support for Intel Quark X1000 SDIO host controller
Date: Tue, 24 Jun 2014 06:56:35 -0700
Message-Id: <1403618196-7366-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alvin (Weike) Chen" <alvin.chen@intel.com>

Hi,
Intel Quark X1000 consists of one SDIO host controller which can be PCI enumerated. 
SDHCI-PCI layer doesn't support it. Thus, we add support for Intel Quark X1000 SDIO as well.

Derek Browne (1):
  Quark SDIO host controller

 drivers/mmc/host/sdhci-pci.c |   12 ++++++++++++
 drivers/mmc/host/sdhci-pci.h |    1 +
 2 files changed, 13 insertions(+)

-- 
1.7.9.5

