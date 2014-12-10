Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaLJNyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:54:35 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:48091 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaLJNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:54:33 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH trivial 2/3] dt/bindings: arm-boards: Spelling s/pointong/pointing/
Date: Wed, 10 Dec 2014 14:54:29 +0100
Message-Id: <1418219670-18283-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418219670-18283-1-git-send-email-geert+renesas@glider.be>
References: <1418219670-18283-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>
---
 Documentation/devicetree/bindings/arm/arm-boards | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/arm-boards b/Documentation/devicetree/bindings/arm/arm-boards
index c554ed3d44fb7c77..e4dfb93c36322c3d 100644
--- a/Documentation/devicetree/bindings/arm/arm-boards
+++ b/Documentation/devicetree/bindings/arm/arm-boards
@@ -23,7 +23,7 @@ Required nodes:
     range of 0x200 bytes.
 
 - syscon: the root node of the Integrator platforms must have a
-  system controller node pointong to the control registers,
+  system controller node pointing to the control registers,
   with the compatible string
   "arm,integrator-ap-syscon"
   "arm,integrator-cp-syscon"
-- 
1.9.1

