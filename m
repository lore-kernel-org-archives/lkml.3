Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab3BZQcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:32:20 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33151 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896Ab3BZQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:32:11 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 8/9] v4l2: Add private controls base for SI476X
Date: Tue, 26 Feb 2013 08:31:34 -0800
Message-Id: <1361896295-26138-9-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361896295-26138-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361896295-26138-1-git-send-email-andrew.smirnov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a base to be used for allocation of all the SI476X specific
controls in the corresponding driver.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 include/uapi/linux/v4l2-controls.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 3e985be..22e5170 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -147,6 +147,10 @@ enum v4l2_colorfx {
  * of controls. We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
 
+/* The base for the si476x driver controls. See include/media/si476x.h for the list
+ * of controls. Total of 16 controls is reserved for that driver */
+#define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x1010)
+
 /* MPEG-class control IDs */
 
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.7.10.4

