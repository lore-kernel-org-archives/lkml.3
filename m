Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaJGPTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:19:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42035 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaJGPTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:19:42 -0400
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: opw-kernel@googlegroups.com
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v4 1/4] Documentation: devicetree: bindings: Document correct and deprecated vendor-prefix with device isl29028
Date: Tue,  7 Oct 2014 20:49:26 +0530
Message-Id: <1412695169-22815-2-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the device isl29028 with its vendor-prefix. Undocumented deprecated vendor-prefix
found by checkpatch also documented for compatibility reasons.

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
---
 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 6af570e..32edf0b 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -57,6 +57,8 @@ gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with Two-Wire In
 infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max 100khz)
 infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
 isl,isl12057		Intersil ISL12057 I2C RTC Chip
+isil,isl29028           (deprecated, use isl)
+isl,isl29028            Intersil ISL29028 Ambient Light and Proximity Sensor
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
 maxim,max6625		9-Bit/12-Bit Temperature Sensors with I²C-Compatible Serial Interface
-- 
1.9.1

