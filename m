Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaIXOwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:52:05 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:41502 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaIXOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:49:24 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl@merrii.com, Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH v2 7/7] Documentation: sunxi: Add A80 datasheet link
Date: Wed, 24 Sep 2014 22:49:01 +0800
Message-Id: <1411570141-29960-8-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411570141-29960-1-git-send-email-wens@csie.org>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have initial support for the A80, as well a the datasheet.
Update the documents to reflect this.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/arm/sunxi/README | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm/sunxi/README b/Documentation/arm/sunxi/README
index 7945238..9477d6e 100644
--- a/Documentation/arm/sunxi/README
+++ b/Documentation/arm/sunxi/README
@@ -49,4 +49,5 @@ SunXi family
 
     * Quad ARM Cortex-A15, Quad ARM Cortex-A7 based SoCs
       - Allwinner A80
-        + Not Supported
\ No newline at end of file
+        + Datasheet
+	  http://dl.linux-sunxi.org/A80/A80_Datasheet_Revision_1.0_0404.pdf
-- 
2.1.0

