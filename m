Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaLGQLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 11:11:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54855 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaLGQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 11:11:49 -0500
Date: Sun, 7 Dec 2014 17:11:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: tony@atomide.com, bcousson@baylibre.com, robh+dt@kernel.org,
        trivial@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] dts: omap3-n900: cleanup english
Message-ID: <20141207161147.GA18588@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes english in comments and removes extra empty newline.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 11d8afd..9e0e5a2 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -287,7 +287,7 @@
 	regulator-name = "V28";
 	regulator-min-microvolt = <2800000>;
 	regulator-max-microvolt = <2800000>;
-	regulator-always-on; /* due battery cover sensor */
+	regulator-always-on; /* due to battery cover sensor */
 };
 
 &vaux2 {
@@ -345,7 +345,6 @@
 	regulator-name = "VIO";
 	regulator-min-microvolt = <1800000>;
 	regulator-max-microvolt = <1800000>;
-
 };
 
 &vintana1 {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
