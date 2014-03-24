Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaCXUhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:37:24 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:41703 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaCXUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:37:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org
Subject: [PATCH trivial 3/3] PM / Runtime: Spelling s/competing/completing/
Date: Mon, 24 Mar 2014 21:37:03 +0100
Message-Id: <1395693423-5134-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
References: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
---
 drivers/base/power/generic_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
index a2e55bfdf572..96a92db83cad 100644
--- a/drivers/base/power/generic_ops.c
+++ b/drivers/base/power/generic_ops.c
@@ -285,7 +285,7 @@ int pm_generic_restore(struct device *dev)
 EXPORT_SYMBOL_GPL(pm_generic_restore);
 
 /**
- * pm_generic_complete - Generic routine competing a device power transition.
+ * pm_generic_complete - Generic routine completing a device power transition.
  * @dev: Device to handle.
  *
  * Complete a device power transition during a system-wide power transition.
-- 
1.7.9.5

