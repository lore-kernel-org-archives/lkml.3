Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaKQTEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:04:01 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60336 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaKQTEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:04:00 -0500
From: George McCollister <george.mccollister@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Brown <broonie@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] of: Add vendor prefix for NovaTech LLC
Date: Mon, 17 Nov 2014 13:02:34 -0600
Message-Id: <1416250957-11065-1-git-send-email-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.1.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For company details see:
http://www.novatechweb.com

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 723999d..8f1462e 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -105,6 +105,7 @@ netgear	NETGEAR
 newhaven	Newhaven Display International
 nintendo	Nintendo
 nokia	Nokia
+novatech	NovaTech LLC
 nvidia	NVIDIA
 nxp	NXP Semiconductors
 onnn	ON Semiconductor Corp.
-- 
2.1.0

