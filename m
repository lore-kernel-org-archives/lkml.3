Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbaHYVyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:54:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:11445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933601AbaHYVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:54:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,398,1406617200"; 
   d="scan'208";a="563299676"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 08/10] mei: nfc: fix style warning
Date: Tue, 26 Aug 2014 00:53:26 +0300
Message-Id: <1409003608-30274-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
References: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix style warning:
void function return statements are not generally useful

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/nfc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 2888e6f..8cc93e4 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -472,7 +472,6 @@ err:
 	mei_nfc_free(ndev);
 	mutex_unlock(&dev->device_lock);
 
-	return;
 }
 
 
-- 
1.9.3

