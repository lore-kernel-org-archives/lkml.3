Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3HWLfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:35:36 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63919 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3HWLfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:35:33 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org,
        linus.walleij@linaro.org
Subject: [PATCH 1/2] mfd: db8500-prcmu: Use ANSI function declaration
Date: Fri, 23 Aug 2013 17:05:19 +0530
Message-Id: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silences the following warning:
drivers/mfd/db8500-prcmu.c:2322:25: warning:
non-ANSI function declaration of function 'prcmu_ac_sleep_req'

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 0d68eb1..8685872 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2319,7 +2319,7 @@ unlock_and_return:
 /**
  * prcmu_ac_sleep_req - called when ARM no longer needs to talk to modem
  */
-void prcmu_ac_sleep_req()
+void prcmu_ac_sleep_req(void)
 {
 	u32 val;
 
-- 
1.7.4.1

