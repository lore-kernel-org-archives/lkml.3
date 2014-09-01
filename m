Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaIACHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:07:12 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.119]:14071 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbaIACHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:07:09 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-3.tower-193.messagelabs.com!1409537226!13300097!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201409010206.s8126pMN007815@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Mon, 1 Sep 2014 11:03:24 +0900
Subject: [PATCH V1] regulator: DA9211 : remove an unneeded semicolon
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for removing an unneeded semicolon.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140829.

 drivers/regulator/da9211-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index 5aabbac..9722728 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -278,7 +278,7 @@ static struct da9211_pdata *da9211_parse_regulators_dt(
 		pdata->init_data[n] = da9211_matches[i].init_data;
 
 		n++;
-	};
+	}
 
 	return pdata;
 }
-- 
end-of-patch for regulator: DA9211 : remove an unneeded semicolon V1

