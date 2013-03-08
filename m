Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab3CHC1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:27:18 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43290 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3CHC1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:27:16 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 0/5] musb-ux500 and ab8500-usb updates
Date: Fri,  8 Mar 2013 10:27:04 +0800
Message-Id: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

this is the v2 of my initial update series for ux500's musb.

Changes from v1:
- turn off vbus on USB_EVENT_VBUS event

Thanks,
Fabio


Fabio Baltieri (4):
  usb: musb: ux500: implement musb_set_vbus
  usb: musb: ux500: add otg notifier support
  usb: otg: ab8500-usb: drop support for ab8500 pre v2.0
  usb: otg: ab8500-usb: update irq handling code

Virupax Sadashivpetimath (1):
  usb: musb: ux500_dma: add missing MEM resource check

 drivers/usb/musb/ux500.c       | 107 +++++++++
 drivers/usb/musb/ux500_dma.c   |  12 +-
 drivers/usb/otg/ab8500-usb.c   | 531 ++++++++++++++++++++++++++---------------
 include/linux/usb/musb-ux500.h |  31 +++
 4 files changed, 483 insertions(+), 198 deletions(-)
 create mode 100644 include/linux/usb/musb-ux500.h

-- 
1.8.1.3

