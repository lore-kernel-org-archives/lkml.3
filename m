Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaENMuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:50:50 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:48194 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbaENMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:50:49 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>
Cc: linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] MAINTAINERS: mmc: Add path to git tree
Date: Wed, 14 May 2014 14:50:44 +0200
Message-Id: <1400071844-21931-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tree has already been added to Stephen Rothwell's list for
linux-next. Make it visible in the MAINTAINERS file as well.

Cc: Chris Ball <chris@printf.net>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2803c7..3b58515 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5935,6 +5935,7 @@ M:	Chris Ball <chris@printf.net>
 M:	Ulf Hansson <ulf.hansson@linaro.org>
 L:	linux-mmc@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
+T:	git git://git.linaro.org/people/ulf.hansson/mmc.git
 S:	Maintained
 F:	drivers/mmc/
 F:	include/linux/mmc/
-- 
1.7.9.5

