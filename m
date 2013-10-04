Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3JDJsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:48:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46430 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3JDJsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:48:46 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, patches@opensource.wolfsonmicro.com,
        sachin.kamat@linaro.org
Subject: [PATCH 1/2] regulator: wm8994: Remove redundant break
Date: Fri,  4 Oct 2013 15:18:17 +0530
Message-Id: <1380880098-25188-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'break' after return has no effect. Remove it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/wm8994-regulator.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 71c5911..ffc1b2f 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -63,7 +63,6 @@ static int wm8994_ldo2_list_voltage(struct regulator_dev *rdev,
 		default:
 			return (selector * 100000) + 950000;
 		}
-		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.7.9.5

