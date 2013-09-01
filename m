Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3IAWsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:48:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33758 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757512Ab3IAWs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:48:29 -0400
Message-ID: <1378075707.1953.29.camel@joe-AO722>
Subject: [PATCH net-hext] wireless: scan: Remove comment to
 compare_ether_addr
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 01 Sep 2013 15:48:27 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is being removed, so remove the reference to it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/wireless/scan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ad1e406..eeb7148 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -465,10 +465,6 @@ static int cmp_bss(struct cfg80211_bss *a,
 		}
 	}
 
-	/*
-	 * we can't use compare_ether_addr here since we need a < > operator.
-	 * The binary return value of compare_ether_addr isn't enough
-	 */
 	r = memcmp(a->bssid, b->bssid, sizeof(a->bssid));
 	if (r)
 		return r;


