Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaJVJo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:44:59 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:50881 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaJVJo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:44:57 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/4] of: Correct of_phandle_args node reference in comments
Date: Wed, 22 Oct 2014 11:44:52 +0200
Message-Id: <1413971095-27192-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device_node pointer in struct of_phandle_args is called "np", not
"node".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2305dc0382bca0a5..e3f9043860c81b5d 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1560,7 +1560,7 @@ EXPORT_SYMBOL(of_parse_phandle);
  * Returns 0 on success and fills out_args, on error returns appropriate
  * errno value.
  *
- * Caller is responsible to call of_node_put() on the returned out_args->node
+ * Caller is responsible to call of_node_put() on the returned out_args->np
  * pointer.
  *
  * Example:
@@ -1603,7 +1603,7 @@ EXPORT_SYMBOL(of_parse_phandle_with_args);
  * Returns 0 on success and fills out_args, on error returns appropriate
  * errno value.
  *
- * Caller is responsible to call of_node_put() on the returned out_args->node
+ * Caller is responsible to call of_node_put() on the returned out_args->np
  * pointer.
  *
  * Example:
-- 
1.9.1

