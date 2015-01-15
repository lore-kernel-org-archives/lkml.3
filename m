Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbbAOIDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:03:16 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:58107 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbAOIDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:03:15 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xiakaixu@huawei.com>, <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: remove the extra spaces
Date: Thu, 15 Jan 2015 15:54:19 +0800
Message-ID: <1421308459-71865-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54B77376.00A0,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 4cc43ea8860581ae0ad29446f0523032
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some extra spaces, so just remove them from these lines.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 drivers/coresight/coresight-etb10.c | 2 +-
 drivers/coresight/coresight.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/coresight/coresight-etb10.c b/drivers/coresight/coresight-etb10.c
index c922d4a..d0529b5 100644
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
index 11968b7..0de0c39 100644
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
1.8.5.5

