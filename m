Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaI2NdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:33:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:2354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbaI2NdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393029991"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 06/18] mei: nfc: fix style warning
Date: Mon, 29 Sep 2014 16:31:38 +0300
Message-Id: <1411997510-29094-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
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

