Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaIOKig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:38:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36918 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754077AbaIOKga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:36:30 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v5 12/12] ARM: dts: berlin: enable USB on the Google Chromecast
Date: Mon, 15 Sep 2014 12:36:18 +0200
Message-Id: <1410777378-12726-13-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Enable usb1 on Google Chromecast which is connected to micro-USB
plug used for external power supply, too.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2cd-google-chromecast.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
index bcd81ffc495d..5c42c3bfb613 100644
--- a/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
+++ b/arch/arm/boot/dts/berlin2cd-google-chromecast.dts
@@ -27,3 +27,7 @@
 };
 
 &uart0 { status = "okay"; };
+
+&usb_phy1 { status = "okay"; };
+
+&usb1 { status = "okay"; };
-- 
1.9.1

