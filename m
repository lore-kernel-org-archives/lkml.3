Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3C1QMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:19 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:44961 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3C1QMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: [PATCH 12/33] regulator: ab8500: Correct TVOUT regulator enable time
Date: Thu, 28 Mar 2013 16:11:12 +0000
Message-Id: <1364487093-19551-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update TVOUT regulator to match specification.

Was 10ms - changed to 500us.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
---
 drivers/regulator/ab8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index d98014c..e1d38ac 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -479,7 +479,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 2000000,
-			.enable_time	= 10000,
+			.enable_time	= 500,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
-- 
1.7.10.4

