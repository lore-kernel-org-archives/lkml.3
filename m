Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3B1KjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:39:13 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:63504 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3B1KjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:39:10 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/5] musb-ux500 and ab8500-usb updates
Date: Thu, 28 Feb 2013 11:38:49 +0100
Message-Id: <1362047934-22337-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

This series is an initial effort to update current UX500 specific
MUSB/OTG drivers with the various improvements and fixes developed
internally by ST-Ericsson since the driver was initially merged.

The driver currently deployed by STE includes many updates such as
runtime PM support, new AB85xx variants, integration with modern
frameworks (common clock, pin control, regulator, devm_ variants
etc...), and of course some fixes as well.

In this initial set I only included some essential patches so that I get
an early feedback from you if I'm moving in the right direction.

Thanks,
Fabio

Fabio Baltieri (4):
  usb: musb: ux500: implement musb_set_vbus
  usb: musb: ux500: add otg notifier support
  usb: otg: ab8500-usb: drop support for ab8500 pre v2.0
  usb: otg: ab8500-usb: update irq handling code

Virupax Sadashivpetimath (1):
  usb: musb: ux500_dma: add missing MEM resource check

 drivers/usb/musb/ux500.c       | 106 ++++++++
 drivers/usb/musb/ux500_dma.c   |  12 +-
 drivers/usb/otg/ab8500-usb.c   | 531 ++++++++++++++++++++++++++---------------
 include/linux/usb/musb-ux500.h |  31 +++
 4 files changed, 482 insertions(+), 198 deletions(-)
 create mode 100644 include/linux/usb/musb-ux500.h

-- 
1.8.1.3

