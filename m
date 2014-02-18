Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaBRXBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:01:33 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34719 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaBRXBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:01:12 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>
Cc: linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] MAINTAINERS: Add maintainer for the mmc subsystem
Date: Wed, 19 Feb 2014 00:01:05 +0100
Message-Id: <1392764465-14927-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put myself as a (co)maintainer of the mmc subsystem to help out Chris
Ball in a more official role.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---

Chris, if you are happy having me as your co-maintainer, the plan from
my side are to review and ack patches, but from a more official role
than what I have currently. Then let's see how things evolve.

---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..37d58a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5800,6 +5800,7 @@ F:	include/linux/mfd/
 
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 M:	Chris Ball <chris@printf.net>
+M:	Ulf Hansson <ulf.hansson@linaro.org>
 L:	linux-mmc@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
 S:	Maintained
-- 
1.7.9.5

