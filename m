Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3EYQiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 12:38:22 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58478 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab3EYQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 12:38:18 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 1/5] media: davinci: vpif: remove unwanted header mach/hardware.h and sort the includes alphabetically
Date: Sat, 25 May 2013 22:06:32 +0530
Message-Id: <1369499796-18762-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch removes unwanted header include of mach/hardware.h
and along side sorts the header inclusion alphabetically.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index ea82a8b..761c825 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -17,18 +17,16 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/err.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/spinlock.h>
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/err.h>
 #include <linux/pm_runtime.h>
+#include <linux/spinlock.h>
 #include <linux/v4l2-dv-timings.h>
 
-#include <mach/hardware.h>
-
 #include "vpif.h"
 
 MODULE_DESCRIPTION("TI DaVinci Video Port Interface driver");
-- 
1.7.0.4

