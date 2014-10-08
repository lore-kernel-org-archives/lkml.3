Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaJHB5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:57:49 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46339 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaJHB5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:57:48 -0400
Message-ID: <1412733463.8255.1.camel@phoenix>
Subject: [PATCH] regulator: sky81452: Remove module version
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Gyungoh Yoo <gyungoh@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 08 Oct 2014 09:57:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module version is unlikely to be updated, use kernel version should be
enough.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Gyungoh,
Seems you have added MODULE_VERSION for the sky81452 serial patches.
Do you really need that and will keep updating it?
Otherwise, you may want to drop the MODULE_VERSION in sky81452 serial patches.

 drivers/regulator/sky81452-regulator.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
index 97aff0c..476b80a 100644
--- a/drivers/regulator/sky81452-regulator.c
+++ b/drivers/regulator/sky81452-regulator.c
@@ -127,4 +127,3 @@ module_platform_driver(sky81452_reg_driver);
 MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
 MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0");
-- 
1.9.1



