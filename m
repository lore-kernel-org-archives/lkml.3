Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743Ab3DDP5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:57:51 -0400
Received: from zmc.proxad.net ([212.27.53.206]:49902 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762579Ab3DDP5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:57:49 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, balbi@ti.com,
        Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 0/5 v3] USB: Kconfig cleanups
Date: Thu,  4 Apr 2013 17:57:23 +0200
Message-Id: <1365091048-16229-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These 5 patches contain my Kconfig cleanup on which I based the removal
of the USB_ARCH_HAS_* patches. They have been suggested by Alan Stern
as part of an earlier conversations.

Let me know what you think about it so I can post subsequent work based
on it.

Thanks! Fainelli (5):
  USB: regroup all depends on USB within an if USB block
  USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends on architecture
    symbol
  USB: enclose EHCI HCD drivers within an if USB_EHCI_HCD block
  USB: enclose all depends on USB_OHCI_HCD within an if USB_OHCI_HCD
    block
  USB: enclose USB_XHCI_HCD related symbols within a if USB_XHCI_HCD
    block

 arch/arm/Kconfig                    |    2 +
 arch/mips/Kconfig                   |    3 +
 arch/powerpc/platforms/44x/Kconfig  |    2 +
 arch/powerpc/platforms/512x/Kconfig |    2 +
 arch/sparc/Kconfig                  |    2 +
 drivers/usb/Kconfig                 |   23 +++--
 drivers/usb/atm/Kconfig             |    2 +-
 drivers/usb/class/Kconfig           |    6 +-
 drivers/usb/core/Kconfig            |    6 --
 drivers/usb/host/Kconfig            |  169 +++++++++++++++++------------------
 drivers/usb/image/Kconfig           |    4 +-
 drivers/usb/misc/Kconfig            |   21 -----
 drivers/usb/misc/sisusbvga/Kconfig  |    2 +-
 drivers/usb/mon/Kconfig             |    1 -
 drivers/usb/musb/Kconfig            |    2 +-
 drivers/usb/renesas_usbhs/Kconfig   |    2 +-
 drivers/usb/serial/Kconfig          |    2 +-
 drivers/usb/storage/Kconfig         |    7 +-
 drivers/usb/wusbcore/Kconfig        |    2 -
 19 files changed, 116 insertions(+), 144 deletions(-)

-- 
1.7.10.4

