Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbbAEMLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:11:05 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:64613 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbbAEMLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:11:03 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <pratikp@codeaurora.org>, <xiakaixu@huawei.com>,
        <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: fix comment in of_coresight.c
Date: Mon, 5 Jan 2015 20:05:38 +0800
Message-ID: <1420459538-20936-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Outports is a member of the struct pdata and should be
a better choice.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 drivers/coresight/of_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index 8bd524e..89ebbe2 100644
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
1.8.5.5

