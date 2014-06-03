Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaFCHdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:33:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43986 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932316AbaFCHdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:33:14 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: berlin: enable i2c0 and i2c2
Date: Tue,  3 Jun 2014 09:33:10 +0200
Message-Id: <1401780790-17830-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401780790-17830-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the I2C0 and I2C2 for the Marvell Berlin BG2G DMP. I2C1 and I2C3
are also working on this board, but no devices seemed to be there.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 995150f93795..a357ce02a64e 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -34,6 +34,14 @@
 	status = "okay";
 };
 
+&i2c0 {
+	status = "okay";
+};
+
+&i2c2 {
+	status = "okay";
+};
+
 &uart0 {
 	status = "okay";
 };
-- 
1.9.1

