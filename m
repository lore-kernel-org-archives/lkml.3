Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaHMFpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:45:34 -0400
Received: from thoros.lunarpages.com ([67.210.120.70]:41679 "EHLO
	thoros.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaHMFpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:45:33 -0400
From: "Ragnar B. Johannsson" <ragnar@igo.is>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ragnar B. Johannsson" <ragnar@igo.is>
Subject: [PATCH 2/3] staging: vt6656: fix incorrect indentation
Date: Sun, 10 Aug 2014 22:23:49 +0000
Message-Id: <1407709430-61260-3-git-send-email-ragnar@igo.is>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407709430-61260-1-git-send-email-ragnar@igo.is>
References: <1407709430-61260-1-git-send-email-ragnar@igo.is>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thoros.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [0 0]
X-AntiAbuse: Sender Address Domain - igo.is
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tabs, not spaces.

Signed-off-by: Ragnar B. Johannsson <ragnar@igo.is>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 2d1ef88..08ce18d 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -573,7 +573,7 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
 		memcpy(buf->data.ra, priv->current_net_addr, ETH_ALEN);
 
 		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
-        }
+	}
 
 	return 0;
 }
-- 
1.9.3

