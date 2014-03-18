Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaCRK3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:29:39 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45603 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbaCRK3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:29:35 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 4/4] regulator: max8952: Silence checkpatch warning
Date: Tue, 18 Mar 2014 15:53:04 +0530
Message-Id: <1395138184-25287-4-git-send-email-sachin.kamat@linaro.org>
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
 drivers/regulator/max8952.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index c5ee3cc048ee..d920f5a32ec8 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -57,6 +57,7 @@ struct max8952_data {
 static int max8952_read_reg(struct max8952_data *max8952, u8 reg)
 {
 	int ret = i2c_smbus_read_byte_data(max8952->client, reg);
+
 	if (ret > 0)
 		ret &= 0xff;
 
-- 
1.7.9.5

