Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaC2SWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:22:47 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51061 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaC2SWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:22:45 -0400
Date: Sat, 29 Mar 2014 23:53:09 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: xjtuwjp@gmail.com, lindar_liu@usish.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 34/55] scsi: Mark function as static in pm8001/pm8001_init.c
Message-ID: <ca780bfbb7ca9735cc26da4a7556c2bcb686f56b.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in pm8001/pm8001_init.c because it is not used
outside this file.

This eliminates the following warning in pm8001/pm8001_init.c:
drivers/scsi/pm8001/pm8001_init.c:677:6: warning: no previous prototype for ‘pm8001_get_phy_settings_info’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/pm8001/pm8001_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 73a120d..a82528c 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -674,7 +674,7 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
  * pm8001_get_phy_settings_info : Read phy setting values.
  * @pm8001_ha : our hba.
  */
-void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
+static void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
 {
 
 #ifdef PM8001_READ_VPD
-- 
1.7.9.5

