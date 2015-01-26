Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbbAZQZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:25:49 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51280 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbbAZQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:23:16 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] coresight: remove the extra spaces
Date: Mon, 26 Jan 2015 09:22:20 -0700
Message-Id: <1422289345-2084-5-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
References: <1422289345-2084-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kaixu Xia <xiakaixu@huawei.com>

There are some extra spaces, so just remove them from these lines.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/coresight-etb10.c | 2 +-
 drivers/coresight/coresight.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/coresight/coresight-etb10.c b/drivers/coresight/coresight-etb10.c
index a1da7020201b..c9acd406f0d0 100644
--- a/drivers/coresight/coresight-etb10.c
+++ b/drivers/coresight/coresight-etb10.c
@@ -454,7 +454,7 @@ static int etb_probe(struct amba_device *adev, const struct amba_id *id)
 	if (ret)
 		return ret;
 
-	drvdata->buffer_depth =  etb_get_buffer_depth(drvdata);
+	drvdata->buffer_depth = etb_get_buffer_depth(drvdata);
 	clk_disable_unprepare(drvdata->clk);
 
 	if (drvdata->buffer_depth < 0)
diff --git a/drivers/coresight/coresight.c b/drivers/coresight/coresight.c
index d6052e2cd6a7..c5def9382357 100644
--- a/drivers/coresight/coresight.c
+++ b/drivers/coresight/coresight.c
@@ -498,7 +498,7 @@ static int coresight_orphan_match(struct device *dev, void *data)
 	 * Circle throuch all the connection of that component.  If we find
 	 * an orphan connection whose name matches @csdev, link it.
 	 */
-	for (i = 0; i < i_csdev->nr_outport; i++)	{
+	for (i = 0; i < i_csdev->nr_outport; i++) {
 		conn = &i_csdev->conns[i];
 
 		/* We have found at least one orphan connection */
-- 
1.9.1

