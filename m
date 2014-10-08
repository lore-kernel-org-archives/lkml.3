Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaJHAGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:06:49 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:46265 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755362AbaJHAGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:06:47 -0400
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, jassisingbrar@gmail.com, =devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 0/6] APM X-Gene platform mailbox and proxy i2c driver
Date: Tue,  7 Oct 2014 17:06:43 -0700
Message-Id: <1412726809-7525-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contain the APM X-Gene platform mailbox driver and 
a proxy i2c driver that uses the mailbox driver to communicate with
the i2c bus through the slimpro coprocessor.

Feng Kan (6):
  mailbox: add support for APM X-Gene platform mailbox driver
  Documentation: mailbox: Add APM X-Gene SLIMpro mailbox dts
    documentation
  arm64: dts: mailbox device tree node for APM X-Gene platform.
  i2c: busses: add SLIMpro I2C device driver on APM X-Gene platform
  Documentation: i2c: Add APM X-Gene platform SLIMpro I2C driver
    documentation
  arm64: dts: add proxy I2C device driver on APM X-Gene platform

 .../devicetree/bindings/i2c/i2c-xgene-slimpro.txt  |  20 +
 .../bindings/mailbox/xgene-slimpro-mailbox.txt     |  41 ++
 arch/arm64/boot/dts/apm-storm.dtsi                 |  20 +
 drivers/i2c/busses/Kconfig                         |   9 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-xgene-slimpro.c             | 531 +++++++++++++++++++++
 drivers/mailbox/Kconfig                            |  10 +
 drivers/mailbox/Makefile                           |   1 +
 drivers/mailbox/mailbox-xgene-slimpro.c            | 287 +++++++++++
 9 files changed, 920 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-xgene-slimpro.txt
 create mode 100644 Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
 create mode 100644 drivers/i2c/busses/i2c-xgene-slimpro.c
 create mode 100644 drivers/mailbox/mailbox-xgene-slimpro.c

-- 
1.9.1

