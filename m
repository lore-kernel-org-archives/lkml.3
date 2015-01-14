Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbbANVnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:43:05 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46605 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbbANVnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:43:03 -0500
Date: Wed, 14 Jan 2015 23:46:49 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: devel@driverdev.osuosl.org
Cc: mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        boris.brezillon@free-electrons.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: davinci_vpfe: fix space prohibited before semicolon
 warning
Message-ID: <20150114214649.GA20302@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:

space prohibited before semicolon

Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
---
v1: This patch applies to Greg's tree.

 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 704fa20..a425f71 100644
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
@@ -1086,7 +1086,7 @@ static int ipipe_set_car_params(struct vpfe_ipipe_device *ipipe, void *param)
 	struct vpfe_ipipe_car *car = &ipipe->config.car;
 
 	if (!car_param) {
-		memset(car , 0, sizeof(struct vpfe_ipipe_car));
+		memset(car, 0, sizeof(struct vpfe_ipipe_car));
 	} else {
 		memcpy(car, car_param, sizeof(struct vpfe_ipipe_car));
 		if (ipipe_validate_car_params(car) < 0) {
-- 
1.9.3

