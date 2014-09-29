Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaI2Nil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:38:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:2354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbaI2Ncw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:32:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393029959"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [RESEND char-misc-next 04/18] mei: pg: fix cat and paste error in comments
Date: Mon, 29 Sep 2014 16:31:36 +0300
Message-Id: <1411997510-29094-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hw-me.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 498bd42..241eae5 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -457,7 +457,7 @@ static int mei_me_read_slots(struct mei_device *dev, unsigned char *buffer,
 }
 
 /**
- * mei_me_pg_enter - write pg enter register to mei device.
+ * mei_me_pg_enter - write pg enter register
  *
  * @dev: the device structure
  */
@@ -470,7 +470,7 @@ static void mei_me_pg_enter(struct mei_device *dev)
 }
 
 /**
- * mei_me_pg_enter - write pg enter register to mei device.
+ * mei_me_pg_exit - write pg exit register
  *
  * @dev: the device structure
  */
-- 
1.9.3

