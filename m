Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCPMhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 08:37:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaCPMhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 08:37:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,664,1389772800"; 
   d="scan'208";a="493061444"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/5] mei: fix Unnecessary space after function pointer name
Date: Sun, 16 Mar 2014 14:35:54 +0200
Message-Id: <1394973358-21690-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
References: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warining:
Unnecessary space after function pointer name

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 2ef5593..94a5167 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -237,20 +237,20 @@ struct mei_cl {
  */
 struct mei_hw_ops {
 
-	bool (*host_is_ready) (struct mei_device *dev);
+	bool (*host_is_ready)(struct mei_device *dev);
 
-	bool (*hw_is_ready) (struct mei_device *dev);
-	int (*hw_reset) (struct mei_device *dev, bool enable);
-	int  (*hw_start) (struct mei_device *dev);
-	void (*hw_config) (struct mei_device *dev);
+	bool (*hw_is_ready)(struct mei_device *dev);
+	int (*hw_reset)(struct mei_device *dev, bool enable);
+	int (*hw_start)(struct mei_device *dev);
+	void (*hw_config)(struct mei_device *dev);
 
-	void (*intr_clear) (struct mei_device *dev);
-	void (*intr_enable) (struct mei_device *dev);
-	void (*intr_disable) (struct mei_device *dev);
+	void (*intr_clear)(struct mei_device *dev);
+	void (*intr_enable)(struct mei_device *dev);
+	void (*intr_disable)(struct mei_device *dev);
 
-	int (*hbuf_free_slots) (struct mei_device *dev);
-	bool (*hbuf_is_ready) (struct mei_device *dev);
-	size_t (*hbuf_max_len) (const struct mei_device *dev);
+	int (*hbuf_free_slots)(struct mei_device *dev);
+	bool (*hbuf_is_ready)(struct mei_device *dev);
+	size_t (*hbuf_max_len)(const struct mei_device *dev);
 
 	int (*write)(struct mei_device *dev,
 		     struct mei_msg_hdr *hdr,
@@ -259,7 +259,7 @@ struct mei_hw_ops {
 	int (*rdbuf_full_slots)(struct mei_device *dev);
 
 	u32 (*read_hdr)(const struct mei_device *dev);
-	int (*read) (struct mei_device *dev,
+	int (*read)(struct mei_device *dev,
 		     unsigned char *buf, unsigned long len);
 };
 
-- 
1.8.5.3

