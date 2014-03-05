Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbaCERgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:36:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50813 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756582AbaCERgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:36:03 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rodolfo Giometti <giometti@linux.it>
Subject: [PATCH 15/15] ARM: at91/dt: at91-cosino_mega2560 remove useless tsadcc node
Date: Wed,  5 Mar 2014 18:35:40 +0100
Message-Id: <1394040940-18246-16-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394040940-18246-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tsadcc node is useless as it doesn't refer to anything and the touchscreen
is handled by the adc0 node.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Rodolfo Giometti <giometti@linux.it>
---
 arch/arm/boot/dts/at91-cosino_mega2560.dts | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/at91-cosino_mega2560.dts b/arch/arm/boot/dts/at91-cosino_mega2560.dts
index f9415dd11f17..cce621239b72 100644
--- a/arch/arm/boot/dts/at91-cosino_mega2560.dts
+++ b/arch/arm/boot/dts/at91-cosino_mega2560.dts
@@ -33,11 +33,6 @@
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

