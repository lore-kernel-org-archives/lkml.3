Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBQJzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:55:04 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53333 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaBQJzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:55:03 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] tty: tty_ldisc.h: Remove duplicate include
Date: Mon, 17 Feb 2014 15:19:18 +0530
Message-Id: <1392630558-15064-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/wait.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 include/linux/tty_ldisc.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index b8347c207cb8..add26da2faeb 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -126,7 +126,6 @@
 
 #include <linux/fs.h>
 #include <linux/wait.h>
-#include <linux/wait.h>
 
 
 /*
-- 
1.7.9.5

