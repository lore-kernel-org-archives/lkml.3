Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaC2E40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 00:56:26 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:59436 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaC2E4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:56:25 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: media: davinci_vpfe: fix checkpatch warning
Date: Sat, 29 Mar 2014 10:26:13 +0530
Message-Id: <1396068973-7968-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch fixes following checkpatch warning,
media/davinci_vpfe/dm365_ipipe.c:1271: WARNING: Missing a blank line after declarations
media/davinci_vpfe/dm365_ipipe.c:1313: WARNING: Missing a blank line after declarations

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index b7044a3..bdc7f00 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1268,6 +1268,7 @@ static int ipipe_s_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 
 	for (i = 0; i < ARRAY_SIZE(ipipe_modules); i++) {
 		unsigned int bit = 1 << i;
+
 		if (cfg->flag & bit) {
 			const struct ipipe_module_if *module_if =
 						&ipipe_modules[i];
@@ -1310,6 +1311,7 @@ static int ipipe_g_config(struct v4l2_subdev *sd, struct vpfe_ipipe_config *cfg)
 
 	for (i = 1; i < ARRAY_SIZE(ipipe_modules); i++) {
 		unsigned int bit = 1 << i;
+
 		if (cfg->flag & bit) {
 			const struct ipipe_module_if *module_if =
 						&ipipe_modules[i];
-- 
1.7.9.5

