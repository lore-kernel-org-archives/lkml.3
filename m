Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaDYKHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:07:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61075 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaDYKHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:07:17 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-79-535a33d301cc
Date: Fri, 25 Apr 2014 10:07:15 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] mips: Fix compile warnings of perf "tests/attr.c" on mips64.
To: ralf@linux-mips.org
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140425100342151@eunb.song
Msgkey: 20140425100342151@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140425100342151@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <33175867.61781398420434600.JavaMail.weblogic@epml03>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsVy+t8zXd3LxlHBBh8fG1hc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXMuP6rumAOZ8WedVdYGhh/cHQxcnIICahItPz/zghiSwiYSDz42wll
	i0lcuLeerYuRC6hmGaPEyd8bmboYOcCKjk5lhIjPYZS41t7HDNLAIqAqsbThJFgzm4C2xI8D
	V8HiwgK+EmsuH2QCsUUEZCSWfroCVsMsUCPR/XcxI8QR8hKTT19mB7F5BQQlTs58wgJxhJLE
	61mbWCHiyhLTvixjhYhLSMyafgHK5pWY0f4Uql5OYtrXNcwQtrTE+Vkb4J5Z/P0xVJxf4tjt
	HVC/8Eo8uR8MM2b35i9sELaAxNQzB6Fa1SU2P70EZfNJrFn4FmqVoMTpa93MML33t8xlgnhL
	UWJK90N2CFtL4suPfWyo3uIAsh0lzh10msCoPAtJZhaS7llIupHVLGBkWcUomlqQXFCclF5k
	jBzVmxghKbB/B+PdA9aHGPczAqNkIrOUaHI+MInmlcQbGpsZWZiamBobmVuaUShsYmphYWJE
	FWElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTByBd/dUzL3QqRwSY36+43X3t55
	3nplIeOEXgFNlRsyTD6tLX4yPPdf1b88+33RZdbfe9V0ttR+b5jjNnXSM2GzE3PrZNwZbVuu
	TFebwXc30Dtnbdkh5ldHnKwVd156bv7uzk4ZHbf3AX+Oz23d2DE5RO5Lqshu27YX3ZEKB5wW
	p0YJ35awnSKtxFKckWioxVxUnAgAHzJZFfQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tft3LxlHBBp+n61pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jOu/qgvmcFbsWXeFpYHxB0cXIyeHkICKRMv/74xdjBwcEgImEkenMoKEJQTEJC7cW8/WxcgF
	VDKHUeJaex8zSIJFQFViacNJsCI2AW2JHweugsWFBXwl1lw+yARiiwjISCz9dAWshlmgRqL7
	72JGiF3yEpNPX2YHsXkFBCVOznzCArFMSeL1rE2sEHFliWlflrFCxCUkZk2/AGXzSsxofwpV
	Lycx7esaZghbWuL8rA1wRy/+/hgqzi9x7PYOJoi/eCWe3A+GGbN78xc2CFtAYuqZg1Ct6hKb
	n16Csvkk1ix8C7VKUOL0tW5mmN77W+YyQbylKDGl+yE7hK0l8eXHPjZUb3EA2Y4S5w46TWCU
	m4UkMwtJ9ywk3chqFjCyrGIUTS1ILihOSq8w0itOzC0uzUvXS87P3cQITk7PFu1g/Hfe+hCj
	AAejEg/vBNnIYCHWxLLiytxDjBIczEoivH91o4KFeFMSK6tSi/Lji0pzUosPMSYD428is5Ro
	cj4wceaVxBsaGxgbGlqaG5gaGlmQJqwkzit/KylISCA9sSQ1OzW1ILUIZgsTB6dUA+NDTx3m
	Dw8/XprQ7Dm9+7ebm03LxYs+d+8lvS44/e4Nr82+V7+1TDdWt31f22L5lunPihtVD4tnnu71
	dOZ67XI51ermwwv1bu9UdN8k3Fl7Oiu2I/1rUrOMUrqjvoJVqHrDre72uPbYHX8KHFr2G2tf
	kJ7/KEB7yddnM2qF329hnuohc615710lluKMREMt5qLiRAC2HyNwkgMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3PA7gGj005091


On mips64, we by default include '<asm-generic/int-l64.h> which results in __u64 being an
unsigned long. This causes compile warnings which are treated as errors due to '-Werror'.
This patch references commit e3541ec7.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/include/uapi/asm/types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/uapi/asm/types.h b/arch/mips/include/uapi/asm/types.h
index 7ac9d0b..8d959a0 100644
--- a/arch/mips/include/uapi/asm/types.h
+++ b/arch/mips/include/uapi/asm/types.h
@@ -16,7 +16,7 @@
  * userspace to avoid code changes.
  */
 #ifndef __KERNEL__
-# if _MIPS_SZLONG == 64
+# if !defined(__SANE_USERSPACE_TYPES__) && _MIPS_SZLONG == 64
 #  include <asm-generic/int-l64.h>
 # else
 #  include <asm-generic/int-ll64.h>
-- 
1.7.0.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
