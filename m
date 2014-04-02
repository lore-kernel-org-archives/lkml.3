Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbaDBHpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:45:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8905 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbaDBHpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:45:50 -0400
X-AuditID: cbfee68f-b7f156d00000276c-7c-533bc02c82e4
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Guenter Roeck <linux@roeck-us.net>,
        Rob Landley <rob@landley.net>
Subject: [PATCH 3/3] Documentation: update samsung pmu binding information for
 Exynos4210/4212/4412
Date: Wed, 02 Apr 2014 17:02:58 +0900
Message-id: <1396425778-4379-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zY12dA9bBBh0PFCyWTbrLZjH/yDlW
	i/43C1ktzr1ayWjRu+Aqm8XOLTfYLDY9vsZqcXnXHDaLGef3MVncvsxr8WThGSaLpdcvMlks
	2vqF3WLC9LUsFuteTmexaN17hN1i/YzXLA6CHmvmrWH0aGnuYfO43NfL5LFy+Rc2j02rOtk8
	Xq2eyeqxeUm9x87vDewefVtWMXp83iQXwBXFZZOSmpNZllqkb5fAldH7djdTwTnOikuvW5gb
	GHs4uhg5OSQETCTOzN3ICmGLSVy4t56ti5GLQ0hgGaPE5pWrgBwOsKLWrz4Q8emMEt/W/2GB
	cNqYJF49vcgC0s0moCvx5P1cZpCEiEA7o8STy+sYQRxmgWZmiVtntjKCVAkLpEqcPrUYrINF
	QFXiWOs3sDivgLvE5hN7GSHWKUjMmWQDEuYU8JB4tuQoE4gtBFTyYtEddpCZEgK9HBJbP/1m
	gpgjIPFt8iEWiF5ZiU0HmCHekZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLz
	czcxQmKvfwfj3QPWhxiTgcZNZJYSTc4Hxm5eSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmk
	J5akZqemFqQWxReV5qQWH2Jk4uCUamDcZNf8z2HGtZhPOWon5m3Te3dqZdTzYqPMNq0Yrwfy
	E6rSmkz504PN+b81XWRiMrz+f8pFRsYP3yoyVvXKedbOdm+venLAjTP3wFO2xPpX2QuPzjsa
	Pn/pkVuLP+brREycdfh/1Wee9ewiJ/7ke0scYJp6QmzuKUZGvvhZesI+Pxzu6SzuffRQiaU4
	I9FQi7moOBEA6FI0/NMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV2dA9bBBkueSlssm3SXzWL+kXOs
	Fv1vFrJanHu1ktGid8FVNoudW26wWWx6fI3V4vKuOWwWM87vY7K4fZnX4snCM0wWS69fZLJY
	tPULu8WE6WtZLNa9nM5i0br3CLvF+hmvWRwEPdbMW8Po0dLcw+Zxua+XyWPl8i9sHptWdbJ5
	vFo9k9Vj85J6j53fG9g9+rasYvT4vEkugCuqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTM
	wFDX0NLCXEkhLzE31VbJxSdA1y0zB+ghJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFw
	PUYGaCBhHWNG79vdTAXnOCsuvW5hbmDs4ehi5OCQEDCRaP3q08XICWSKSVy4t56ti5GLQ0hg
	OqPEt/V/WCCcNiaJV08vsoBUsQnoSjx5P5cZJCEi0M4o8eTyOkYQh1mgmVni1pmtjCBVwgKp
	EqdPLQbrYBFQlTjW+g0szivgLrH5xF5GiNUKEnMm2YCEOQU8JJ4tOcoEYgsBlbxYdId9AiPv
	AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBkf1MagfjygaLQ4wCHIxKPLwHzlsFC7Em
	lhVX5h5ilOBgVhLh5ZxkHSzEm5JYWZValB9fVJqTWnyIMRnoqInMUqLJ+cCkk1cSb2hsYmZk
	aWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFLAmF/FUeT6Pq5+y+xZaZVfLm2N
	fzxTvMO2TmKhi1PKreVzvF24/O6035h+UL7+7QcbAe9fvh8TVQ+84bdcW5GafSckXdol7k3x
	lu/bGu3co28tfRfC51/4mfvt4wje6JufZx5mPF+TVF30bfYOqcjKLx6sd0KtN//V4/RqfaR/
	jEkrYPkmdaXJSizFGYmGWsxFxYkAbpcOozADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates samsung pmu (power management unit) binding information
for Exynos4210, Exynos4212 and Exynos4412.

CC: Leela Krishna Amudala <l.krishna@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>
CC: Guenter Roeck <linux@roeck-us.net>
CC: Rob Landley <rob@landley.net>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 Documentation/devicetree/bindings/arm/samsung/pmu.txt |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
index f1f1552..b562634 100644
--- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
@@ -2,6 +2,9 @@ SAMSUNG Exynos SoC series PMU Registers
 
 Properties:
  - compatible : should contain two values. First value must be one from following list:
+		   - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
+		   - "samsung,exynos4212-pmu" - for Exynos4212 SoC,
+		   - "samsung,exynos4412-pmu" - for Exynos4412 SoC,
 		   - "samsung,exynos5250-pmu" - for Exynos5250 SoC,
 		   - "samsung,exynos5420-pmu" - for Exynos5420 SoC.
 		second value must be always "syscon".
-- 
1.7.10.4

