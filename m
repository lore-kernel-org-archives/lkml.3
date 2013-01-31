Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3AaQH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:07:56 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:41103 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424Ab3AaQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:07:54 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org
Subject: [PATCH RFC 0/1] Convert mcp23s08 to DT usage
Date: Thu, 31 Jan 2013 16:58:22 +0100
Message-Id: <1359647903-15801-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

I wanted to use mcp23s08 driver with a device that boots using device tree.
Therefore I had to modify the driver to be able to take it's platform_data
from the device tree.
I am using a mcp23017 (I2C) device successfully with the patch booted over
device tree. I am not sure if I did this right and I am not able to test the
SPI part of the driver, so I am requesting for comments.

Thank you,
Lars

Lars Poeschel (1):
  gpio: mcp23s08: convert driver to DT

 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |   27 ++++++
 drivers/gpio/gpio-mcp23s08.c                       |   93 +++++++++++++++++++-
 include/linux/spi/mcp23s08.h                       |    1 +
 3 files changed, 117 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt

-- 
1.7.10.4

