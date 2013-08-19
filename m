Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750821Ab3HSF2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 01:28:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17381 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3HSF2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 01:28:10 -0400
X-AuditID: cbfee68e-b7f276d000002279-7d-5211ace88d2f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Wan ZongShun <mcuos.com@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] rtc: rtc-nuc900: use NULL instead of 0
Date: Mon, 19 Aug 2013 14:28:08 +0900
Message-id: <017d01ce9c9c$e347fc60$a9d7f520$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6cnNqRWN/RT+iRQ3OZ9z7w/Olk0Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zA90XawSDDJa0K1osuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF0+l1Fvs7Oxgd2Dx2zrrL7rFn4kk2jxMzfrN49G1Zxegxfd5PJo/Pm+QC
	2KK4bFJSczLLUov07RK4Mq5u62Yt+Mpa8aL9A1sD42eWLkZODgkBE4mnn3azQthiEhfurWfr
	YuTiEBJYxihxefJ0Zpii+V+WsEAkFjFKtPfNZYdwfjFKLPp/DKyKTUBN4suXw0AJDg4RAX2J
	thYNkBpmgY2MEn0774OtExYwlzh88B8TiM0ioCpxffZUsHpeAUuJnat0QMK8AoISPybfAytn
	FtCSWL/zOBOELS+xec1bqIMUJHacfc0IYosI6ElMf7SADaJGRGLfi3eMIHslBC6xSyxesxlq
	l4DEt8mHWEB2SQjISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0
	IiO94sTc4tK8dL3k/NxNjJBo7NvBePOA9SHGZKD1E5mlRJPzgdGcVxJvaGxmZGFqYmpsZG5p
	RpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZG2SnHp1XuVOTbNPuViVZr75tt
	rT2+JfNC+UJWWnX/4D4m/3Fh9revvzSUuGQ0uz1Wn2aSFui9WPHhddzWmN1SXdsmOstdOnq4
	/oq1T3PMRLeagyeYW4oXTHqblhyT4FPqX77vppH00pIWoawCvUnqyt/XZ3g/ad8nyCsRfeB0
	qmDfxpvHlBSUWIozEg21mIuKEwFQ+UzG3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd0XawSDDG58kLFYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaLp9PrLPZ3djA6sHnsnHWX3WPPxJNsHidm/Gbx6NuyitFj+ryfTB6fN8kF
	sEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
	pFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8y4uq2bteAra8WL9g9sDYyf
	WboYOTkkBEwk5n9ZAmWLSVy4t56ti5GLQ0hgEaNEe99cdgjnF6PEov/HmEGq2ATUJL58OQyU
	4OAQEdCXaGvRAKlhFtjIKNG38z7YJGEBc4nDB/8xgdgsAqoS12dPBavnFbCU2LlKByTMKyAo
	8WPyPbByZgEtifU7jzNB2PISm9e8ZYY4SEFix9nXjCC2iICexPRHC9ggakQk9r14xziBUWAW
	klGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/oz6R2MqxosDjEK
	cDAq8fBauAkGCbEmlhVX5h5ilOBgVhLhZVEDCvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+
	MA3llcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANjr4TSp/s/
	w1aZ1BovjS4TNvS7n268WDtvF8fhhr87nu376vDwwY2Y83ketqlblgRMqP60r9vYeLbEHgvn
	EId35vlT7l08L7E3I7U7/9AyK2vWpV7Bs59KLBMM1/8eeOCBhXS79q+n++xmPOCTvnAxTWrr
	kqvh6zkiGv7W9x5SzEs8udrCJCpGiaU4I9FQi7moOBEAB+BMtDkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_rtc_access_enable() returns pointer, thus NULL should be
used instead of 0 in order to fix the following sparse warning:

drivers/rtc/rtc-nuc900.c:102:16: warning: Using plain integer as NULL pointer

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-nuc900.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 22861c5..248653c 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -99,7 +99,7 @@ static int *check_rtc_access_enable(struct nuc900_rtc *nuc900_rtc)
 	if (!timeout)
 		return ERR_PTR(-EPERM);
 
-	return 0;
+	return NULL;
 }
 
 static int nuc900_rtc_bcd2bin(unsigned int timereg,
-- 
1.7.10.4


