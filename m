Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3LUF4C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 00:56:02 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43830 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3LUFzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 00:55:41 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 2/2] mfd: rtl8411: Staticize local symbol
Date: Sat, 21 Dec 2013 11:22:22 +0530
Message-Id: <1387605142-4743-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387605142-4743-1-git-send-email-sachin.kamat@linaro.org>
References: <1387605142-4743-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'rtl8411_init_common_params' is local to this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/rtl8411.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index ada38ad54e87..fdd34c883d86 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -470,7 +470,7 @@ static const u32 rtl8411b_qfn48_ms_pull_ctl_disable_tbl[] = {
 	0,
 };
 
-void rtl8411_init_common_params(struct rtsx_pcr *pcr)
+static void rtl8411_init_common_params(struct rtsx_pcr *pcr)
 {
 	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
 	pcr->num_slots = 2;
-- 
1.7.9.5

