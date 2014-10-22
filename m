Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaJVJpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:45:03 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:52818 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaJVJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:44:58 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/4] of: Grammar s/an/a/
Date: Wed, 22 Oct 2014 11:44:54 +0200
Message-Id: <1413971095-27192-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413971095-27192-1-git-send-email-geert+renesas@glider.be>
References: <1413971095-27192-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 48d6673fa9a28bf0..cff3afcff1951faf 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -923,7 +923,7 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 }
 
 /**
- * of_match_node - Tell if an device_node has a matching of_match structure
+ * of_match_node - Tell if a device_node has a matching of_match structure
  *	@matches:	array of of device match structures to search in
  *	@node:		the of device structure to match against
  *
-- 
1.9.1

