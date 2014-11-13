Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaKMItW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:49:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51187 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaKMItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:49:19 -0500
X-AuditID: cbfee68e-f79b46d000002b74-0e-5464708da373
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: pratikp@codeaurora.org, mathieu.poirier@linaro.org,
        gregkh@linuxfoundation.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 1/3] coresight: fix typo in comment in coresight-priv.h
Date: Thu, 13 Nov 2014 14:12:47 +0530
Message-id: <1415868169-13325-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
References: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkTrevICXEoLOFyaJ58Xo2i02Pr7Fa
	XN41h81i654DTBaLtn5ht/h239yBzeNyXy+Tx51re9g89s9dw+6xeUm9R9+WVYwenzfJBbBF
	cdmkpOZklqUW6dslcGV8ObObqWATa8Xuae9ZGhh3sHQxcnJICJhIXGu8zARhi0lcuLeerYuR
	i0NIYCmjxLd7p9lhihpOL2SBSCxilGh7vJMZwpnAJHH122w2kCo2AV2JJ+/nMoPYIgJuEjca
	O8DGMgvUSpxYtwwsLizgLjH9/kGwqSwCqhKHem6xgti8Ah4Sc3p2A23gANqmIDFnkg1ImFPA
	U+LSsR9gJUJAJSc3LWAF2SshMJldYuK+S1BzBCS+TT4E1SsrsekAM8TRkhIHV9xgmcAovICR
	YRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYIif/vesbwfjzQPWhxgFOBiVeHhfsqSECLEm
	lhVX5h5iNAXaMJFZSjQ5HxhJeSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MDJfm/yLueLkBjeDxcLOqTd5ldiCrx290xuutZrLcmvQsvsy24Ttj80y
	+1b8SzNH7c61a3VBgou65i3cJf922dTb8zILyyT/23QsnJvT8Nl8+9tz8lO7DK7OMf/1smFf
	ckcR7wl5mznnJkS5vor+1Os2xT1gD9ushclC7iJng3gUlB6u9ry/g1GJpTgj0VCLuag4EQCH
	6zyVbAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jAd2egpQQg1ebtC2aF69ns9j0+Bqr
	xeVdc9gstu45wGSxaOsXdotv980d2Dwu9/Uyedy5tofNY//cNewem5fUe/RtWcXo8XmTXABb
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjC9ndjMVbGKt2D3tPUsD4w6W
	LkZODgkBE4mG0wuhbDGJC/fWs3UxcnEICSxilGh7vJMZwpnAJHH122w2kCo2AV2JJ+/nMoPY
	IgJuEjcaO5hAbGaBWokT65aBxYUF3CWm3z/IDmKzCKhKHOq5xQpi8wp4SMzp2Q20jQNom4LE
	nEk2IGFOAU+JS8d+gJUIAZWc3LSAdQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsY
	wRH0TGoH48oGi0OMAhyMSjy8L1hSQoRYE8uKK3MPMUpwMCuJ8DbpAIV4UxIrq1KL8uOLSnNS
	iw8xmgIdNZFZSjQ5HxjdeSXxhsYm5qbGppYmFiZmlkrivAdarQOFBNITS1KzU1MLUotg+pg4
	OKUaGI/dzrWKn/a+7+zkM59Yrn/XyUp5zPFiSep/jheNe5/E73mQH/7KPWmOUPjjJXc8nx6V
	u8W9+tdNseTHARukY+dYMVnWzKrhvflNbI8FT5rauTk2L655WCn1stm6iHgcb01XPtL1z0j9
	3iTX46LqP9VrWk/47cs9VMlVdb2NZU3mxv1qLO1BB5VYijMSDbWYi4oTAaTAWUO2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes a typo %s/eveyone/everyone/ in function CS_UNLOCK.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/coresight/coresight-priv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/coresight-priv.h b/drivers/coresight/coresight-priv.h
index 8d1180c..7b3372f 100644
--- a/drivers/coresight/coresight-priv.h
+++ b/drivers/coresight/coresight-priv.h
@@ -47,7 +47,7 @@ static inline void CS_UNLOCK(void __iomem *addr)
 {
 	do {
 		writel_relaxed(CORESIGHT_UNLOCK, addr + CORESIGHT_LAR);
-		/* Make sure eveyone has seen this */
+		/* Make sure everyone has seen this */
 		mb();
 	} while (0);
 }
-- 
1.7.9.5

