Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaDPMmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:42:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47892 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755877AbaDPMkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:40:17 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, chris@printf.net, anton@enomsg.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ARM: dts: berlin: enable SD card reader and eMMC for the BG2Q DMP
Date: Wed, 16 Apr 2014 14:40:11 +0200
Message-Id: <1397652011-21284-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the SD Card reader and the internal eMMC on the Berlin BG2Q DMP
using two of the SDHCI nodes of the Berlin BG2Q.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 2da9c41e29d8..671ed4d055ed 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -26,3 +26,11 @@
 &uart0 {
 	status = "okay";
 };
+
+&sdhci1 {
+	status = "okay";
+};
+
+&sdhci2 {
+	status = "okay";
+};
-- 
1.8.3.2

