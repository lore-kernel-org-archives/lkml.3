Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3A2JtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:49:15 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:60512 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3A2JtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:49:09 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com, sachin.kamat@linaro.org,
        dg77.kim@samsung.com
Subject: [PATCH 2/3] extcon: max8997: Remove unreachable code
Date: Tue, 29 Jan 2013 15:10:01 +0530
Message-Id: <1359452402-15885-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359452402-15885-1-git-send-email-sachin.kamat@linaro.org>
References: <1359452402-15885-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'break' after 'return' is never executed and hence can be deleted.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max8997.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 7039541..d16090d 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -289,7 +289,6 @@ static int max8997_muic_handle_charger_type_detach(
 		break;
 	default:
 		return -EINVAL;
-		break;
 	}
 
 	return 0;
-- 
1.7.4.1

