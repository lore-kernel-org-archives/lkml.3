Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaIPT7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:59:40 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:54000 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbaIPT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:59:38 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <trivial@kernel.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] PM / Domains: Spelling s/domian/domain/
Date: Tue, 16 Sep 2014 21:59:39 +0200
Message-Id: <1410897579-28240-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/base/power/domain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index cf4651a15a5753e5..e6a11ca3ce2634ab 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1833,7 +1833,7 @@ int pm_genpd_name_detach_cpuidle(const char *name)
 /* Default device callbacks for generic PM domains. */
 
 /**
- * pm_genpd_default_save_state - Default "save device state" for PM domians.
+ * pm_genpd_default_save_state - Default "save device state" for PM domains.
  * @dev: Device to handle.
  */
 static int pm_genpd_default_save_state(struct device *dev)
@@ -1856,7 +1856,7 @@ static int pm_genpd_default_save_state(struct device *dev)
 }
 
 /**
- * pm_genpd_default_restore_state - Default PM domians "restore device state".
+ * pm_genpd_default_restore_state - Default PM domains "restore device state".
  * @dev: Device to handle.
  */
 static int pm_genpd_default_restore_state(struct device *dev)
-- 
1.9.1

