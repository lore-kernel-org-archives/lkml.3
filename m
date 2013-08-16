Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3HQAZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:25:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51487 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3HPWh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:37:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 131/133] ndisc: Add missing inline to ndisc_addr_option_pad
Date: Fri, 16 Aug 2013 15:34:33 -0700
Message-Id: <1376692475-28413-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Perches <joe@perches.com>

[ Upstream commit d9d10a30964504af834d8d250a0c76d4ae91eb1e ]

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/ndisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 23b3a7c..c9db93d 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -119,7 +119,7 @@ extern struct ndisc_options *ndisc_parse_options(u8 *opt, int opt_len,
  * if RFC 3831 IPv6-over-Fibre Channel is ever implemented it may
  * also need a pad of 2.
  */
-static int ndisc_addr_option_pad(unsigned short type)
+static inline int ndisc_addr_option_pad(unsigned short type)
 {
 	switch (type) {
 	case ARPHRD_INFINIBAND: return 2;
-- 
1.8.1.2

