Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaCPMh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 08:37:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:47134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaCPMhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 08:37:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,664,1389772800"; 
   d="scan'208";a="493061461"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/5] mei: amthif: fix checkpatch error
Date: Sun, 16 Mar 2014 14:35:57 +0200
Message-Id: <1394973358-21690-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
References: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: else should follow close brace '}'
+	}
+	else {

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 2052609..b8deb34 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -247,8 +247,7 @@ int mei_amthif_read(struct mei_device *dev, struct file *file,
 	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
 		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
 		rets = -EFAULT;
-	}
-	else {
+	} else {
 		rets = length;
 		if ((*offset + length) < cb->buf_idx) {
 			*offset += length;
-- 
1.8.5.3

