Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3C2BlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:41:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45761 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab3C2BlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:41:00 -0400
X-AuditID: cbfee68d-b7f786d000005188-90-5154f128d56a
Date: Fri, 29 Mar 2013 01:40:50 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND] fbmon: use VESA_DMT_VSYNC_HIGH to fix typo
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com, FlorianSchandinat@gmx.de,
        s.trumtrar@pengutronix.de, plagnioj@jcrosoft.com, jg1.han@samsung.com
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130329013857424@jg1.han
Msgkey: 20130329013857424@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130329013857424@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: Y
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8984685.165951364521249756.JavaMail.weblogic@epml18>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zY12NjyGBBtv+Wllc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXM6Nl9ga1gGlfFhOZP7A2MHzi7GDk5hASUJCad3MsIYksImEhMXHaN
	BcIWk7hwbz1bFyMXUM0yRonJ85+xwBQtOT+XHSIxn1Fi1YYFTF2MHBwsAqoSB9YFgtSwCahL
	TPjdzAISFhZwkjh6KBIkLAK0a1Z3HxNIK7PAE0aJsy+WMkEcIStxb/JsZhCbV0BQ4uTMJ1C7
	FCS23PzABBFXlGid/oQZIi4hcef+flYIm1diRvtTqHo5iWlf10DVSEucn7WBEeaZxd8fQ8X5
	JY7d3gF2Mkjvk/vBMGN2b/7CBmELSEw9c5ARokRV4v8RO4gwn8SahW+hNglKnL7WzQzT2rDx
	NzuIzQx05ZTuh1C2lsSXH/vY0H3FK+AocWLdBeYJjMqzkKRmIWmfhaQdWc0CRpZVjKKpBckF
	xUnpRYbIcb2JEZIEe3cw3j5gfYhxPyMwRiYyS4km5wPTaF5JvKGxmZGFqYmpsZG5pRmFwiam
	FhYmRlQRVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeK6oJIJ5mkLP/y3u4Tdt
	d1keWFlm/1arnVtkw+a+L4vW37d5Z7Lkat7PizM5HYO61mXu3XFWUdT6hviXliZjpdvXDt/R
	9N2939h/7l6tl5b6/y5eX8m8+vDsdgZdx7Uu4ufDfXkL+xOfcsp2a5o8KJztfc9Lhd8zoKVE
	bv1H21MPWt2KGRWPKrEUZyQaajEXFScCAB97ybn1AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DF2NjyGBBtdvmVlc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jJ7dF9gKpnFVTGj+xN7A+IGzi5GTQ0hASWLSyb2MILaEgInEkvNz2SFsMYkL99azdTFyAdXM
	Z5RYtWEBUxcjBweLgKrEgXWBIDVsAuoSE343s4CEhQWcJI4eigQJiwCNnNXdxwTSyizwhFHi
	7IulTBC7ZCXuTZ7NDGLzCghKnJz5hAVil4LElpsfmCDiihKt058wQ8QlJO7c388KYfNKzGh/
	ClUvJzHt6xqoGmmJ87M2MMLcvPj7Y6g4v8Sx2zvATgbpfXI/GGbM7s1f2CBsAYmpZw4yQpSo
	Svw/YgcR5pNYs/At1CZBidPXuplhWhs2/gaHDjPQlVO6H0LZWhJffuxjQ/cVr4CjxIl1F5gn
	MMrNQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjpFSfmFpfmpesl5+duYgSnp2eLdjD+O299
	iFGAg1GJh3dGREigEGtiWXFl7iFGCQ5mJRHeaeeBQrwpiZVVqUX58UWlOanFhxiTgdE3kVlK
	NDkfmDrzSuINjY1NzExMzQ0sDCzNSRNWEud91modKCSQnliSmp2aWpBaBLOFiYNTqoGxcObz
	pjUBb411n14O+fpj80TD3e3Fs5gqSw5vlVV2+ZL/S9r4aVmnm+iZp5te/rHJvfIwqTQrKaLw
	MW/Ez1zOo8v3HlQ/ll3jx6/r+aD9Rfksvk0FobUP1yYdTA45NPHWtKU/a6OPMM4WlY68tfyH
	T3XYDwevOzsyphlWVs04wMSiXDZh2RcbJZbijERDLeai4kQACcjL+ZMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2T1f99Y025662

VESA_DMT_VSYNC_HIGH should be used instead of VESA_DMT_HSYNC_HIGH,
because FB_SYNC_VERT_HIGH_ACT is related to vsync, not to hsync.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/fbmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 94ad0f7..7f67099 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -1400,7 +1400,7 @@ int fb_videomode_from_videomode(const struct videomode *vm,
 	fbmode->vmode = 0;
 	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
 		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
-	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
+	if (vm->dmt_flags & VESA_DMT_VSYNC_HIGH)
 		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
 	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
 		fbmode->vmode |= FB_VMODE_INTERLACED;
-- 
1.7.2.5
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
