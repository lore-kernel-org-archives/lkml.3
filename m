Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3IBL2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:28:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33376 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab3IBL2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:28:13 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, sachin.kamat@linaro.org
Subject: [PATCH 2/4] ab8500-charger: Remove redundant break
Date: Mon,  2 Sep 2013 16:40:23 +0530
Message-Id: <1378120226-24805-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
References: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each of the if-else blocks has a break statement.
Remove the additional one which is unreachable.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/ab8500_charger.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index fec0546..608b63e 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -766,7 +766,6 @@ static int ab8500_charger_max_usb_curr(struct ab8500_charger *di,
 			ret = -ENXIO;
 			break;
 		}
-		break;
 	case USB_STAT_CARKIT_1:
 	case USB_STAT_CARKIT_2:
 	case USB_STAT_ACA_DOCK_CHARGER:
-- 
1.7.9.5

