Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaDRUYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:24:12 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60385 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaDRUYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:24:01 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad M Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 2/2] staging: rtl8188eu: fix spaces instead of tabs for rtw_recv.c
Date: Fri, 18 Apr 2014 22:23:07 +0200
Message-Id: <1397852587-8170-3-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397852587-8170-2-git-send-email-bergo.torino@gmail.com>
References: <1397852587-8170-1-git-send-email-bergo.torino@gmail.com>
 <1397852587-8170-2-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad M Zapalowicz <bergo.torino@gmail.com>

This commit fixes the following checkpatch errors:

rtl8188eu/core/rtw_recv.c
    - 1874: ERROR: code indent should use tabs where possible

Signed-off-by: Konrad Zapalowicz <bergo.torino at gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index e305d43..5c1d2d2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -1871,7 +1871,7 @@ static int recv_indicatepkts_in_order(struct adapter *padapter, struct recv_reor
 			return true;
 
 		prhdr = container_of(plist, struct recv_frame, list);
-	        pattrib = &prhdr->attrib;
+		pattrib = &prhdr->attrib;
 		preorder_ctrl->indicate_seq = pattrib->seq_num;
 	}
 
-- 
1.8.1.2

