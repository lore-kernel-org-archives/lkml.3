Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaJXLb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:31:59 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:33780 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbaJXLb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:31:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] clocksource: sh_tmu: Document r8a7778 binding
Date: Fri, 24 Oct 2014 13:31:52 +0200
Message-Id: <1414150312-5542-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The r8a7778 is very similar to the r8a7779, and already handled by
the current driver in the non-DT case.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This depends on "clocksource: sh_tmu: Document R-Mobile r8a7740 binding"

 Documentation/devicetree/bindings/timer/renesas,tmu.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
index 4ae7910af09ffcb4..cd5f20bf2582e742 100644
--- a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
@@ -10,6 +10,7 @@ Required Properties:
 
   - compatible: must contain one or more of the following:
     - "renesas,tmu-r8a7740" for the r8a7740 TMU
+    - "renesas,tmu-r8a7778" for the r8a7778 TMU
     - "renesas,tmu-r8a7779" for the r8a7779 TMU
     - "renesas,tmu" for any TMU.
       This is a fallback for the above renesas,tmu-* entries
-- 
1.9.1

