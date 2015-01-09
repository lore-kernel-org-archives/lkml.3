Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbbAIX6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:58:47 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46119 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbbAIX5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:46 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 10/11] coresight: fix comment in of_coresight.c
Date: Fri,  9 Jan 2015 16:57:21 -0700
Message-Id: <1420847842-31769-11-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kaixu Xia <xiakaixu@huawei.com>

Outports is a member of the struct pdata and should be
a better choice.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/of_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index 8bd524e49518..89ebbe29ac97 100644
--- a/drivers/coresight/of_coresight.c
+++ b/drivers/coresight/of_coresight.c
@@ -93,7 +93,7 @@ static int of_coresight_alloc_memory(struct device *dev,
 	if (!pdata->outports)
 		return -ENOMEM;
 
-	/* Children connected to this component via @outport */
+	/* Children connected to this component via @outports */
 	 pdata->child_names = devm_kzalloc(dev, pdata->nr_outport *
 					  sizeof(*pdata->child_names),
 					  GFP_KERNEL);
-- 
1.9.1

