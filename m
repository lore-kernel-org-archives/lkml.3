Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaBGIHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:07:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16301 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaBGIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:07:16 -0500
X-AuditID: cbfee690-b7f266d00000287c-b9-52f4943388f9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Wan ZongShun'" <mcuos.com@gmail.com>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 06/10] rtc: rtc-nuc900: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:07:15 +0900
Message-id: <000f01cf23db$9cc91eb0$d65b5c10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAOs9Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI13jKV+CDE7MFLdYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaLp9PrLPZ3djA6sHnsnHWX3WPPxJNsHidm/Gbx6NuyitFj+ryfTB6fN8kF
	sEVx2aSk5mSWpRbp2yVwZcw+cJOxoIW94uD8m8wNjJ9Yuxg5OSQETCS+HT7PBmGLSVy4tx7I
	5uIQEljGKLF92X9GuKLbW5kgEtMZJfbOWcsC4fxilGg58AtsFJuAmsSXL4fZuxg5OEQE9CXa
	WjRAapgFtjJK/J29gwmkRkjAVuLX5yVg9ZwCdhKLTpwFs4UF3CV27D4GZrMIqErsWrYXzOYF
	qn/48CkzhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYRMJLomvCcHaJE
	RGLfi3dQz3xkl+iazQ2xSkDi2+RDLBCtshKbDjBDlEhKHFxxg2UCo8QsJItnIVk8C8niWUg2
	LGBkWcUomlqQXFCclF5kolecmFtcmpeul5yfu4kRErsTdjDeO2B9iDEZaP1EZinR5Hxg7OeV
	xBsamxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PEJJZC
	D+aGxYzm3wVe3Z2hydaoGr1md2r2wSMnHb84HOzxzb5w9ms035rarV679u+13fjmyJopd9b3
	usewiahsUitKltFPCYxbt+b8hLwvzR9WiN/d4frv+oYTN92fl3fZzdrzqnxzouaxOaamLyMO
	LJLfF/ArrVGn+2bnRfXVnTVdjeravU+UWIozEg21mIuKEwFCcJ3o8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQV3jKV+CDOYvE7ZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaLp9PrLPZ3djA6sHnsnHWX3WPPxJNsHidm/Gbx6NuyitFj+ryfTB6fN8kF
	sEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
	pFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8yYfeAmY0ELe8XB+TeZGxg/
	sXYxcnJICJhIfLu9lQnCFpO4cG89WxcjF4eQwHRGib1z1rJAOL8YJVoO/ALrYBNQk/jy5TB7
	FyMHh4iAvkRbiwZIDbPAVkaJv7N3gE0SErCV+PV5CVg9p4CdxKITZ8FsYQF3iR27j4HZLAKq
	EruW7QWzeYHqHz58ygxhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSM
	JLomPGeHKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeu
	l5yfu4kRnBqeSe1gXNlgcYhRgINRiYf3xNLPQUKsiWXFlbmHGCU4mJVEeH82fAkS4k1JrKxK
	LcqPLyrNSS0+xJgM9OhEZinR5Hxg2soriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBsa0eN2050dmPzycOMs8Le+N/KS7e/++M5CYyvj0wapz/Juv1/99zGxv
	tfrLrnX359W5JZ+s6jasPJc/a86+JYKHCr+tXZ1TuTGecUnKC1vZ0iPPjtRfqE66VxQ5+w/b
	94YZMpsNNhTP/XXwjPqqg943Lrx8qSExy5Vnjoh79/Qj1xcLpNWfuHhcRImlOCPRUIu5qDgR
	AHqLdl1RAwAA
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
 drivers/rtc/rtc-nuc900.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 248653c..a53da09 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -229,10 +229,9 @@ static int __init nuc900_rtc_probe(struct platform_device *pdev)
 
 	nuc900_rtc = devm_kzalloc(&pdev->dev, sizeof(struct nuc900_rtc),
 				GFP_KERNEL);
-	if (!nuc900_rtc) {
-		dev_err(&pdev->dev, "kzalloc nuc900_rtc failed\n");
+	if (!nuc900_rtc)
 		return -ENOMEM;
-	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	nuc900_rtc->rtc_reg = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(nuc900_rtc->rtc_reg))
-- 
1.7.10.4


