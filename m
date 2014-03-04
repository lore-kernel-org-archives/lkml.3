Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaCDJrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:47:52 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59734 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbaCDJrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:47:49 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, pawell.moll@arm.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] mfd: vexpress: Staticize vexpress_config_bridges
Date: Tue,  4 Mar 2014 15:11:47 +0530
Message-Id: <1393926107-9290-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vexpress_config_bridges is local to this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/mfd/vexpress-config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index 84ce6b9daa3d..0876de04ed4d 100644
--- a/drivers/mfd/vexpress-config.c
+++ b/drivers/mfd/vexpress-config.c
@@ -27,7 +27,7 @@
 
 #define VEXPRESS_CONFIG_MAX_BRIDGES 2
 
-struct vexpress_config_bridge {
+static struct vexpress_config_bridge {
 	struct device_node *node;
 	struct vexpress_config_bridge_info *info;
 	struct list_head transactions;
-- 
1.7.9.5

