Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaGKJDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:03:43 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37512 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaGKJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:03:41 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, akpm@linux-foundation.org, spk.linux@gmail.com
Subject: [PATCH 1/1] MAINTAINERS: Update Samsung pin control entry
Date: Fri, 11 Jul 2014 14:29:50 +0530
Message-Id: <1405069190-13986-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to reflect the recent file movement to a sub-directory.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
---
 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e3a517635eb4..898cf76f8837 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6943,9 +6943,7 @@ M:	Thomas Abraham <thomas.abraham@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 S:	Maintained
-F:	drivers/pinctrl/pinctrl-exynos.*
-F:	drivers/pinctrl/pinctrl-s3c*
-F:	drivers/pinctrl/pinctrl-samsung.*
+F:	drivers/pinctrl/samsung/
 
 PIN CONTROLLER - ST SPEAR
 M:	Viresh Kumar <viresh.linux@gmail.com>
-- 
1.7.9.5

