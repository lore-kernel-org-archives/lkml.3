Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaJGFNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:13:19 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34130 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaJGFNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:13:18 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com
Cc: ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        jack.yoo@skyworksinc.com
Subject: [RESUBMIT PATCH v3 8/8] devicetree: regulator: sky81452: Add compatible string for device binding
Date: Tue,  7 Oct 2014 14:13:11 +0900
Message-Id: <1412658791-8250-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
 Documentation/devicetree/bindings/regulator/sky81452-regulator.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
index 882455e..7b9ff18 100644
--- a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
@@ -1,6 +1,7 @@
 SKY81452 voltage regulator
 
 Required properties:
+- compatible	: Must be "skyworks,sky81452-regulator"
 - any required generic properties defined in regulator.txt
 
 Optional properties:
@@ -9,6 +10,7 @@ Optional properties:
 Example:
 
 	regulator {
+		compatible = "skyworks,sky81452-regulator";
 		/* generic regulator properties */
 		regulator-name = "touch_en";
 		regulator-min-microvolt = <4500000>;
-- 
1.9.1

