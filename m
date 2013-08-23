Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3HWKLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:11:20 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58627 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3HWKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:11:18 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org
Subject: [PATCH 1/3] mfd: timberdale: Staticize local variables
Date: Fri, 23 Aug 2013 15:41:03 +0530
Message-Id: <1377252665-7152-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variables referenced only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/timberdale.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 0c1fcbc..4c9c149 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -115,11 +115,11 @@ static const struct resource timberdale_ocores_resources[] = {
 	},
 };
 
-const struct max7301_platform_data timberdale_max7301_platform_data = {
+static const struct max7301_platform_data timberdale_max7301_platform_data = {
 	.base = 200
 };
 
-const struct mc33880_platform_data timberdale_mc33880_platform_data = {
+static const struct mc33880_platform_data timberdale_mc33880_platform_data = {
 	.base = 100
 };
 
-- 
1.7.4.1

