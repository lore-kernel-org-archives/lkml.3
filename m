Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3BRFS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:18:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61967 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3BRFSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:18:25 -0500
X-AuditID: cbfee690-b7f066d00000169f-bb-5121b9a073c4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000201ce0d96$9fa550b0$deeff210$%han@samsung.com>
In-reply-to: <000201ce0d96$9fa550b0$deeff210$%han@samsung.com>
Subject: [PATCH 5/5 RESEND] video: s3c-fb: Fix typo in definition of
 VIDCON1_VSTATUS_FRONTPORCH value
Date: Mon, 18 Feb 2013 14:18:24 +0900
Message-id: <000601ce0d97$60175e10$20461a30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Nlp93iQLgxtgRRimJ2C2xwhxUfAAAIlOw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI90FOxUDDd4dVbM40feB1eLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWcet/EVrCGveLSZJ8GxilsXYycHBICJhKrDy+EssUk
	LtxbD2RzcQgJLGOUWNe/iLWLkQOs6ONLd4j4dEaJlYv/sUA4vxglNkz5xALSzSagJvHly2F2
	kAYRAX2JthYNkBpmgbmMEpfWHAGrERKwleh8cRLM5hSwk5h36RQziC0skC7x/cYLRhCbRUBV
	4uDlfewgNi9Q/ZMPm1kgbEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nLDHGousSjv7ogYREBI4lN
	+z6xQpSISOx78Y4R5B4JgVXsEu1fTrNA7BKQ+Db5EAtEr6zEpgPMkICQlDi44gbLBEaJWUg2
	z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyTCJuxgvHfA+hBjMtD6
	icxSosn5wAjNK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGWmNuA9+eR6bN/xPe5tlX2lx+8d7y3SnhSWXOa1XDco4xtm5nv/Fzt4+o8tKEM3WX
	lTcJVpXNYJcM1bhQonPXtTnhiPvPejfPM7lHhN9eWeL2jcmg6JPo9Po00/AXyxsUf36/91X+
	zkP3Q0uEtme+T9vNtObrUckHjx/e2LH2+vx1XXN6zyQnK7EUZyQaajEXFScCALhwRUfGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd0FOxUDDRZNU7Q40feB1eLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmnHrfxFawhr3i
	0mSfBsYpbF2MHBwSAiYSH1+6dzFyApliEhfurQcKc3EICUxnlFi5+B8LhPOLUWLDlE8sIFVs
	AmoSX74cZgdpFhHQl2hr0QCpYRaYyyhxac0RsBohAVuJzhcnwWxOATuJeZdOMYPYwgLpEt9v
	vGAEsVkEVCUOXt7HDmLzAtU/+bCZBcIWlPgx+R6YzSygJbF+53EmCFteYvOat8wQR6tLPPqr
	CxIWETCS2LTvEytEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzg+H0mtYNxZYPFIUYBDkYlHl6GfMVAIdbEsuLK3EOMEhzMSiK8m0SAQrwp
	iZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTC15JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQ
	nliSmp2aWpBaBLOFiYNTqoExdEquxpazyyOf/Jx3nDeEceWhRW9NsvulpiZu36fCkHA5p/nP
	vGC3RSL1nEtV7WZO5mC/U6zKxbSpOYqr0uJKzeTne7o0ZdbdXs16h1Xd70qLjcQR7cKF014c
	aJHO+WR0uPJKoO6sn5b/hBlM8o/P6W7/afnK5LHyC+OFwVGKHsGWdivsJisqsRRnJBpqMRcV
	JwIAREMT1iMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

The correct value for VIDCON1_VSTATUS_FRONTPORCH is 3, not 0.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 include/video/samsung_fimd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/video/samsung_fimd.h b/include/video/samsung_fimd.h
index 2f95d9a..b039320 100644
--- a/include/video/samsung_fimd.h
+++ b/include/video/samsung_fimd.h
@@ -82,7 +82,7 @@
 #define VIDCON1_VSTATUS_VSYNC			(0x0 << 13)
 #define VIDCON1_VSTATUS_BACKPORCH		(0x1 << 13)
 #define VIDCON1_VSTATUS_ACTIVE			(0x2 << 13)
-#define VIDCON1_VSTATUS_FRONTPORCH		(0x0 << 13)
+#define VIDCON1_VSTATUS_FRONTPORCH		(0x3 << 13)
 #define VIDCON1_VCLK_MASK			(0x3 << 9)
 #define VIDCON1_VCLK_HOLD			(0x0 << 9)
 #define VIDCON1_VCLK_RUN			(0x1 << 9)
-- 
1.7.2.5


