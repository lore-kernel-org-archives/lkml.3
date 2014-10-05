Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaJEKck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 06:32:40 -0400
Received: from rgout0303.bt.lon5.cpcloud.co.uk ([65.20.0.209]:6552 "EHLO
	rgout0303.bt.lon5.cpcloud.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbaJEKcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 06:32:39 -0400
X-CTCH-RefID: str=0001.0A090201.54311E3B.002A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-Junkmail-Premium-Raw: score=28/50,refid=2.7.2:2014.10.3.130921:17:28.905,ip=86.133.111.215,rules=__HAS_FROM,
 __PHISH_FROM2, __FRAUD_WEBMAIL_FROM, __TO_MALFORMED_2, __TO_NO_NAME,
 __MULTIPLE_RCPTS_CC_X2, __SUBJ_ALPHA_END, __HAS_MSGID, __SANE_MSGID,
 __HAS_X_MAILER, __ANY_URI, __FRAUD_BODY_WEBMAIL, __URI_NO_WWW, __URI_NO_PATH,
 BODYTEXTP_SIZE_3000_LESS, BODY_SIZE_500_599, __MIME_TEXT_ONLY,
 RDNS_GENERIC_POOLED, __URI_NS, SXL_IP_DYNAMIC[215.111.133.86.fur],
 HTML_00_01, HTML_00_10, BODY_SIZE_5000_LESS, RDNS_SUSP_GENERIC, __PHISH_FROM,
 MULTIPLE_RCPTS, __PHISH_SPEAR_STRUCTURE_1, BODY_SIZE_1000_LESS, RDNS_SUSP,
 BODY_SIZE_2000_LESS, __FRAUD_WEBMAIL, BODY_SIZE_7000_LESS
X-CTCH-Spam: Unknown
From: Mike Roocroft <mike.linux@btinternet.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mike Roocroft <mike.linux@btinternet.com>
Subject: [PATCH] Crypto: gf128mul : fixed a parentheses coding style issue
Date: Sun,  5 Oct 2014 11:35:41 +0100
Message-Id: <1412505341-20273-1-git-send-email-mike.linux@btinternet.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
---
 crypto/gf128mul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 5276607..b143d84 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -97,7 +97,7 @@
     the table above
 */
 
-#define xx(p, q)	0x##p##q
+#define xx(p, q)	(0x##p##q)
 
 #define xda_bbe(i) ( \
 	(i & 0x80 ? xx(43, 80) : 0) ^ (i & 0x40 ? xx(21, c0) : 0) ^ \
-- 
2.1.0

