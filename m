Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3J2SLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:11:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3J2SKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:10:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@fedoraproject.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 29/81] tcp: Add missing braces to do_tcp_setsockopt
Date: Tue, 29 Oct 2013 11:03:50 -0700
Message-Id: <1383069882-11437-30-git-send-email-kamal@canonical.com>
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

[ Upstream commit e2e5c4c07caf810d7849658dca42f598b3938e21 ]

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2c108f7..8e79542 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2540,10 +2540,11 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 	case TCP_THIN_DUPACK:
 		if (val < 0 || val > 1)
 			err = -EINVAL;
-		else
+		else {
 			tp->thin_dupack = val;
 			if (tp->thin_dupack)
 				tcp_disable_early_retrans(tp);
+		}
 		break;
 
 	case TCP_REPAIR:
-- 
1.8.1.2

