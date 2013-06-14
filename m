Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3FNWCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:02:48 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:52508 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3FNWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:02:46 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
CC: <balbi@ti.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [GIT PULL v3] at91: USBA DT support / drivers update for 3.11 #1
Date: Sat, 15 Jun 2013 00:02:44 +0200
Message-ID: <1371247364-23213-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1370279139-7181-1-git-send-email-nicolas.ferre@atmel.com>
References: <1370279139-7181-1-git-send-email-nicolas.ferre@atmel.com>
Organization: atmel
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This is a rework of the previous pull-request done by Jean-Christophe
PLAGNIOL-VILLARD ([GIT PULL] at91: USBA DT support for 3.11).
It is also the division of my previous pull request (v2) to extract only
patches related to drivers. The DT patches will be stacked on top of our
arm-soc/at91/dt branch in an upcoming pull-request.
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

for you to fetch changes up to 4a3ae9324ebeb9715369d2bca799bfd7dcff6dd7:

  USB: gadget: atmel_usba: add DT support (2013-05-24 07:14:45 +0800)

----------------------------------------------------------------
Adding the DT support to USB gadget High-Speed aka usba.

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (3):
      USB: gadget: atmel_usba: move global struct usba_ep usba_ep to struct usba_udc
      USB: gadget: atmel_usba: allow multi instance
      USB: gadget: atmel_usba: add DT support

 .../devicetree/bindings/usb/atmel-usb.txt          |  82 +++++++
 drivers/usb/gadget/Kconfig                         |   2 +-
 drivers/usb/gadget/atmel_usba_udc.c                | 264 ++++++++++++++-------
 drivers/usb/gadget/atmel_usba_udc.h                |   2 +
 4 files changed, 269 insertions(+), 81 deletions(-)

-- 
Nicolas Ferre
