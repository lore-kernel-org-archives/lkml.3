Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbaFQJcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:32:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40726 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaFQJcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:32:22 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>, <tony@atomide.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Benoit Cousson <bcousson@baylibre.com>
Subject: [PATCH v7 4/5] ARM: dts: am43x-epos-evm: Update binding for touchscreen size
Date: Tue, 17 Jun 2014 12:31:46 +0300
Message-ID: <1402997507-9736-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402997507-9736-1-git-send-email-rogerq@ti.com>
References: <1402997507-9736-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the bindings for touchscreen size.

CC: Benoit Cousson <bcousson@baylibre.com>
CC: Tony Lindgren <tony@atomide.com>
CC: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 19f1f7e..f3fe017 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -340,8 +340,8 @@
 
 		attb-gpio = <&gpio1 17 GPIO_ACTIVE_HIGH>;
 
-		x-size = <1024>;
-		y-size = <600>;
+		touchscreen-size-x = <1024>;
+		touchscreen-size-y = <600>;
 	};
 };
 
-- 
1.8.3.2

