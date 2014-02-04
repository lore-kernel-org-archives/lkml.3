Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaBDV7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:59:18 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:48987 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbaBDV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:59:15 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] DT: Add vendor prefix for Spansion Inc.
Date: Tue,  4 Feb 2014 22:59:09 +0100
Message-Id: <1391551149-15958-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

This is already in active use in several DTS files.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 3f900cd51bf0..29afbdedec3c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -78,6 +78,7 @@ silabs	Silicon Laboratories
 simtek
 sirf	SiRF Technology, Inc.
 snps 	Synopsys, Inc.
+spansion	Spansion Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
-- 
1.7.9.5

