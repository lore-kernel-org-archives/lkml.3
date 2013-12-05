Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3LEWaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:30:39 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36838 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab3LEW3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:29:10 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [net-next PATCH 3/6] macvtap: remove the dead branch
Date: Fri,  6 Dec 2013 06:28:44 +0800
Message-Id: <1386282527-14094-4-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com>
References: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120522-7182-0000-0000-00000947B41F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 9093004..d271fb4 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -779,8 +779,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 			return -EINVAL;
 
 		ret = macvtap_skb_to_vnet_hdr(skb, &vnet_hdr);
-		if (ret)
-			return ret;
 
 		if (memcpy_toiovecend(iv, (void *)&vnet_hdr, 0, sizeof(vnet_hdr)))
 			return -EFAULT;
-- 
1.7.6.5

