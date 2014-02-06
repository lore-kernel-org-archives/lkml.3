Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaBFIVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:21:47 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57446 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbaBFIVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:21:45 -0500
X-AuditID: cbfee68e-b7f566d000002344-ad-52f34618f120
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Stefano Babic'" <sbabic@denx.de>,
        "'Anatolij Gustschin'" <agust@denx.de>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 06/12] backlight: ili922x: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:21:44 +0900
Message-id: <000701cf2314$78459d60$68d0d820$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAOFkw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zA10Jt89BBh3dqhbr7y5htJizfg2b
	xeWFl1gtLu+aw2bRfsrHgdVj3qwTLB4nZvxm8ejbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	i4s/sRdMZav4/OQrSwNjN2sXIyeHhICJxJH9/9kgbDGJC/fWA9lcHEICyxgl7q9azAZTdOrL
	VlaIxHRGiSkPdkM5vxglzmw9zwhSxSagJvHly2H2LkYODhEBfYm2Fg2QGmaBPkaJ1TO3ga0T
	ErCV2H36JJjNKWAnse1TKxOILSzgJdH8+DCYzSKgKnFv0S2wmbxA9Zuv/WOGsAUlfky+xwJi
	MwtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhITnryGKhGR2PfiHSPIPRIC19glnvX8
	YYPYJSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4
	Kb3ISK84Mbe4NC9dLzk/dxMjJD77djDePGB9iDEZaP1EZinR5HxgfOeVxBsamxlZmJqYGhuZ
	W5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsb8J7v9al5eZpp5xapyPX/7
	n5UzNX8uFNVbtLVcWPHlXwVt+c2G7b4r1tgceF7mnWbyY9okv4RlShwz18yVE2b/sKxn8wFp
	QW0fz+OvyyZv4mbKs2banvtH6swfpi83FqpmyukEr1r641Dxt5B3a8949Vofbiku8lq3ddIb
	mwrWk99ymrf9OHJLiaU4I9FQi7moOBEA2ESpTeUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQV0Jt89BBv/WKlqsv7uE0WLO+jVs
	FpcXXmK1uLxrDptF+ykfB1aPebNOsHicmPGbxaNvyypGj8+b5AJYohoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA9ioplCXmlAKFAhKLi5X07TBN
	CA1x07WAaYzQ9Q0JgusxMkADCesYMy4u/sReMJWt4vOTrywNjN2sXYycHBICJhKnvmyFssUk
	Ltxbz9bFyMUhJDCdUWLKg92sEM4vRokzW88zglSxCahJfPlymL2LkYNDREBfoq1FA6SGWaCP
	UWL1zG1gk4QEbCV2nz4JZnMK2Els+9TKBGILC3hJND8+DGazCKhK3Ft0C2wmL1D95mv/mCFs
	QYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxIQnr6FKRCT2vXjHOIFR
	aBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH/zOpHYwrGywO
	MQpwMCrx8G5Y/ylIiDWxrLgy9xCjBAezkgjvVvPPQUK8KYmVValF+fFFpTmpxYcYk4Eencgs
	JZqcD0xMeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAOPNm
	9qd7ZT7zdrukL3Ljk/J7JHjswKkysyIX68htWdEHLoiZ3nRQ+jahYLqu3NG1fz57vVt8J9ok
	yO3EN4WDFgKzdEyErpZPKHiuJ/7mxlLHRcIxnXdUVtTJf0pZ6H5fa+md6lh7C+Mn7l9vz2Hc
	JSytxrtwbqDcHcNnJWe6LTcl209j6omyVmIpzkg01GIuKk4EAJmQU7RCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ili922x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
index 73464e4..ea67fe1 100644
--- a/drivers/video/backlight/ili922x.c
+++ b/drivers/video/backlight/ili922x.c
@@ -482,10 +482,8 @@ static int ili922x_probe(struct spi_device *spi)
 	u16 reg = 0;
 
 	ili = devm_kzalloc(&spi->dev, sizeof(*ili), GFP_KERNEL);
-	if (!ili) {
-		dev_err(&spi->dev, "cannot alloc priv data\n");
+	if (!ili)
 		return -ENOMEM;
-	}
 
 	ili->spi = spi;
 	spi_set_drvdata(spi, ili);
-- 
1.7.10.4


