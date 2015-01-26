Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbbAZTud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:50:33 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40504 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZTua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:50:30 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 1/2] ARM: zynq: Remove bogus value from 'bias-disable' property
Date: Mon, 26 Jan 2015 11:49:55 -0800
Message-Id: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.2.1.g63c5777
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In one pinctrl node, a 'bias-disable' property is erroneously assigned a
value.

Fixes: ARM: zynq: DT: Add pinctrl information
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Feel free to squash this into the mentioned patch. I don't see it in any
stable branch yet.

	Sören
---
 arch/arm/boot/dts/zynq-zc702.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 365bdd407eb4..4f8835be4874 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -309,7 +309,7 @@
 
 		conf-tx {
 			pins = "MIO48";
-			bias-disable = <0>;
+			bias-disable;
 		};
 	};
 };
-- 
2.2.2.1.g63c5777

