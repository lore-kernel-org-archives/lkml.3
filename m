Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571Ab3DBNIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:08:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53241 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760072Ab3DBNIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:08:30 -0400
Message-ID: <1364908104.9803.3.camel@phoenix>
Subject: [PATCH] regulator: dbx500-prcmu: Remove operating_point from struct
 dbx500_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Apr 2013 21:08:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

operating_point is not used since the initial commit of db8500-prcmu driver,
remove it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/dbx500-prcmu.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/dbx500-prcmu.h b/drivers/regulator/dbx500-prcmu.h
index e763883..c8e51ac 100644
--- a/drivers/regulator/dbx500-prcmu.h
+++ b/drivers/regulator/dbx500-prcmu.h
@@ -21,7 +21,6 @@
  * @is_enabled: status of the regulator
  * @epod_id: id for EPOD (power domain)
  * @is_ramret: RAM retention switch for EPOD (power domain)
- * @operating_point: operating point (only for vape, to be removed)
  *
  */
 struct dbx500_regulator_info {
@@ -32,7 +31,6 @@ struct dbx500_regulator_info {
 	u16 epod_id;
 	bool is_ramret;
 	bool exclude_from_power_state;
-	unsigned int operating_point;
 };
 
 void power_state_active_enable(void);
-- 
1.7.10.4



