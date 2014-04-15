Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaDOK2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:28:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39087 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754556AbaDOK20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:26 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 15/15] ARM: at91/dt: at91-cosino_mega2560 remove useless tsadcc node
Date: Tue, 15 Apr 2014 12:28:10 +0200
Message-Id: <1397557690-5650-16-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tsadcc node is useless as it doesn't refer to anything and the touchscreen
is handled by the adc0 node.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Rodolfo Giometti <giometti@linux.it>
---
 arch/arm/boot/dts/at91-cosino_mega2560.dts | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/at91-cosino_mega2560.dts b/arch/arm/boot/dts/at91-cosino_mega2560.dts
index a542d5837a17..27ebb0f722fd 100644
--- a/arch/arm/boot/dts/at91-cosino_mega2560.dts
+++ b/arch/arm/boot/dts/at91-cosino_mega2560.dts
@@ -32,11 +32,6 @@
 				status = "okay";
 			};
 
-
-			tsadcc: tsadcc@f804c000 {
-				status = "okay";
-			};
-
 			rtc@fffffeb0 {
 				status = "okay";
 			};
-- 
1.8.3.2

