Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab3GKO1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:27:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab3GKO1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 85/98] vgacon: fix missing include.
Date: Thu, 11 Jul 2013 15:24:55 +0100
Message-Id: <1373552708-15235-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 0ab3691fa8ac15ed94f9e2fa7c2958ab41d2e3f5 upstream.

This fixes the build error.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/console/vgacon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 0dd6d96..9d8feac 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -42,6 +42,7 @@
 #include <linux/kd.h>
 #include <linux/slab.h>
 #include <linux/vt_kern.h>
+#include <linux/sched.h>
 #include <linux/selection.h>
 #include <linux/spinlock.h>
 #include <linux/ioport.h>
-- 
1.8.1.2

