Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaFWLYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:24:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54849 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaFWLYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:24:42 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, kheitke@codeaurora.org, spk.linux@gmail.com
Subject: [PATCH 1/1] spmi: Remove duplicate inclusion of module.h
Date: Mon, 23 Jun 2014 16:51:27 +0530
Message-Id: <1403522487-21197-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 drivers/spmi/spmi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index 3b5780710d50..1d92f5103ebf 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -18,7 +18,6 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/spmi.h>
-#include <linux/module.h>
 #include <linux/pm_runtime.h>
 
 #include <dt-bindings/spmi/spmi.h>
-- 
1.7.9.5

