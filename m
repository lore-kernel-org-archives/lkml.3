Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaGIMX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:23:58 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:55316 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaGIMXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:23:55 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 01/13] of: Add vendor prefix for Sitronix
Date: Wed,  9 Jul 2014 14:23:31 +0200
Message-Id: <1404908623-909-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The stock ticker for Sitronix is just a number.
"sitronix,st1232" is used for the Sitronix st1232 touchscreen controller.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 46a311e728a8..967bb7797a54 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -120,6 +120,7 @@ silabs	Silicon Laboratories
 simtek
 sii	Seiko Instruments, Inc.
 sirf	SiRF Technology, Inc.
+sitronix	Sitronix Technology Corporation
 smsc	Standard Microsystems Corporation
 snps 	Synopsys, Inc.
 spansion	Spansion Inc.
-- 
1.9.1

