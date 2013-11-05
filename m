Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3KEG67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:58:59 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61568 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3KEG65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:58:57 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        lee.jones@linaro.org, rob@landley.net, sachin.kamat@linaro.org
Subject: [PATCH 1/1] Documentation/mfd: Fix typos in s2mps11.txt
Date: Tue,  5 Nov 2013 12:27:20 +0530
Message-Id: <1383634640-26869-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed trivial typos to improve readability.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index c9332c6..0ff4e65 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -1,10 +1,10 @@
 
 * Samsung S2MPS11 Voltage and Current Regulator
 
-The Samsung S2MP211 is a multi-function device which includes voltage and
+The Samsung S2MPS11 is a multi-function device which includes voltage and
 current regulators, RTC, charger controller and other sub-blocks. It is
-interfaced to the host controller using a I2C interface. Each sub-block is
-addressed by the host system using different I2C slave address.
+interfaced to the host controller using an I2C interface. Each sub-block is
+addressed by the host system using different I2C slave addresses.
 
 Required properties:
 - compatible: Should be "samsung,s2mps11-pmic".
@@ -43,7 +43,8 @@ sub-node should be of the format as listed below.
 
  BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explictly
  regulator-ramp-delay = <0> can be used for them to disable ramp delay.
- In absence of regulator-ramp-delay property, default ramp delay will be used.
+ In the absence of regulator-ramp-delay property, default ramp delay will
+ be used.
 
 NOTE: Some BUCKs share the ramp rate setting i.e. same ramp value will be set
 for a particular group of BUCKs. So provide same regulator-ramp-delay<value>.
-- 
1.7.9.5

