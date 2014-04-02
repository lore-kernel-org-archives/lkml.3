Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbaDBHeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:34:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31129 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbaDBHeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:34:00 -0400
X-AuditID: cbfee68f-b7f156d00000276c-bc-533bbd65d579
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 01/10] ARM: EXYNOS: Cleanup  "mach-exynos/common.h" file
Date: Wed, 02 Apr 2014 16:50:52 +0900
Message-id: <1396425058-4012-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t8zI93UvdbBBl8/2lgsm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfNY/OSeo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DKOHH7DGvBJtaK9U8nsjQwnmLpYuTkkBAwkfj9ei4zhC0mceHeerYuRi4OIYFl
	jBJXTy6BK/ox7woTRGIRo8Sc5nY2kISQQBuTxL854iA2m4CuxJP3EJNEBLIlLs26BdbMLFAk
	8WbdH7B6YQEPiUk35oDVsAioSqzZPgUszivgLjGrZRZQPQfQMgWJOZNsQMKcQOX3W1rYIVa5
	S8y9sZMV5AYJgcnsEl92HmGEmCMg8W3yIaheWYlNB6CekZQ4uOIGywRG4QWMDKsYRVMLkguK
	k9KLjPWKE3OLS/PS9ZLzczcxQsK6fwfj3QPWhxiTgcZNZJYSTc4HxkVeSbyhsZmRhamJqbGR
	uaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCs8HVS29y6a6eeHdd668yD
	PhV3+zLOf2Y+4xUo8+73hkdrc12sj2+fm7YuSDHL7Lem/YFnH9inzOg0l52QVqoerreXpSPr
	KqtFQVzPtfOZ3k3zHs6dfa6l4Huz0ieTqTKXTtgsdoou5LDYsHfGm91WPlsCOeffPJT4nLls
	iohESWvx9w7r/7ZKLMUZiYZazEXFiQBnjo16gQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jAd3UvdbBBt83W1osm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfNY/OSeo++LasYPT5vkgtgiWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHi9hnWgk2sFeufTmRpYDzF0sXIySEh
	YCLxY94VJghbTOLCvfVsXYxcHEICixgl5jS3s4EkhATamCT+zREHsdkEdCWevJ/LDGKLCGRL
	XJp1C2wQs0CRxJt1f8DqhQU8JCbdmANWwyKgKrFm+xSwOK+Au8SslllA9RxAyxQk5kyyAQlz
	ApXfb2lhh1jlLjH3xk7WCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER80zqR2M
	KxssDjEKcDAq8fAeOG8VLMSaWFZcmXuIUYKDWUmEl3OSdbAQb0piZVVqUX58UWlOavEhxmSg
	oyYyS4km5wMjOq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GAtWX1IKP2Ul5rP5dnnr96oa9bCnC2Tsn33Yu/rEkWaFDunep21/3p1Q37FK/K/uavbTKesn
	ff1fvI3n7a5jd80vXnwpWFufO1F227rDc/peXJZZeOC8V6at54H7z7tOqetX+LFmLV7y/uPn
	R5bPpt7MZrnz74PjOvFV01T+Mss6pTYtLJH/lSWvxFKckWioxVxUnAgAlPloO94CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused declarations from "mach-exynos/common.h"

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 9ef3f83..277a83e 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -15,9 +15,6 @@
 #include <linux/reboot.h>
 #include <linux/of.h>
 
-void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
-
-struct map_desc;
 void exynos_init_io(void);
 void exynos_restart(enum reboot_mode mode, const char *cmd);
 void exynos_cpuidle_init(void);
-- 
1.7.10.4

