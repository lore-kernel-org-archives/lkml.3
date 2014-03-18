Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbaCRKaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:30:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41357 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbaCRK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:29:32 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 3/4] regulator: max8925: Silence checkpatch warning
Date: Tue, 18 Mar 2014 15:53:03 +0530
Message-Id: <1395138184-25287-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
References: <1395138184-25287-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following type of checkpatch warning:
WARNING: Missing a blank line after declarations

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/max8925-regulator.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index e316abae004a..dad2bcd14e96 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -249,6 +249,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 {
 	struct device_node *nproot, *np;
 	int rcount;
+
 	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
-- 
1.7.9.5

