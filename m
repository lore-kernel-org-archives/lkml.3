Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaJGE4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:56:00 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34542 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaJGEz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:55:59 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, jack.yoo@skyworksinc.com
Subject: [RESUBMIT PATCH v3 0/8] Adding Skyworks SKY81452 device drivers
Date: Tue,  7 Oct 2014 13:55:45 +0900
Message-Id: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set includes regulator and backlight driver for SKY81452.
Also it includes documents for device tree and module.

v3:
Cleaned-up DBG messages.
Cleaned-up DT.

v2:
Split the patches for each sub-system.
Added 'reg' attribute for I2C address in device tree documents
Added 'compatible' attribute in child drivers
Renamed CONFIG_SKY81452 to CONFIG_MFD_SKY81452
Changed the dependency from I2C=y to I2C, for CONFIG_MFD_SKY81452
Added message for exception or errors.

Gyungoh Yoo (8):
  mfd: Add support for Skyworks SKY81452 driver
  backlight: Add support Skyworks SKY81452 backlight driver
  devicetree: mfd: Add new SKY81452 mfd binding
  devicetree: backlight: add new SKY81452 backlight binding
  devicetree: Add vendor prefix for Skyworks Solutions, Inc.
  devicetree: i2c: Add SKY81452 to the Trivial Devices list
  regulator: sky81452: Add compatible string for device binding
  devicetree: regulator: sky81452: Add compatible string for device
    binding

 .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
 Documentation/devicetree/bindings/mfd/sky81452.txt |  32 ++
 .../bindings/regulator/sky81452-regulator.txt      |   2 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 .../video/backlight/sky81452-backlight.txt         |  24 ++
 drivers/mfd/Kconfig                                |  12 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/sky81452.c                             | 111 +++++++
 drivers/regulator/sky81452-regulator.c             |  22 +-
 drivers/video/backlight/Kconfig                    |  10 +
 drivers/video/backlight/Makefile                   |   1 +
 drivers/video/backlight/sky81452-backlight.c       | 347 +++++++++++++++++++++
 include/linux/mfd/sky81452.h                       |  32 ++
 13 files changed, 590 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
 create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
 create mode 100644 drivers/mfd/sky81452.c
 create mode 100644 drivers/video/backlight/sky81452-backlight.c
 create mode 100644 include/linux/mfd/sky81452.h

-- 
1.9.1

