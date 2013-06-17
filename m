Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3FQPVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:21:22 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61258 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3FQPVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:21:20 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 01/11] media: davinci: vpif: remove unwanted header mach/hardware.h and sort the includes alphabetically
Date: Mon, 17 Jun 2013 20:50:41 +0530
Message-Id: <1371482451-18314-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch removes unwanted header include of mach/hardware.h
and along side sorts the header inclusion alphabetically.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/davinci/vpif.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

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
1.7.9.5

