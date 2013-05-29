Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965814Ab3E2Lno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:43:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38264 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965564Ab3E2Lnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:43:43 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <kishon@ti.com>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/5] USB: PHY: Improve PHY selection logic
Date: Wed, 29 May 2013 14:43:26 +0300
Message-ID: <1369827811-534-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Improve Kconfig so that the relevant PHY driver can be explicitely
selected by the controller driver instead of relying on the user
to do so.

Detailed description in patch 1.

cheers,
-roger

Roger Quadros (5):
  USB: PHY: Make PHY driver selection possible by controller drivers
  USB: ehci-omap: select NOP_USB_XCEIV PHY driver
  USB: ehci-msm: USB_EHCI_MSM need not depend on USB_PHY
  USB: lpc32xx: USB_LPC32XX need not depend on USB_PHY
  USB: OMAP: USB_OMAP need not depend USB_PHY

 drivers/usb/Makefile       |    3 +--
 drivers/usb/gadget/Kconfig |    2 --
 drivers/usb/host/Kconfig   |    5 +----
 drivers/usb/phy/Kconfig    |   31 +++++++++++++++++++++----------
 4 files changed, 23 insertions(+), 18 deletions(-)

-- 
1.7.4.1

