Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbaKSP7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:59:17 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:54160 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaKSP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:57:41 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/7] PM / Domains: Document SH-Mobile AG5 (sh73a0) binding
Date: Wed, 19 Nov 2014 16:57:28 +0100
Message-Id: <1416412654-6508-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
References: <1416412654-6508-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH-Mobile AG5 (sh73a0) can be handled by the existing bindings.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt b/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
index 89ca3f35aec69750..061971bb387f7b27 100644
--- a/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
+++ b/Documentation/devicetree/bindings/power/renesas,sysc-rmobile.txt
@@ -12,6 +12,7 @@ Required properties:
 	      fallback.
 	      Examples with soctypes are:
 		- "renesas,sysc-r8a7740" (R-Mobile A1)
+		- "renesas,sysc-sh73a0" (SH-Mobile AG5)
 - reg: Two address start and address range blocks for the device:
          - The first block refers to the normally accessible registers,
          - the second block refers to the registers protected by the HPB
-- 
1.9.1

