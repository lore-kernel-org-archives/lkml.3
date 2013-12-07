Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3LGGCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 01:02:18 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:44429 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3LGGCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 01:02:17 -0500
MIME-Version: 1.0
Date: Sat, 7 Dec 2013 14:02:15 +0800
Message-ID: <CAPgLHd_=CTR36ye=YvRW81kpzb12Q-pNzbd8Ja-46DXbGD2_Uw@mail.gmail.com>
Subject: [PATCH -next] mfd: sec: fix sparse NULL pointer warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        grant.likely@linaro.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/mfd/sec-core.c:202:16: warning: Using plain integer as NULL pointer

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/sec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 3a20b47..87fa1e6 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -199,7 +199,7 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
 static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
 					struct device *dev)
 {
-	return 0;
+	return NULL;
 }
 #endif
 

