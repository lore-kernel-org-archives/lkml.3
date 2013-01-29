Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3A2Eef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:34:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:20512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab3A2Eea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:34:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,556,1355126400"; 
   d="scan'208";a="253942307"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 0/4] PCI/PM: D3cold support for system suspend
Date: Tue, 29 Jan 2013 12:34:14 +0800
Message-Id: <1359434058-15918-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] PCI/ACPI: Add target state as parameter to pci_platform_pm_ops->run_wake
[PATCH 2/4] PCI: Rename pci_dev->runtime_d3cold to pci_dev->set_d3cold
[PATCH 3/4] PCI/PM: Set pci_dev->set_d3cold in pci_set_power_state
[PATCH 4/4] PCI/PM: Enable D3cold support for system suspend

Huang Ying
Best Regards,
