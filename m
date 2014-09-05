Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaIELtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:49:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24210 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbaIELtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:49:01 -0400
X-AuditID: cbfee68d-f79c46d000000b84-8a-5409a32b7ac7
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v3 3/4] mfd: max77693: add haptic of_compatible in mfd_cell
Date: Fri, 05 Sep 2014 20:48:21 +0900
Message-id: <1409917702-17009-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkQFdnMWeIwfkUi+tfnrNaHF70gtFi
	R8MRVov7X48yWtz89I3V4vKuOWwWp7tZHdg9ds66y+5x59oeNo95JwM9+rasYvT4vEkugDWK
	yyYlNSezLLVI3y6BK6Pr/HqWggNsFX8eRTUwrmTtYuTkkBAwkXh1cS8jhC0mceHeerYuRi4O
	IYGljBJ7JnYzdzFygBX1tsZCxKczSlxbuIkJwmljklh8YBcbSDebgLbE9/WLwaaKCFRK9He/
	YAUpYhboYZT43r6aGSQhLOAtsafxP5jNIqAqsfzhKrDVvAIeEs9uzYfapiAxZ5INSJhTwFNi
	1+FHbCBhIZCSexIgIyUEJrNLTO/oZIcYIyDxbfIhFohWWYlNB5ghnpGUOLjiBssERuEFjAyr
	GEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MQKD+/S/Z707GG8fsD7EKMDBqMTDu+AzR4gQa2JZ
	cWXuIUZToA0TmaVEk/OBMZRXEm9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVAPjYd2ttUc/7dYwmDEv4GLZPmPh74H5idccPG4UztJjmp72RFV23oNzshx3
	bXtPKWXn7zMOei5bZynNPunM6vWi8bantx2N16hnKzx2lXmt7Aq9vmrLv6JFLx9pH90g/EJi
	8SmP4yKf/r44uXjJm/W7zsjH6v1YIGfHk7w96QZzv8Q1yQ3zNV8WKrEUZyQaajEXFScCAByn
	LKBpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV3txZwhBk2vzCyuf3nOanF40QtG
	ix0NR1gt7n89ymhx89M3VovLu+awWZzuZnVg99g56y67x51re9g85p0M9OjbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGV3n17MUHGCr+PMI6KCVrF2M
	HBwSAiYSva2xXYycQKaYxIV769m6GLk4hASmM0pcW7iJCcJpY5JYfGAXG0gVm4C2xPf1i1lB
	bBGBSon+7hesIEXMAj2MEt/bVzODJIQFvCX2NP4Hs1kEVCWWP1zFCGLzCnhIPLs1nxlis4LE
	nEk2IGFOAU+JXYcfsYGEhUBK7klMYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	ep5J7WBc2WBxiFGAg1GJh3fBZ44QIdbEsuLK3EOMEhzMSiK87lM4Q4R4UxIrq1KL8uOLSnNS
	iw8xmgLdNJFZSjQ5HxjZeSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg+pg4
	OKUaGCdOMPK45WWUociRwRnatE7l+87DJrer33+8O9nx0JRIm9c3rjt5HvZ64ua0tv/Gnbe2
	sZdPe7r+Z3EvPRe5cLGwl4H9pHM/FKSONv29yOPgkOolsmumN7/cm1WOmZtD+ANsn+/yd+Wc
	Oqdkt3fQgjCV+/lBcerSQbMN4soXVR/qU6v52Z1zWYmlOCPRUIu5qDgRAOAE8Jy0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add haptic of_compatible in order to use the haptic
device driver using Devicetree.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/mfd/max77693.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index fbfed56..03fd431 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -46,7 +46,10 @@ static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
 	{ .name = "max77693-muic", },
-	{ .name = "max77693-haptic", },
+	{
+	  .name = "max77693-haptic",
+	  .of_compatible = "maxim,max77693-haptic",
+	},
 };
 
 static const struct regmap_config max77693_regmap_config = {
-- 
1.7.9.5

