Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047Ab3IHWmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 18:42:42 -0400
Received: from mail.nt1.in ([62.90.139.210]:41433 "EHLO mail.nt1.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3IHWml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 18:42:41 -0400
X-Greylist: delayed 2618 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Sep 2013 18:42:40 EDT
Date: Mon, 9 Sep 2013 00:58:53 +0300
From: Regid Ichira <regid23@nt1.in>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] typo in drivers/thermal/Kconfig: lpatform instead of platform
Message-ID: <20130908215853.GD8821@nt1.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to the HEAD of linux.git,
                       VERSION = 3 PATCHLEVEL = 11 SUBLEVEL = 0
Signed-off-by: Regid Ichira <regid23@nt1.in>
---
 drivers/thermal/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index e988c81..3f99f79 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -47,7 +47,7 @@ config THERMAL_DEFAULT_GOV_USER_SPACE
 	select THERMAL_GOV_USER_SPACE
 	help
 	  Select this if you want to let the user space manage the
-	  lpatform thermals.
+	  platform thermals.
 
 endchoice
 
-- 
1.8.4.rc3
