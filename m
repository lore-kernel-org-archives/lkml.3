Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3BZGje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:39:34 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63686 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3BZGjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:39:32 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/8] v4l2: Add private controls base for SI476X
Date: Mon, 25 Feb 2013 22:38:53 -0800
Message-Id: <1361860734-21666-8-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
References: <1361860734-21666-1-git-send-email-andrew.smirnov@gmail.com>
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
index 296d20e..133703d 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -147,6 +147,10 @@ enum v4l2_colorfx {
  * of controls. We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_MEYE_BASE			(V4L2_CID_USER_BASE + 0x1000)
 
+/* The base for the si476x driver controls. See include/media/si476x.h for the list
+ * of controls. */
+#define V4L2_CID_USER_SI476X_BASE		(V4L2_CID_USER_BASE + 0x2000)
+
 /* MPEG-class control IDs */
 
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.7.10.4

