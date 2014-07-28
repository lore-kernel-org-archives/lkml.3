Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaG1MUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:20:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaG1MSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:18:22 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org, Hakjoo Kim <ruppi.kim@hardkernel.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH 1/5] ARM: dts: exynos5410: Clean up SMDK5410 indentation
Date: Mon, 28 Jul 2014 14:18:08 +0200
Message-Id: <1406549892-5558-2-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406549892-5558-1-git-send-email-afaerber@suse.de>
References: <1406549892-5558-1-git-send-email-afaerber@suse.de>
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
 arch/arm/boot/dts/exynos5410-smdk5410.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5410-smdk5410.dts b/arch/arm/boot/dts/exynos5410-smdk5410.dts
index 7275bbd6fc4b..4c495de1bf68 100644
--- a/arch/arm/boot/dts/exynos5410-smdk5410.dts
+++ b/arch/arm/boot/dts/exynos5410-smdk5410.dts
@@ -70,13 +70,13 @@
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
1.9.3

