Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaKLWoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:44:00 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:56791 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaKLWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:43:58 -0500
From: George McCollister <george.mccollister@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>, Jason Cooper <jason@lakedaemon.net>,
        Shawn Guo <shawn.guo@freescale.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] of: Add vendor prefix for NovaTech LLC
Date: Wed, 12 Nov 2014 16:41:32 -0600
Message-Id: <1415832094-20991-1-git-send-email-george.mccollister@gmail.com>
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

