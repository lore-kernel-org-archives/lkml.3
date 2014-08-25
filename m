Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639AbaHYVyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:54:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:11405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607AbaHYVyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,398,1406617200"; 
   d="scan'208";a="563299649"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 06/10] mei: pg: fix cat and paste error in comments
Date: Tue, 26 Aug 2014 00:53:24 +0300
Message-Id: <1409003608-30274-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
References: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
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

