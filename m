Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161045Ab3BNW22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:28:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030274Ab3BNW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 9/9] thermal: rcar: remove __devinitconst
Date: Thu, 14 Feb 2013 23:26:58 +0100
Message-Id: <1360880818-4071454-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:VrGd5uMFG8tGXFNE4u/H/NFQ0pPGpZxqGuuIHduurak
 W1ZlJfCezMgY7RzfWSxcS3GnYr3YplCPwueIGbTKYDFA18FYML
 DWjcKdxG6tQ+7WMD6qb3QLRBweKCl4vkLmLGO/RusXxNmAT5tS
 20R3nbBsGSZjGkFFUbIhN1ng6/LVe4dVlx18J25Ymc1l0832rV
 Bh8LTvdgXWmVdelz2c3/Cie3EBakCo0mogQZYajPFEamTae6FD
 p97dN5RKlFoFLz2+NhhsMyAsDRtZBGttytDEP6Ve+iGItUqp5M
 pjAXzT1NljM5PG5QUUJrb9KjB3cwuh2aPQqjRbiCRpy38/x7Bt
 1pj4nUj0Ne79rBAnCnk3oOiTTAMiHHDjohNjkMtt5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 76cc18874 "thermal: rcar: add Device Tree support"
added device tree support for this driver, but also added
an instance of __devinitconst, which is no longer defined

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/rcar_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
index 909bb4b..28f0919 100644
--- a/drivers/thermal/rcar_thermal.c
+++ b/drivers/thermal/rcar_thermal.c
@@ -476,7 +476,7 @@ static int rcar_thermal_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id rcar_thermal_dt_ids[] __devinitconst = {
+static const struct of_device_id rcar_thermal_dt_ids[] = {
 	{ .compatible = "renesas,rcar-thermal", },
 	{},
 };
-- 
1.8.1.2

