Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3G2Tyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:54:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38451 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3G2Tym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:54:42 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Mon, 29 Jul 2013 20:54:37 +0100
Message-Id: <1375127677-29327-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Add missing stub for regulator_get_exclusive()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/regulator/consumer.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 3610df8..3b9b4da 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -217,6 +217,12 @@ devm_regulator_get(struct device *dev, const char *id)
 	return NULL;
 }
 
+static inline struct regulator *__must_check
+devm_regulator_get_exclusive(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
 static inline void regulator_put(struct regulator *regulator)
 {
 }
-- 
1.8.3.2

