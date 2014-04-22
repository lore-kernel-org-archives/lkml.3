Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaDVSkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:40:37 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:55397 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaDVSka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:40:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4/4] of/irq: Typo s/interrupts-names/interrupt-names/g
Date: Tue, 22 Apr 2014 20:40:25 +0200
Message-Id: <1398192025-31523-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
References: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 9bcf2cf19357..e2e4c548a42f 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -364,7 +364,7 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
 
 		memset(r, 0, sizeof(*r));
 		/*
-		 * Get optional "interrupts-names" property to add a name
+		 * Get optional "interrupt-names" property to add a name
 		 * to the resource.
 		 */
 		of_property_read_string_index(dev, "interrupt-names", index,
-- 
1.7.9.5

