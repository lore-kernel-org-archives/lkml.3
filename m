Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaEDPl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaEDPlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 113/158] media: v4l2-dv-timings: add module name, description, license
Date: Sun,  4 May 2014 11:40:22 -0400
Message-Id: <20140504154045.361445941@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit c4885ada88e4331f8ac56d14296d0058359db2d7 upstream.

I completely forgot to add them when I made this module. Loading this module
without it will taint the kernel, which is not intended.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 ++++
 1 file changed, 4 insertions(+)

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


