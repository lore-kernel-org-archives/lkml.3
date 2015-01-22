Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbbAVUip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:38:45 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46762 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbAVUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:38:41 -0500
From: Marek Belisko <marek@goldelico.com>
To: bcousson@baylibre.com, tony@atomide.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hns@goldelico.com, neilb@suse.de
Subject: [PATCH 01/13] ARM: dts: omap3-gta04: Fix backup-battery charging in devicetree file.
Date: Thu, 22 Jan 2015 21:38:07 +0100
Message-Id: <1421959099-28319-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421959099-28319-1-git-send-email-marek@goldelico.com>
References: <1421959099-28319-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

Fix attribute names.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 655d6e9..fa39232 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -342,8 +342,8 @@
 };
 
 &charger {
-	bb_uvolt = <3200000>;
-	bb_uamp = <150>;
+	ti,bb-uvolt = <3200000>;
+	ti,bb-uamp = <150>;
 };
 
 /* spare */
-- 
1.9.1

