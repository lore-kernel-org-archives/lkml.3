Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab3HSXEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:04:10 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:41982 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3HSXEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:04:07 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v2 0/3] pcf857x: Add OF support
Date: Tue, 20 Aug 2013 01:04:51 +0200
Message-Id: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's a small series of patches that add OF support to the pcf857x driver.
The first two patches prepare the driver for the third one that introduces DT
bindings and parses the device tree node.

Changes since v1:

- Add GPIO properties to the pcf8575 DT node in the bindings documentation

Laurent Pinchart (3):
  gpio: pcf857x: Sort headers alphabetically
  gpio: pcf857x: Remove pdata argument to pcf857x_irq_domain_init()
  gpio: pcf857x: Add OF support

 .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71 ++++++++++++++++++++++
 drivers/gpio/gpio-pcf857x.c                        | 70 ++++++++++++++++-----
 2 files changed, 125 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt

-- 
Regards,

Laurent Pinchart

