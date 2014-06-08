Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaFHL0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 07:26:38 -0400
Received: from smtp40.i.mail.ru ([94.100.177.100]:49916 "EHLO smtp40.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbaFHL0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 07:26:37 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/2] regulator: mc13xxx: Remove unused field "hi_bit"
Date: Sun,  8 Jun 2014 15:26:28 +0400
Message-Id: <1402226789-25928-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.5.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Field "hi_bit" is not used anywhere in the driver.
This patch removes this excess field.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/regulator/mc13xxx.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index 06c8903..2ab9bfd 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -21,7 +21,6 @@ struct mc13xxx_regulator {
 	int vsel_reg;
 	int vsel_shift;
 	int vsel_mask;
-	int hi_bit;
 };
 
 struct mc13xxx_regulator_priv {
-- 
1.8.5.5

