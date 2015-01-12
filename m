Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbbALQxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:53:42 -0500
Received: from mail9.tpgi.com.au ([203.12.160.104]:38842 "EHLO
	mail9.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbbALQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:53:40 -0500
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=14-201-201-57.static.tpgi.com.au; ip=14.201.201.57; date=Tue, 13 Jan 2015 03:53:19 +1100; auth=qn3nQWOo9XiOgLX3+3LzYIb4Pj8GBfUecjOflfKdwAc=
From: Emrys Bayliss <emrys@paradise.net.nz>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Emrys Bayliss <emrys@paradise.net.nz>
Subject: [PATCH v2] Staging: vt6656: Checkpatch fix: else after break or return
Date: Tue, 13 Jan 2015 03:51:36 +1100
Message-Id: <1421081496-15772-1-git-send-email-emrys@paradise.net.nz>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl error:
rxtx.c:588: WARNING: else is not generally useful after a break or return

Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
---
 drivers/staging/vt6656/rxtx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ea5140a..0cce140 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -574,8 +574,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 
 		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
 	}
-
-	return 0;
 }
 
 static u16 vnt_rxtx_rts(struct vnt_usb_send_context *tx_context,
-- 
2.2.1

