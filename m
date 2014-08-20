Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaHTLzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:55:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:1224 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaHTLzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:55:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,901,1400050800"; 
   d="scan'208";a="561050499"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH 0/4] usb: dwc3: ACPI support
Date: Wed, 20 Aug 2014 14:55:24 +0300
Message-Id: <1408535728-10518-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And Intel Braswell PCI ID


Alan Cox (1):
  usb: dwc3: pci: Add PCI ID for Intel Braswell

Heikki Krogerus (3):
  ACPI / platform: provide default DMA mask
  usb: dwc3: core: only setting the dma_mask when needed
  usb: dwc3: add ACPI support

 drivers/acpi/acpi_platform.c |  2 ++
 drivers/usb/dwc3/core.c      | 18 +++++++++++++++---
 drivers/usb/dwc3/dwc3-pci.c  |  2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

-- 
2.1.0

