Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbaEMJeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:34:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60931 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760122AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/182] media: v4l2-dv-timings: add module name, description, license
Date: Tue, 13 May 2014 11:27:21 +0200
Message-Id: <54e926ee4716b6f47fc27cc64d71c786753d0b62.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c4885ada88e4331f8ac56d14296d0058359db2d7 upstream.

I completely forgot to add them when I made this module. Loading this module
without it will taint the kernel, which is not intended.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index ee52b9f4a944..c0895f88ce9c 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -26,6 +26,10 @@
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-dv-timings.h>
 
+MODULE_AUTHOR("Hans Verkuil");
+MODULE_DESCRIPTION("V4L2 DV Timings Helper Functions");
+MODULE_LICENSE("GPL");
+
 const struct v4l2_dv_timings v4l2_dv_timings_presets[] = {
 	V4L2_DV_BT_CEA_640X480P59_94,
 	V4L2_DV_BT_CEA_720X480I59_94,
-- 
1.9.3

