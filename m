Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbaG3SOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:14:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57843 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755500AbaG3SOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:14:07 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v14 8/8] ARM: berlin: enable the eSATA interface on the BG2Q DMP
Date: Wed, 30 Jul 2014 20:14:01 +0200
Message-Id: <1406744041-1269-9-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406744041-1269-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1406744041-1269-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BG2Q has an AHCI SATA controller with an eSATA interface. Enable it.
Only enable the first port, the BG2Q DMP does not support the second one.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 995150f93795..385f6af64d0c 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -37,3 +37,11 @@
 &uart0 {
 	status = "okay";
 };
+
+&sata0 {
+	status = "okay";
+};
+
+&sata_phy {
+	status = "okay";
+};
-- 
1.9.1

