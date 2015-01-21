Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbbAUPG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:06:29 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37868 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbAUPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:06:20 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-fa-54bfbfd86a89
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org,
        Support Opensource <support.opensource@diasemi.com>,
        Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] backlight: da9052_bl: terminate da9052_wled_ids array with
 empty element
Date: Wed, 21 Jan 2015 18:06:08 +0300
Message-id: <1421852768-29622-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xq7o39u8PMfi+ldVi269HbBaXF15i
	tbj/9SijxYm+D6wWl3fNYbNY9/AFk8Xe1ovMFuvn32Jz4PBY8Unf49WFOywed67tYfPo27KK
	0eP4je1MHp83yQWwRXHZpKTmZJalFunbJXBlrOy+zVwwnbVi8/fpjA2Ma1m6GDk5JARMJLbd
	38EIYYtJXLi3nq2LkYtDSGApo8TBppfMEE4fk8TfCQvZQarYBPQk/s3azgZiiwgcYJK4tCgZ
	xGYW0JHYeK2VCcQWFoiW6Dy6CMxmEVCVuL37HFg9r4CbxL2TN6A2y0lsvLOCdQIj9wJGhlWM
	oqmlyQXFSem5hnrFibnFpXnpesn5uZsYIYHzZQfj4mNWhxgFOBiVeHgrQveHCLEmlhVX5h5i
	lOBgVhLhXQUMOyHelMTKqtSi/Pii0pzU4kOMTBycUg2MTjofMlfLibaxz1+2c3Ei49N07sL3
	kTom3z8GPqy+yRVQ8epu2/3w/J937H5mvlM86WN8IG5xg/zfxG3ibKGyPofnqr5lUJi40JyF
	ZdaURZHiKyuXiy4+Km65hPfRJcPwjsq00/z3Pd2qlIsTVr2WYexsb5/zTX6i7nQ2q2V/9z0L
	/O/1hfOaEktxRqKhFnNRcSIAkqVB7foBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of platform_device_id elements should be terminated
with empty element.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 drivers/video/backlight/da9052_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
index d4bd74bd..b1943e7 100644
--- a/drivers/video/backlight/da9052_bl.c
+++ b/drivers/video/backlight/da9052_bl.c
@@ -165,6 +165,7 @@ static struct platform_device_id da9052_wled_ids[] = {
 		.name		= "da9052-wled3",
 		.driver_data	= DA9052_TYPE_WLED3,
 	},
+	{ },
 };
 
 static struct platform_driver da9052_wled_driver = {
-- 
2.2.1

