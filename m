Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaKVU0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 15:26:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaKVU0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 15:26:39 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?q?=EA=B9=80=ED=95=99=EC=A3=BC?= <ruppi.kim@hardkernel.com>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH v2 1/5] ARM: dts: exynos5410: Clean up SMDK5410 indentation
Date: Sat, 22 Nov 2014 21:26:20 +0100
Message-Id: <1416687984-3546-2-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416687984-3546-1-git-send-email-afaerber@suse.de>
References: <1416687984-3546-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UART status properties are indented one level too deep, and we want
to derive a device tree for the ODROID-XU. Fix this before it propagates.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
v1 -> v2: Unchanged

 arch/arm/boot/dts/exynos5410-smdk5410.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
index be3e02530b42..cebeaab3abec 100644
--- a/arch/arm/boot/dts/exynos5410-smdk5410.dts
+++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
@@ -62,13 +62,13 @@
 };
 
 &uart0 {
-		status = "okay";
+	status = "okay";
 };
 
 &uart1 {
-		status = "okay";
+	status = "okay";
 };
 
 &uart2 {
-		status = "okay";
+	status = "okay";
 };
-- 
2.1.2

