Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3LRJWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:22:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44673 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3LRJWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:22:05 -0500
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/9] Input: pixcir_i2c_ts: Add Type-B Multitouch support
Date: Wed, 18 Dec 2013 14:51:11 +0530
Message-ID: <1387358480-8313-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some variants of the Pixcir I2C touch controller are more suitable for
Type-B multi-touch reporting (e.g. Tango C). This series enhances the driver
to support Type-B multi-touch reports. It also adds device tree support
and power management.

cheers,
-roger

Roger Quadros (9):
  Input: pixcir_i2c_ts: Add device tree support
  Input: pixcir_i2c_ts: Add register definitions
  Input: pixcir_i2c_ts: Initialize interrupt mode and power mode
  Input: pixcir_i2c_ts: Use devres managed resource allocations
  Input: pixcir_i2c_ts: Get rid of pdata->attb_read_val()
  Input: pixcir_i2c_ts: Add chip specific data structure
  Input: pixcir_i2c_ts: Implement Type B Multi Touch reporting
  Input: pixcir_i2c_ts: Add support for TangoC family
  Input: pixcir_i2c_ts: Implement wakeup from suspend

 .../bindings/input/touchscreen/pixcir_i2c_ts.txt   |  26 +
 drivers/input/touchscreen/pixcir_i2c_ts.c          | 570 +++++++++++++++++----
 include/linux/input/pixcir_ts.h                    |  59 ++-
 3 files changed, 564 insertions(+), 91 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt

-- 
1.8.3.2

