Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaIPQSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:18:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33524 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaIPQSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:18:12 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-cc-541862c1b31e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: dts: mmp2: Fix typo in max8925 compatible property
Date: Tue, 16 Sep 2014 18:18:02 +0200
Message-id: <1410884282-18041-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e/4Zd2DSRIhBj9niFvMP3KO1aL/zUJW
	iwvrzC3OvVrJaPH6haHFpsfXWC0u75rDZnH7Mq/F0usXmSwmTF/LYtG69wi7A7fHmnlrGD1a
	mnvYPC739TJ57Jx1l91j5fIvbB6bVnWyeWxeUu/Rt2UVo8fnTXIBnFFcNimpOZllqUX6dglc
	GR/2XmctmMFWceVlD3MDYzNrFyMnh4SAicSh642MELaYxIV769lAbCGBpYwSL5rLuhi5gOw+
	JonDW54xgyTYBIwlNi9fwgaSEBE4wyTx49FDsG5mgTiJ3h1zmEBsYQEPiUMrd7OD2CwCqhLP
	p80Cq+EVcJfYNXcL1GY5iZPHJrNOYORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk
	3L7uYFx6zOoQowAHoxIPb8Y/8RAh1sSy4srcQ4wSHMxKIrw/fCVChHhTEiurUovy44tKc1KL
	DzEycXBKNTDufTblGn/dkwOX9R8n5BrJn40/MyWS5yTT7gK36N3P42RXl69/xPy93+yu0bU9
	ysfOpGx8Zpxw6L3IstvRizeXZwW1rBQ/HmlytcO9X3Zr1k5TE8tF4iGcD9Vu/Jjf/VHi+5zn
	hffk7e487g6r+XR5b+m6sKfLzug/YfFXOs+1eLd6dOP9/Nc1SizFGYmGWsxFxYkA8IzkXRUC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in the compatible property for max8925 MFD driver. The proper
compatible as in Documentation and driver is 'maxim,max8925'.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/mmp2-brownstone.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
index 7f70a39459f6..29eeb465f99c 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -30,7 +30,7 @@
 			twsi1: i2c@d4011000 {
 				status = "okay";
 				pmic: max8925@3c {
-					compatible = "maxium,max8925";
+					compatible = "maxim,max8925";
 					reg = <0x3c>;
 					interrupts = <1>;
 					interrupt-parent = <&intcmux4>;
-- 
1.9.1

