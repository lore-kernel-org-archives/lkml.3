Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbaJVJin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:38:43 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:41991 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616AbaJVJii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:38:38 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/3] clocksource: sh_tmu: Document R-Mobile r8a7740 binding
Date: Wed, 22 Oct 2014 11:38:27 +0200
Message-Id: <1413970709-26607-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compared to the r8a7779, the r8a7740 lacks the input capture register,
which is not used by the driver (the current driver already handles the
r8a7740 in the non-DT case).

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/timer/renesas,tmu.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/timer/renesas,tmu.txt b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
index 7db89fb2544411b5..4ae7910af09ffcb4 100644
--- a/Documentation/devicetree/bindings/timer/renesas,tmu.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,tmu.txt
@@ -1,4 +1,4 @@
-* Renesas R-Car Timer Unit (TMU)
+* Renesas R-Mobile/R-Car Timer Unit (TMU)
 
 The TMU is a 32-bit timer/counter with configurable clock inputs and
 programmable compare match.
@@ -9,6 +9,7 @@ are independent. The TMU hardware supports up to three channels.
 Required Properties:
 
   - compatible: must contain one or more of the following:
+    - "renesas,tmu-r8a7740" for the r8a7740 TMU
     - "renesas,tmu-r8a7779" for the r8a7779 TMU
     - "renesas,tmu" for any TMU.
       This is a fallback for the above renesas,tmu-* entries
-- 
1.9.1

