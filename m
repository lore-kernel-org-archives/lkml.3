Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaJXLb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:31:57 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:33790 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaJXLb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:31:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] clocksource: sh_mtu2: Drop incorrect SoC family name
Date: Fri, 24 Oct 2014 13:29:38 +0200
Message-Id: <1414150178-4986-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPU2 hardware block is found in many Renesas SH and ARM SoCs, but
not in R-Car.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - Drop family name instead of changing it to RZ.
---
 Documentation/devicetree/bindings/timer/renesas,mtu2.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
index d9a8d5af1a21270f..ba0a34d97eb80261 100644
--- a/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
+++ b/Documentation/devicetree/bindings/timer/renesas,mtu2.txt
@@ -1,4 +1,4 @@
-* Renesas R-Car Multi-Function Timer Pulse Unit 2 (MTU2)
+* Renesas Multi-Function Timer Pulse Unit 2 (MTU2)
 
 The MTU2 is a multi-purpose, multi-channel timer/counter with configurable
 clock inputs and programmable compare match.
-- 
1.9.1

