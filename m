Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbbAKNAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:00:36 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:59576 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbAKNAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:00:33 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: xfrm: xfrm_algo: Remove unused function
Date: Sun, 11 Jan 2015 14:03:35 +0100
Message-Id: <1420981415-16343-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function aead_entries() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 net/xfrm/xfrm_algo.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index debe733..12e82a5 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -561,11 +561,6 @@ static struct xfrm_algo_desc calg_list[] = {
 },
 };
 
-static inline int aead_entries(void)
-{
-	return ARRAY_SIZE(aead_list);
-}
-
 static inline int aalg_entries(void)
 {
 	return ARRAY_SIZE(aalg_list);
-- 
1.7.10.4

