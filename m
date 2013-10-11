Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3JKTjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:39:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab3JKTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:39:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@fedoraproject.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 006/110] caif: Add missing braces to multiline if in cfctrl_linkup_request
Date: Fri, 11 Oct 2013 12:37:46 -0700
Message-Id: <20131011193808.307065833@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit 0c1db731bfcf3a9fd6c58132134f8b0f423552f0 ]

The indentation here implies this was meant to be a multi-line if.

Introduced several years back in commit c85c2951d4da1236e32f1858db418221e624aba5
("caif: Handle dev_queue_xmit errors.")

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/caif/cfctrl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -293,9 +293,10 @@ int cfctrl_linkup_request(struct cflayer
 
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


