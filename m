Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbbAWPNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:13:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:30550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbbAWPNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:13:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="666508847"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] usb: ulpi bus
Date: Fri, 23 Jan 2015 17:12:50 +0200
Message-Id: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Heikki Krogerus (8):
  usb: add bus type for USB ULPI
  usb: dwc3: USB2 PHY register access bits
  usb: dwc3: store driver data earlier
  usb: dwc3: cache hwparams earlier
  usb: dwc3: ULPI or UTMI+ select
  usb: dwc3: add ULPI interface support
  phy: helpers for USB ULPI PHY registering
  phy: add driver for TI TUSB1210 ULPI PHY

 MAINTAINERS                       |   7 ++
 drivers/phy/Kconfig               |   6 +
 drivers/phy/Makefile              |   1 +
 drivers/phy/phy-tusb1210.c        | 133 ++++++++++++++++++++
 drivers/phy/ulpi_phy.h            |  31 +++++
 drivers/usb/common/Makefile       |   3 +-
 drivers/usb/common/ulpi.c         | 253 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/Kconfig          |   8 ++
 drivers/usb/dwc3/Kconfig          |   7 ++
 drivers/usb/dwc3/Makefile         |   4 +
 drivers/usb/dwc3/core.c           |  12 +-
 drivers/usb/dwc3/core.h           |  22 ++++
 drivers/usb/dwc3/ulpi.c           | 112 +++++++++++++++++
 include/linux/mod_devicetable.h   |   6 +
 include/linux/ulpi/driver.h       |  62 ++++++++++
 include/linux/ulpi/interface.h    |  23 ++++
 include/linux/ulpi/regs.h         | 130 ++++++++++++++++++++
 include/linux/usb/ulpi.h          | 134 +-------------------
 scripts/mod/devicetable-offsets.c |   4 +
 scripts/mod/file2alias.c          |  13 ++
 20 files changed, 835 insertions(+), 136 deletions(-)
 create mode 100644 drivers/phy/phy-tusb1210.c
 create mode 100644 drivers/phy/ulpi_phy.h
 create mode 100644 drivers/usb/common/ulpi.c
 create mode 100644 drivers/usb/dwc3/ulpi.c
 create mode 100644 include/linux/ulpi/driver.h
 create mode 100644 include/linux/ulpi/interface.h
 create mode 100644 include/linux/ulpi/regs.h

-- 
2.1.4

