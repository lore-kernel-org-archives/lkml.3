Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaBHIul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:50:41 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43756 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaBHIui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:50:38 -0500
From: Laszlo Papp <lpapp@kde.org>
To: grant.likely@secretlab.ca, rob@landley.net
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] usage-model.txt: fix a typo
Date: Sat,  8 Feb 2014 08:50:18 +0000
Message-Id: <1391849418-5125-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 Documentation/devicetree/usage-model.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/usage-model.txt b/Documentation/devicetree/usage-model.txt
index 2b6b3d3..cd2eae5 100644
--- a/Documentation/devicetree/usage-model.txt
+++ b/Documentation/devicetree/usage-model.txt
@@ -123,7 +123,7 @@ successor, the BeagleBoard xM board might look like, respectively:
 	compatible = "ti,omap3-beagleboard-xm", "ti,omap3450", "ti,omap3";
 
 Where "ti,omap3-beagleboard-xm" specifies the exact model, it also
-claims that it compatible with the OMAP 3450 SoC, and the omap3 family
+claims that it is compatible with the OMAP 3450 SoC, and the omap3 family
 of SoCs in general.  You'll notice that the list is sorted from most
 specific (exact board) to least specific (SoC family).
 
-- 
1.8.5.4

