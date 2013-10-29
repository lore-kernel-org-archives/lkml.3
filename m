Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3J2SM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:12:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3J2SKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:10:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@fedoraproject.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 28/81] caif: Add missing braces to multiline if in cfctrl_linkup_request
Date: Tue, 29 Oct 2013 11:03:49 -0700
Message-Id: <1383069882-11437-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit 0c1db731bfcf3a9fd6c58132134f8b0f423552f0 ]

The indentation here implies this was meant to be a multi-line if.

Introduced several years back in commit c85c2951d4da1236e32f1858db418221e624aba5
("caif: Handle dev_queue_xmit errors.")

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/caif/cfctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index a376ec1..82a2972 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -293,9 +293,10 @@ int cfctrl_linkup_request(struct cflayer *layer,
 
 		count = cfctrl_cancel_req(&cfctrl->serv.layer,
 						user_layer);
-		if (count != 1)
+		if (count != 1) {
 			pr_err("Could not remove request (%d)", count);
 			return -ENODEV;
+		}
 	}
 	return 0;
 }
-- 
1.8.1.2

