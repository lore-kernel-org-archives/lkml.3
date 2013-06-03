Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab3FCRFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:05:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:43636 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3FCRFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:05:41 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL v2] at91: USBA DT support / drivers update for 3.11 #1
Date: Mon, 3 Jun 2013 19:05:39 +0200
Message-ID: <1370279139-7181-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <20130526083430.GP24476@game.jcrosoft.org>
References: <20130526083430.GP24476@game.jcrosoft.org>
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This is a rework of the previous pull-request done by Jean-Christophe
PLAGNIOL-VILLARD last week ([GIT PULL] at91: USBA DT support for 3.11).
You should see that this material is based on the cleanup branch that you
already have in arm-soc/at91/cleanup.

This adds the DT support for USBA gadget driver present in the most recent
AT91 SoCs.
As agreed with Arnd and Felipe we send these drivers updates via arm-soc.

Thanks, best regards,

The following changes since commit b3f442b0eedbc20b5ce3f4a96530588d14901199:

  ARM: at91: udpate defconfigs (2013-05-17 15:05:08 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-drivers

for you to fetch changes up to a375f12dde25a7e89acd75d066d0225657d7dfc2:

  ARM: at91: sam9m10g45ek add udc DT support (2013-05-24 07:15:20 +0800)

----------------------------------------------------------------
Adding the DT support to UBB gadget High-Speed aka usba.
It updates the driver and all device tree files

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (7):
      USB: gadget: atmel_usba: move global struct usba_ep usba_ep to struct usba_udc
      USB: gadget: atmel_usba: allow multi instance
      USB: gadget: atmel_usba: add DT support
      ARM: at91: sam9x5 add udc DT support
      ARM: at91: sam9x5ek add udc DT support
      ARM: at91: sam9g45 add udc DT support
      ARM: at91: sam9m10g45ek add udc DT support

 .../devicetree/bindings/usb/atmel-usb.txt          |  82 +++++++
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  62 +++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   5 +
 arch/arm/boot/dts/at91sam9x5.dtsi                  |  62 +++++
 arch/arm/boot/dts/at91sam9x5ek.dtsi                |   5 +
 arch/arm/mach-at91/at91sam9g45.c                   |   2 +
 arch/arm/mach-at91/at91sam9x5.c                    |   2 +
 drivers/usb/gadget/Kconfig                         |   2 +-
 drivers/usb/gadget/atmel_usba_udc.c                | 264 ++++++++++++++-------
 drivers/usb/gadget/atmel_usba_udc.h                |   2 +
 10 files changed, 407 insertions(+), 81 deletions(-)

-- 
Nicolas Ferre
