Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3EaL3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:29:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33298 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:29:35 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <arnd@arndb.de>,
        <adrienverge@gmail.com>, <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 0/2] USB: PHY: Improve PHY selection logic
Date: Fri, 31 May 2013 14:29:01 +0300
Message-ID: <1369999743-11758-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Improve Kconfig so that the relevant PHY driver can be explicitely
selected by the controller driver instead of relying on the user
to do so.

Detailed description in patch 1.

v2:
- Merge patches 3-5 into the first patch to prevent circular dependency
between the Kconfig options during bisection.

cheers,
-roger

Roger Quadros (2):
  USB: PHY: Make PHY driver selection possible by controller drivers
  USB: ehci-omap: select NOP_USB_XCEIV PHY driver

 drivers/usb/Makefile       |    3 +--
 drivers/usb/gadget/Kconfig |    2 --
 drivers/usb/host/Kconfig   |    5 +----
 drivers/usb/phy/Kconfig    |   31 +++++++++++++++++++++----------
 4 files changed, 23 insertions(+), 18 deletions(-)

-- 
1.7.4.1

