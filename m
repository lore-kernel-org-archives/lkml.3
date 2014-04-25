Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaDYMQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:16:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaDYMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:15:07 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-7c-535a51c9f900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, s.nawrocki@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 07/10] ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
Date: Fri, 25 Apr 2014 21:32:43 +0900
Message-id: <1398429166-5539-8-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+Zse7JwKhgg4NfTSw2zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGtx+E07q8X6Ga9ZLG4+285ksaNlNYsDt0dLcw+b
	x+Yl9R59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CV0XDjOGPBdpaK87u3sjQw3mDuYuTkkBAw
	kfhyaDkjhC0mceHeerYuRi4OIYFljBI3nzxm6WLkACtaMzUIpEZIYBGjxJILMRA1bUwSR3pX
	sIAk2AR0JZ68nws2VEQgW+JK431mkCJmgSOMErffHGMCSQgLuEksfv0drIFFQFVi99puZpAF
	vALuEle2ekHsUpCYM8kGpIJTwEPixPKP7BC7Whklzv++zQLiSAhsYpe4tWIf1BwBiW+TD0Ed
	Kiux6QDUY5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRkj4T9jBeO+A
	9SHGZKBxE5mlRJPzgfGTVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2M1nf36h0/WnzEoN9qR9qzWg3jvkSny+/rLszX8g5kOD2Z4c0HLk0J7pxj
	q164bIhr6jdaEOicn1S56Qhj/86Gf3usk5qdJIUnsCS+eifDNMngjvx3sVvJB3PyGb9bT9ke
	991y4SshrVv/lCM5Jkn3C+flfeksm9U7a9XMCy43pkTfdhOfdeiNEktxRqKhFnNRcSIASBzv
	P5UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jAd2TgVHBBr1vDSw2zljParFs0l02
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGtx+E07q8X6Ga9ZLG4+285ksaNlNYsDt0dLcw+b
	x+Yl9R59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCX
	mJtqq+TiE6DrlpkDdJSSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaPh
	xnHGgu0sFed3b2VpYLzB3MXIwSEhYCKxZmpQFyMnkCkmceHeejYQW0hgEaPEkgsxXYxcQHYb
	k8SR3hUsIAk2AV2JJ+/nMoPYIgLZElca7zODFDELHGGUuP3mGBNIQljATWLx6+9gDSwCqhK7
	13aDLeMVcJe4stULYq+CxJxJNiAVnAIeEieWf2SH2NXKKHH+922WCYy8CxgZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIER9cz6R2MqxosDjEKcDAq8fBOkI0MFmJNLCuuzD3EKMHBrCTC
	+8EvKliINyWxsiq1KD++qDQntfgQYzLQUROZpUST84GRn1cSb2hsYmZkaWRmYWRibk6asJI4
	78FW60AhgfTEktTs1NSC1CKYLUwcnFINjIpblBTzLmrpv7//QOyt+6PM/lCGUhX71DjLDW+f
	BIopbNL8UXA8c234tBRjSdFffXwHrjXP+mw40eORuPiqfZuFoxluia0XOreibVKZyO+33WoV
	l+Z534nIP3fg0jrDtRmtNTy9wQXrVqh1f+y20/PVbLqs85ybW+lg8TyuPNOZq+ftDjHPVGIp
	zkg01GIuKk4EANLymCbyAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Young-Gun Jang <yg1004.jang@samsung.com>

This patch removes unnecessary header file inclusion from pmu.c.

Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
---
 arch/arm/mach-exynos/pmu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 05c7ce1..4c3453a 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -11,7 +11,6 @@
 
 #include <linux/io.h>
 #include <linux/kernel.h>
-#include <linux/bug.h>
 
 #include <plat/cpu.h>
 
-- 
1.7.10.4

