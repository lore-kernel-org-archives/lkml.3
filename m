Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbbAIX7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:59:46 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46272 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbbAIX5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:44 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 08/11] coresight: fix typo in comment in of_coresight.c
Date: Fri,  9 Jan 2015 16:57:19 -0700
Message-Id: <1420847842-31769-9-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kaixu Xia <xiakaixu@huawei.com>

Debugfs isn't used for coresight configuration, so the corresponding
comments should be changed.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/of_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index 5030c0734508..8bd524e49518 100644
--- a/drivers/coresight/of_coresight.c
+++ b/drivers/coresight/of_coresight.c
@@ -126,7 +126,7 @@ struct coresight_platform_data *of_get_coresight_platform_data(
 	if (!pdata)
 		return ERR_PTR(-ENOMEM);
 
-	/* Use device name as debugfs handle */
+	/* Use device name as sysfs handle */
 	pdata->name = dev_name(dev);
 
 	/* Get the number of input and output port for this component */
-- 
1.9.1

