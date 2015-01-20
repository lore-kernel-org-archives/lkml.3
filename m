Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbbATJSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:18:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:54671 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbbATJSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:18:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442631444"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] phy: ulpi bus
Date: Tue, 20 Jan 2015 11:18:19 +0200
Message-Id: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Heikki Krogerus (3):
  phy: add bus for USB ULPI PHYs
  usb: dwc3: add ULPI interface support
  phy: ulpi: add driver for TI TUSB1210

 MAINTAINERS                        |   7 ++
 drivers/phy/Kconfig                |   2 +
 drivers/phy/Makefile               |   1 +
 drivers/phy/ulpi/Kconfig           |  20 +++
 drivers/phy/ulpi/Makefile          |   4 +
 drivers/phy/ulpi/tusb1210.c        | 131 ++++++++++++++++++++
 drivers/phy/ulpi/ulpi.c            | 246 +++++++++++++++++++++++++++++++++++++
 drivers/phy/ulpi/ulpi_phy.h        |  31 +++++
 drivers/usb/dwc3/Kconfig           |   7 ++
 drivers/usb/dwc3/Makefile          |   4 +
 drivers/usb/dwc3/core.c            |   9 +-
 drivers/usb/dwc3/core.h            |  22 ++++
 drivers/usb/dwc3/ulpi.c            | 102 +++++++++++++++
 include/linux/phy/ulpi/driver.h    |  58 +++++++++
 include/linux/phy/ulpi/interface.h |  23 ++++
 include/linux/phy/ulpi/regs.h      | 130 ++++++++++++++++++++
 include/linux/usb/ulpi.h           | 135 +-------------------
 17 files changed, 799 insertions(+), 133 deletions(-)
 create mode 100644 drivers/phy/ulpi/Kconfig
 create mode 100644 drivers/phy/ulpi/Makefile
 create mode 100644 drivers/phy/ulpi/tusb1210.c
 create mode 100644 drivers/phy/ulpi/ulpi.c
 create mode 100644 drivers/phy/ulpi/ulpi_phy.h
 create mode 100644 drivers/usb/dwc3/ulpi.c
 create mode 100644 include/linux/phy/ulpi/driver.h
 create mode 100644 include/linux/phy/ulpi/interface.h
 create mode 100644 include/linux/phy/ulpi/regs.h

-- 
2.1.4

