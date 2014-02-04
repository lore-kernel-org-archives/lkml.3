Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaBDJM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:12:28 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:47833 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaBDJMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:12:19 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH Resend] mfd: stmpe: Remove unnecessary semicolon
Date: Tue,  4 Feb 2014 14:37:13 +0530
Message-Id: <1391504833-20022-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semicolon is not necessary after the while statement.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/stmpe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 42ccd0544513..4a91f6771fb8 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -706,7 +706,7 @@ static int stmpe1801_reset(struct stmpe *stmpe)
 		if (!(ret & STMPE1801_MSK_SYS_CTRL_RESET))
 			return 0;
 		usleep_range(100, 200);
-	};
+	}
 	return -EIO;
 }
 
-- 
1.7.9.5

