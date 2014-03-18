Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaCRK32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:29:28 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35461 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaCRK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:29:27 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 1/4] regulator: dbx500-prcmu: Silence checkpatch warnings
Date: Tue, 18 Mar 2014 15:53:01 +0530
Message-Id: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following warning type:
WARNING: Missing a blank line after declarations

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/dbx500-prcmu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index f111dfb8d2d7..538478883ae2 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -78,6 +78,7 @@ static struct ux500_regulator_debug {
 void ux500_regulator_suspend_debug(void)
 {
 	int i;
+
 	for (i = 0; i < rdebug.num_regulators; i++)
 		rdebug.state_before_suspend[i] =
 			rdebug.regulator_array[i].is_enabled;
@@ -86,6 +87,7 @@ void ux500_regulator_suspend_debug(void)
 void ux500_regulator_resume_debug(void)
 {
 	int i;
+
 	for (i = 0; i < rdebug.num_regulators; i++)
 		rdebug.state_after_suspend[i] =
 			rdebug.regulator_array[i].is_enabled;
-- 
1.7.9.5

