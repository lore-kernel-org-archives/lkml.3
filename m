Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbbATRx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:53:29 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50030 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbATRx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:53:28 -0500
Date: Tue, 20 Jan 2015 19:52:59 -0900
From: Ahmad Hassan <ahmad.hassan612@gmail.com>
To: devel@driverdev.osuosl.org
Cc: mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        boris.brezillon@free-electrons.com, ahmad.hassan612@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: fix davinci_vpfe: fix space prohibted before that
 ','
Message-ID: <20150121045258.GA19087@Arch-Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
fix space prohibited before that ',' at line 904
Signed-off-by: Ahmad Hassan <ahmad.hassan612@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 704fa20..b5ad7af 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -901,7 +901,7 @@ static int ipipe_set_gbce_params(struct vpfe_ipipe_device *ipipe, void *param)
 	struct device *dev = ipipe->subdev.v4l2_dev->dev;
 
 	if (!gbce_param) {
-		memset(gbce, 0 , sizeof(struct vpfe_ipipe_gbce));
+		memset(gbce, 0, sizeof(struct vpfe_ipipe_gbce));
 	} else {
 		memcpy(gbce, gbce_param, sizeof(struct vpfe_ipipe_gbce));
 		if (ipipe_validate_gbce_params(gbce) < 0) {
-- 
2.2.1

