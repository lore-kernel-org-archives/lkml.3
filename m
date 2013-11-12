Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3KLKld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:41:33 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:61203 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KLKlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:41:32 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] MAINTAINERS: Add maintainer for the ARM Ux500 clock driver
Date: Tue, 12 Nov 2013 11:41:12 +0100
Message-Id: <1384252872-5717-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 284969f..1d0ae30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1296,6 +1296,14 @@ F:	drivers/rtc/rtc-ab8500.c
 F:	drivers/rtc/rtc-pl031.c
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
 
+ARM/Ux500 CLOCK FRAMEWORK SUPPORT
+M:	Ulf Hansson <ulf.hansson@linaro.org>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+T:	git git://git.linaro.org/people/ulfh/clk.git
+S:	Maintained
+F:	drivers/clk/ux500/
+F:	include/linux/platform_data/clk-ux500.h
+
 ARM/VFP SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.7.9.5

