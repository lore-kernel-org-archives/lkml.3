Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaANMBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:01:32 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46379 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaANMBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:01:30 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: m.chehab@samsung.com, gregkh@linuxfoundation.org,
        monamagarwal123@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: media: Fix quoted string split across line in as102_fe.c
Date: Tue, 14 Jan 2014 17:31:14 +0530
Message-Id: <1389700875-7582-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl issues in
as102/as102_fe.c
WARNING: quoted string split across lines 

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/media/as102/as102_fe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 9ce8c9d..dc367d1 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -151,8 +151,8 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
 			(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
 			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-			dprintk(debug, "as10x_cmd_get_demod_stats failed "
-				"(probably not tuned)\n");
+			dprintk(debug,
+				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
 		} else {
 			dprintk(debug,
 				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
@@ -581,8 +581,8 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 			   as102_fe_get_code_rate(params->code_rate_LP);
 		}

-		dprintk(debug, "\thierarchy: 0x%02x  "
-				"selected: %s  code_rate_%s: 0x%02x\n",
+		dprintk(debug,
+			"\thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
 			tune_args->hierarchy,
 			tune_args->hier_select == HIER_HIGH_PRIORITY ?
 			"HP" : "LP",
-- 
1.7.9.5

