Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbaFTIRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:17:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:63991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934263AbaFTIRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:17:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,512,1400050800"; 
   d="scan'208";a="558394296"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Chris Ball <chris@printf.net>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: sdhci-pci: Add support for Intel Quark SDIO host controller
Date: Fri, 20 Jun 2014 09:13:55 -0700
Message-Id: <1403280836-26943-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alvin (Weike) Chen" <alvin.chen@intel.com>

Hi,
Intel Quark consists of one SDIO host controller which can be PCI enumerated. 
SDHCI-PCI layer doesn't support it. Thus, we add support for Intel Quark SDIO as well.

Derek Browne (1):
  Quark SDIO host controller

 drivers/mmc/host/sdhci-pci.c |   12 ++++++++++++
 include/linux/pci_ids.h      |    2 ++
 2 files changed, 14 insertions(+)

-- 
1.7.9.5

