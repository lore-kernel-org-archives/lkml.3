Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3DMUmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 16:42:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:63534 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab3DMUmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 16:42:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,468,1363158000"; 
   d="scan'208";a="285767646"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mie:wd: fix line over 80 characters
Date: Sat, 13 Apr 2013 23:41:25 +0300
Message-Id: <1365885685-9193-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: line over 80 characters

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

---
 drivers/misc/mei/wd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 2413247..eb3f05c 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -317,7 +317,8 @@ end:
  *
  * returns 0 if success, negative errno code for failure
  */
-static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev, unsigned int timeout)
+static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev,
+		unsigned int timeout)
 {
 	struct mei_device *dev;
 
-- 
1.8.1.2

