Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaANMDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:03:01 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51890 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaANMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:03:00 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: m.chehab@samsung.com, gregkh@linuxfoundation.org,
        monamagarwal123@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: media: Fix line length exceeding 80 characters in as102_fe.c
Date: Tue, 14 Jan 2014 17:32:42 +0530
Message-Id: <1389700962-7666-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the following checkpatch.pl issues in
as102/as102_fe.c
WARNING: line over 80 characters 

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/media/as102/as102_fe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index dc367d1..bd5cd92 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -263,7 +263,8 @@ static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)

 	if (acquire) {
 		if (elna_enable)
-			as10x_cmd_set_context(&dev->bus_adap, CONTEXT_LNA, dev->elna_cfg);
+			as10x_cmd_set_context(&dev->bus_adap,
+					      CONTEXT_LNA, dev->elna_cfg);

 		ret = as10x_cmd_turn_on(&dev->bus_adap);
 	} else {
-- 
1.7.9.5

