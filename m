Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550AbaEFIda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:33:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20376 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934533AbaEFIdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:33:24 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-c7-53689e4ce9e8
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, arnd@arndb.de,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 4/6] ARM:  EXYNOS: remove unused header inclusion from
 hotplug.c
Date: Tue, 06 May 2014 17:51:20 +0900
Message-id: <1399366282-4191-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399366282-4191-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t8zfV2feRnBBhOnCVv8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtn5ht1g/4zWLA7vH71+TGD02L6n36NuyitHj8ya5AJYoLpuU
	1JzMstQifbsErowNqzYwF+xnqZi+4SF7A+MD5i5GTg4JAROJA5/3sEHYYhIX7q0Hsrk4hASW
	MUrMPr+HvYuRA6xo/SR7kBohgemMEq3zoyFq2pgkLje9ZARJsAnoSjx5PxdsqIhAtsSVxvtg
	NrNAusSDtxNYQWxhgVCJpvv7wWwWAVWJpz2T2UFsXgF3iWu3DjFD7FKQmDPJBiTMKeAh8eba
	W1aIve4SO+7fBrtNQmAyu8SLLc+ZIOYISHybfIgFoldWYtMBqL8kJQ6uuMEygVF4ASPDKkbR
	1ILkguKk9CITveLE3OLSvHS95PzcTYyQsJ6wg/HeAetDjMlA4yYyS4km5wPjIq8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGBdMm39BYZZM2/17
	d5d8388WxVKQ0pc/wzDU5zF3OMfngM3iYp8XBi3fX9i6rCPs4B6Pfc8O+PzjntjF67HEwexO
	l+mj/Xt/ty9tXbHi4PUja18rnlbZpnUw5p33nnq77czS7z57h+nsXcny9l+xQTif0Ox+/rLZ
	+m42u/z4/3+6o6Mldjdq8jwlluKMREMt5qLiRABaumyegQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQV2feRnBBss281v8nXSM3aJ3wVU2
	i02Pr7FaXN41h81ixvl9TBaLtn5ht1g/4zWLA7vH71+TGD02L6n36NuyitHj8ya5AJaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZG1ZtYC7Yz1IxfcND9gbGB8xdjBwc
	EgImEusn2XcxcgKZYhIX7q1nA7GFBKYzSrTOj+5i5AKy25gkLje9ZARJsAnoSjx5P5cZxBYR
	yJa40ngfzGYWSJd48HYCK4gtLBAq0XR/P5jNIqAq8bRnMjuIzSvgLnHt1iGovQoScybZgIQ5
	BTwk3lx7ywqx111ix/3bbBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6aZ9I7
	GFc1WBxiFOBgVOLhPbEyPViINbGsuDL3EKMEB7OSCG99fkawEG9KYmVValF+fFFpTmrxIcZk
	oKMmMkuJJucDIzqvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODil
	GhjjJ3qv8Chcsvx3wHmvOy85F2q+i6xUPcD3WPbl1sanW1NyVhzk28Q5rdNaV+/J9ekCR+zV
	y/7e5/t09OVx55nH9SaEBe74mfVtl1LgjpTPLEeFTGwqbBZkfzm+TbOs/7baia+i+06pNs6p
	kPHSt9266uRzIaaGYM0AtTwe9W81LPYNM3ISYhYrsRRnJBpqMRcVJwIAixscJ94CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removed "plat/cpu.h" inclusion from hotplug.c as it
is not required.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 0243ef3..5e19601 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -19,8 +19,6 @@
 #include <asm/cp15.h>
 #include <asm/smp_plat.h>
 
-#include <plat/cpu.h>
-
 #include "common.h"
 #include "regs-pmu.h"
 
-- 
1.7.10.4

