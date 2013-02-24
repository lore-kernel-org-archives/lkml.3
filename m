Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab3BXVRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 16:17:12 -0500
Received: from mail-gh0-f182.google.com ([209.85.160.182]:43118 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab3BXVRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 16:17:11 -0500
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH] hv: hv_balloon.c: Remove duplicated mman.h include.
Date: Sun, 24 Feb 2013 18:17:00 -0300
Message-Id: <1361740620-19665-1-git-send-email-tfarina@chromium.org>
X-Mailer: git-send-email 1.8.1.151.g32238ae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfarina@chromium.org>
---
 drivers/hv/hv_balloon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index dd289fd..c02a33e 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -29,7 +29,6 @@
 #include <linux/memory_hotplug.h>
 #include <linux/memory.h>
 #include <linux/notifier.h>
-#include <linux/mman.h>
 #include <linux/percpu_counter.h>
 
 #include <linux/hyperv.h>
-- 
1.8.1.151.g32238ae

