Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaGPVbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:31:39 -0400
Received: from 203-174-129-26.bri.static-ipl.aapt.com.au ([203.174.129.26]:32910
	"EHLO bne.vrt.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaGPVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:31:31 -0400
From: Stuart Longland <stuartl@vrt.com.au>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Stuart Longland <stuartl@vrt.com.au>
Subject: [PATCH 2/2] devicetree: Document binding for isl12022 driver
Date: Thu, 17 Jul 2014 07:31:02 +1000
Message-Id: <1405546262-4333-3-git-send-email-stuartl@vrt.com.au>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405546262-4333-1-git-send-email-stuartl@vrt.com.au>
References: <20140716085904.GA26951@leverpostej>
 <1405546262-4333-1-git-send-email-stuartl@vrt.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stuart Longland <stuartl@vrt.com.au>
---
 Documentation/devicetree/bindings/i2c/trivial-devices.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index bef86e5..17e24e5 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -55,6 +55,7 @@ fsl,sgtl5000		SGTL5000: Ultra Low-Power Audio Codec
 gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with Two-Wire Interface
 infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max 100khz)
 infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
+isl,isl12022		Intersil ISL12020/ISL12022 I2C RTC Chip
 isl,isl12057		Intersil ISL12057 I2C RTC Chip
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
-- 
1.8.5.5

