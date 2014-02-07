Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaBGIPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:15:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23889 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaBGIPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:15:20 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-bb-52f496174fa9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Rajeev kumar'" <rajeev-dlh.kumar@st.com>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 10/10] rtc: rtc-spear: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:15:19 +0900
Message-id: <001601cf23dc$bd8b3d30$38a1b790$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAgkNg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zY13xaV+CDGZNsLBYcvEqu8Wc9WvY
	LF4e0rS4vPASq8XlXXPYLF7v/Mdmsb+zg9Fi41cPBw6PPRNPsnncubaHzePEjN8sHn1bVjF6
	PP2xl9lj+ryfTB6fN8kFsEdx2aSk5mSWpRbp2yVwZcz9OoW54A1rxZvnKxkbGB+zdDFyckgI
	mEh8f9LGCGGLSVy4t54NxBYSWMYo8eVyNUzN1u9LgeJcQPFFjBKrr21ih3B+MUp0/zsL1sEm
	oCbx5cthoAQHh4iAvkRbiwZIDbPAU0aJo2emM0FMtZX49XkJK4jNKWAnsejEWTBbWMBNYt/m
	52BXsAioSpw/+pYNZA4vUP2Ss9EgYV4BQYkfk++BHc0soCWxfudxJghbXmLzmrfMIOUSAuoS
	j/7qgoRFBIwkll1sZ4QoEZHY9+IdI8g5EgKdHBIrb71ggVglIPFt8iEWiF5ZiU0HmCH+lZQ4
	uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkqnt3
	MN4+YH2IMRlo/URmKdHkfGBSyCuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGRvsXHTcsZprPmXVqX+bFHXpMDtqmS9piHhhONJW3C37PEeigtuiW
	HL/b47kym7+++lC3/4fRrZybreWP9Rdd761hucaxuHPhLImVZ/MLpveLv9Oucfp3utlWaZaP
	z5Swb8mpmy9umV7jd017kc/sdxUrv72a1MClLHK2MP7mtQSpSy37pl9KsVJiKc5INNRiLipO
	BAAE7IC6AAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAV3xaV+CDG6/MrZYcvEqu8Wc9WvY
	LF4e0rS4vPASq8XlXXPYLF7v/Mdmsb+zg9Fi41cPBw6PPRNPsnncubaHzePEjN8sHn1bVjF6
	PP2xl9lj+ryfTB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynk
	Jeam2iq5+AToumXmAB2lpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8yY
	+3UKc8Eb1oo3z1cyNjA+Zuli5OSQEDCR2Pp9KRuELSZx4d56IJuLQ0hgEaPE6mub2CGcX4wS
	3f/OglWxCahJfPlyGCjBwSEioC/R1qIBUsMs8JRR4uiZ6UwgNUICthK/Pi9hBbE5BewkFp04
	C2YLC7hJ7Nv8nBHEZhFQlTh/9C0byBxeoPolZ6NBwrwCghI/Jt8DO45ZQEti/c7jTBC2vMTm
	NW+ZQcolBNQlHv3VBQmLCBhJLLvYzghRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4aTyT2sG4ssHiEKMAB6MSD++JpZ+DhFgTy4orcw8x
	SnAwK4nw/mz4EiTEm5JYWZValB9fVJqTWnyIMRnoz4nMUqLJ+cCEllcSb2hsYmZkaWRmYWRi
	bk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjGwvTePuHir7F7hk66eVey5w9ux8I2Ox
	Nn4h74tgph1C3qdUw+Z1Tzyi82+X2onzzn2Z0jfc7kTn5HqqHng8u4vnpz335E7zrQbmGVJP
	/y999TDnT8x87nA2z21r5Q+sZn3pt2jKz68WFx+enHvfNrm9+LiLkXMaf/37+/GbX/7kj8o3
	Em/R9VFiKc5INNRiLipOBADUm9+/XgMAAA==
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
 drivers/rtc/rtc-spear.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index c492cf0..d2cdb98 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -365,10 +365,8 @@ static int spear_rtc_probe(struct platform_device *pdev)
 	}
 
 	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
-	if (!config) {
-		dev_err(&pdev->dev, "out of memory\n");
+	if (!config)
 		return -ENOMEM;
-	}
 
 	/* alarm irqs */
 	irq = platform_get_irq(pdev, 0);
-- 
1.7.10.4


