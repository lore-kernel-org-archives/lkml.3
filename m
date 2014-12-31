Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaLaHr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 02:47:28 -0500
Received: from [119.145.14.65] ([119.145.14.65]:37173 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaLaHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 02:47:27 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <pratikp@codeaurora.org>,
        <xiakaixu@huawei.com>, <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: fix typo in comment in of_coresight.c
Date: Wed, 31 Dec 2014 15:40:29 +0800
Message-ID: <1420011629-77676-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debugfs isn't used for coresight configuration, so the corresponding 
comments should be changed.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 drivers/coresight/of_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index 5030c07..8bd524e 100644
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
1.8.5.5

