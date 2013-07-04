Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab3GDGy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:54:26 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60597 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3GDGyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:54:23 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sachin.kamat@linaro.org, patches@linaro.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/1] MAINTAINERS: Upgate git repo for voltage & current regulator f/w entry
Date: Thu,  4 Jul 2013 12:08:50 +0530
Message-Id: <1372919930-513-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current git repository hasn't been updated since quite a long time.
Update it with Mark's git repo which is the currently maintained one.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 940792b..9a363ca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8988,7 +8988,7 @@ M:	Liam Girdwood <lgirdwood@gmail.com>
 M:	Mark Brown <broonie@kernel.org>
 W:	http://opensource.wolfsonmicro.com/node/15
 W:	http://www.slimlogic.co.uk/?p=48
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lrg/regulator.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
 S:	Supported
 F:	drivers/regulator/
 F:	include/linux/regulator/
-- 
1.7.9.5

