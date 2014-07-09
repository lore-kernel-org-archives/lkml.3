Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaGIMYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:24:00 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:48502 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbaGIMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:23:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ian Molton <ian.molton@codethink.co.uk>, Chris Ball <chris@printf.net>,
        linux-mmc@vger.kernel.org
Subject: [PATCH 04/13] mmc: tmio-mmc: Add renesas,sdhi-r8a7791 to binding documentation
Date: Wed,  9 Jul 2014 14:23:34 +0200
Message-Id: <1404908623-909-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver already supports the r8a7791 SoC, and "renesas,sdhi-r8a7791"
is already in use.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Ian Molton <ian.molton@codethink.co.uk>
Cc: Chris Ball <chris@printf.net>
Cc: linux-mmc@vger.kernel.org
---
 Documentation/devicetree/bindings/mmc/tmio_mmc.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
index 6a2a1160a70d..fa0f327cde01 100644
--- a/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/tmio_mmc.txt
@@ -18,6 +18,7 @@ Required properties:
 		"renesas,sdhi-r8a7778" - SDHI IP on R8A7778 SoC
 		"renesas,sdhi-r8a7779" - SDHI IP on R8A7779 SoC
 		"renesas,sdhi-r8a7790" - SDHI IP on R8A7790 SoC
+		"renesas,sdhi-r8a7791" - SDHI IP on R8A7791 SoC
 
 Optional properties:
 - toshiba,mmc-wrprotect-disable: write-protect detection is unavailable
-- 
1.9.1

