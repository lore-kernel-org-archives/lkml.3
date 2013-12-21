Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3LUCOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:14:20 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:50162 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3LUCOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:14:15 -0500
MIME-Version: 1.0
Date: Sat, 21 Dec 2013 10:14:13 +0800
Message-ID: <CAPgLHd-UWsAD8_-o603e1MvXbUvMxacUGYjxuduV-D7LYHOQxA@mail.gmail.com>
Subject: [PATCH -next] mfd: twl6040: fix sparse non static symbol warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org, peter.ujfalusi@ti.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/mfd/twl6040.c:89:20: warning:
 symbol 'twl6040_patch' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/twl6040.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 51b6df1..75316fb 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -86,7 +86,7 @@ static struct reg_default twl6040_defaults[] = {
 	{ 0x2E, 0x00 }, /* REG_STATUS	(ro) */
 };
 
-struct reg_default twl6040_patch[] = {
+static struct reg_default twl6040_patch[] = {
 	/* Select I2C bus access to dual access registers */
 	{ TWL6040_REG_ACCCTL, 0x09 },
 };

