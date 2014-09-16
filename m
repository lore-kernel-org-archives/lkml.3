Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaIPWJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:09:45 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58280 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaIPWJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:09:41 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 0/2] Amlogic Meson I2C driver
Date: Wed, 17 Sep 2014 00:07:55 +0200
Message-Id: <1410905277-22172-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds a driver for the I2C controller found on Amlogic
Meson SoCs. It has been tested on a Tronsmart Vega S89 TV Box, which
is based on a Meson8 core, but should work also on Meson6 devices. 

A patchset adding support for these SoCs was submitted some days ago
and can be found here:

http://thread.gmane.org/gmane.linux.ports.arm.kernel/356685

Beniamino Galvani (2):
  i2c: add support for Amlogic Meson I2C controller
  i2c: meson: add device tree bindings documentation

 .../devicetree/bindings/i2c/i2c-meson.txt          |  24 +
 drivers/i2c/busses/Kconfig                         |   7 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-meson.c                     | 500 +++++++++++++++++++++
 4 files changed, 532 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-meson.txt
 create mode 100644 drivers/i2c/busses/i2c-meson.c

-- 
1.9.1

