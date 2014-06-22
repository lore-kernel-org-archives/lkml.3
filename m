Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaFVK7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:59:05 -0400
Received: from mail.grouk.net ([92.222.18.81]:34425 "EHLO grouk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbaFVK7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:59:03 -0400
From: Thomas Vegas <thomas@grouk.net>
To: gregkh@linuxfoundation.org
Cc: Thomas Vegas <thomas@grouk.net>, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2014 13:01:51 +0200
Message-Id: <1403434912-21655-2-git-send-email-thomas@grouk.net>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403434912-21655-1-git-send-email-thomas@grouk.net>
References: <1403434912-21655-1-git-send-email-thomas@grouk.net>
X-SA-Exim-Connect-IP: 86.217.122.199
X-SA-Exim-Mail-From: thomas@grouk.net
Subject: [PATCH 2/3] staging: rtl8188eu: core: Remove unnecessary parentheses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on grouk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unnecessary parentheses around structure member.

Signed-off-by: Thomas Vegas <thomas@grouk.net>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index bb290a3..4b93add 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1233,7 +1233,7 @@ struct xmit_buf *rtw_alloc_xmitbuf_ext(struct xmit_priv *pxmitpriv)
 
 		pxmitbuf = container_of(plist, struct xmit_buf, list);
 
-		rtw_list_delete(&(pxmitbuf->list));
+		rtw_list_delete(&pxmitbuf->list);
 		pxmitpriv->free_xmit_extbuf_cnt--;
 
 		pxmitbuf->priv_data = NULL;
-- 
1.8.5.5

