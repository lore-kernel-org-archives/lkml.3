Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab3CZSGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:06:34 -0400
Received: from zmc.proxad.net ([212.27.53.206]:48320 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757795Ab3CZSGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:06:31 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Subject: [RFC PATCH 0/5] USB: Kconfig cleanups
Date: Tue, 26 Mar 2013 19:06:12 +0100
Message-Id: <1364321177-12146-1-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan, Greg,

These 5 patches contain my Kconfig cleanup on which I based the removal
of the USB_ARCH_HAS_* patches. They have been suggested by Alan Stern
as part of an earlier conversations.

Let me know what you think about it so I can post subsequent work based
on it.

Thanks!

Florian Fainelli (5):
  USB: drop depends on USB and enclose everything into an if USB block
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
 arch/powerpc/platforms/52xx/Kconfig |    2 +
 arch/sparc/Kconfig                  |    2 +
 drivers/usb/Kconfig                 |    7 +-
 drivers/usb/atm/Kconfig             |    2 +-
 drivers/usb/chipidea/Kconfig        |    4 +-
 drivers/usb/class/Kconfig           |    6 +-
 drivers/usb/core/Kconfig            |    7 +-
 drivers/usb/dwc3/Kconfig            |    3 +-
 drivers/usb/gadget/Kconfig          |    2 +-
 drivers/usb/host/Kconfig            |  165 +++++++++++++++++------------------
 drivers/usb/image/Kconfig           |    4 +-
 drivers/usb/misc/Kconfig            |   21 -----
 drivers/usb/misc/sisusbvga/Kconfig  |    2 +-
 drivers/usb/mon/Kconfig             |    1 -
 drivers/usb/musb/Kconfig            |    2 +-
 drivers/usb/phy/Kconfig             |    6 +-
 drivers/usb/renesas_usbhs/Kconfig   |    2 +-
 drivers/usb/serial/Kconfig          |    2 +-
 drivers/usb/storage/Kconfig         |    7 +-
 drivers/usb/wusbcore/Kconfig        |    2 -
 23 files changed, 113 insertions(+), 143 deletions(-)

-- 
1.7.10.4

