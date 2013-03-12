Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3CLK0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:26:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49430 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534Ab3CLK0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:26:12 -0400
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <rogerq@ti.com>
Subject: [PATCH 0/6] mfd: omap-usb-host: Device tree support for 3.10
Date: Tue, 12 Mar 2013 12:25:34 +0200
Message-ID: <1363083940-20050-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

These patches implement device tree support for the OMAP High Speed
USB Host subsystem. The corresponding EHCI & SoC patches will be sent
separately and this set has no build dependencies with them.

Patch 3 is acutally a bug fix which should go into 3.9-rc. I've sent
it separately to you before.

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:
  git://github.com/rogerq/linux.git usbhost-mfd-next

Roger Quadros (6):
      mfd: omap-usb-host: update nports in platform_data
      mfd: omap-usb-host: Remove PHY reset handling code
      mfd: omap-usb-host: Actually update hostconfig
      mfd: omap-usb-tll: move configuration code to omap_tll_init()
      mfd: omap-usb-tll: Add device tree support and binding information
      mfd: omap-usb-host: Add device tree support and binding information

 .../devicetree/bindings/mfd/omap-usb-host.txt      |   80 ++++++++
 .../devicetree/bindings/mfd/omap-usb-tll.txt       |   17 ++
 drivers/mfd/omap-usb-host.c                        |  206 ++++++++++++++-----
 drivers/mfd/omap-usb-tll.c                         |  214 ++++++++++----------
 drivers/mfd/omap-usb.h                             |    5 +-
 5 files changed, 365 insertions(+), 157 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-host.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt

--
cheers,
-roger
