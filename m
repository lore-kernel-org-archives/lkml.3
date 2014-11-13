Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbaKMTfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:35:32 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63840 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701AbaKMTfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:35:30 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 0/3]  i2c: add driver for Amlogic Meson I2C controller
Date: Thu, 13 Nov 2014 20:32:00 +0100
Message-Id: <1415907123-4318-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset adds a driver for the I2C controller available in
Amlogic Meson SoCs. It has been tested on a Meson8 based board with
the following devices:
 - Ricoh RN5T618 PMIC
 - NXP PCF8564 RTC

Changes since v2:
 - fixed token generation for split reads
 - simplified meson_i2c_prepare_xfer()
 - added DTS patch

Changes since v1:
 - factored common code for token list setup

Beniamino Galvani (3):
  i2c: meson: add device tree bindings documentation
  i2c: add support for Amlogic Meson I2C controller
  ARM: dts: meson: add I2C controller nodes

 .../devicetree/bindings/i2c/i2c-meson.txt          |  24 +
 arch/arm/boot/dts/meson.dtsi                       |  30 ++
 drivers/i2c/busses/Kconfig                         |   7 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-meson.c                     | 492 +++++++++++++++++++++
 5 files changed, 554 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-meson.txt
 create mode 100644 drivers/i2c/busses/i2c-meson.c

-- 
1.9.1

