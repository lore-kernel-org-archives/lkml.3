Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbaDVPll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:41:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49895 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933061AbaDVPjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:39:02 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] ARM: berlin: enable the eSATA interface on the BG2Q DMP
Date: Tue, 22 Apr 2014 17:38:23 +0200
Message-Id: <1398181105-19714-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BG2Q has an AHCI SATA controller with an eSATA interface. Enable it.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
index 2da9c41e29d8..26047ceed603 100644
--- a/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
+++ b/arch/arm/boot/dts/berlin2q-marvell-dmp.dts
@@ -26,3 +26,8 @@
 &uart0 {
 	status = "okay";
 };
+
+&ahci {
+	status = "okay";
+	marvell,force-port-map = <1>;
+};
-- 
1.8.3.2

