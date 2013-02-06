Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3BFRBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:01:46 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:34876 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab3BFRBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:01:45 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org
Subject: [PATCH 0/2] Convert mcp23s08 to DT usage
Date: Wed,  6 Feb 2013 18:01:56 +0100
Message-Id: <1360170118-11937-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

I wanted to use mcp23s08 driver with a device that boots using device tree.
I modified the driver to allow the DT usage and tested with a mcp23017
which is a i2c device. I could not test the spi path, because I have no
such device.

Regards,
Lars

Lars Poeschel (2):
  gpio: mcp23s08: Allow -1 as a legal value for global gpio base
  gpio: mcp23s08: convert driver to DT

 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |   36 ++++++++
 drivers/gpio/gpio-mcp23s08.c                       |   95 ++++++++++++++++++--
 include/linux/spi/mcp23s08.h                       |    1 +
 3 files changed, 126 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt

-- 
1.7.10.4

