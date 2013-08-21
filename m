Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab3HUJW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:22:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10751 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3HUJW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:22:56 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-ae-521486ef2d0d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001b01ce9e4f$d1c97950$755c6bf0$%han@samsung.com>
In-reply-to: <001b01ce9e4f$d1c97950$755c6bf0$%han@samsung.com>
Subject: [PATCH 2/2] clocksource: sh_mtu2: remove unnecessary
 platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:22:55 +0900
Message-id: <002601ce9e50$04863680$0d92a380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6eT9Gw4QMTlzEDTGKp7zWeUER7LwAABeeA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY933bSJBBlteClrM+yxrceHtBzaL
	ywsvsVpc3jWHzWLzpqnMDqwed67tYfN4d+4cu0ffllWMHnN+fmPx+LxJLoA1issmJTUnsyy1
	SN8ugStj5qpNLAVXWSs+3drE0sB4iaWLkZNDQsBEYuvkz2wQtpjEhXvrgWwuDiGBZYwSj9b9
	ZIYp+vL6NyOILSSwiFHizURviKJfjBK3Nl4Dm8QmoCbx5cthdhBbRMBA4vXp3+wgRcwCsxkl
	Nv55yArRbSsxf9FnJhCbU8BO4vGPfWC2sECYxLWfV8G2sQioSnQ+7AUbxAtUP/lCNyOELSjx
	Y/I9sGXMAloS63ceZ4Kw5SU2r3kL1MsBdKm6xKO/uhA3GEkcmPOJDaJERGLfi3eMIPdICNxi
	l2htnMEOsUtA4tvkQywQvbISmw5APSwpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpB
	ckFxUnqRiV5xYm5xaV66XnJ+7iZGSKRO2MF474D1IcZkoPUTmaVEk/OBkZ5XEm9obGZkYWpi
	amxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsawgEhvP79Z1nlyXou2
	XDp89xCTX+jsBcEtL7ayiV55tDNILyg3O0KP5bqS57fJ/ZfnBwcd714e1rv/ztXP987vNOFI
	8dPL2PNVq+R8x/wXwXMjrGfUCoRMaGNa83TJp8tJBgHbbpttUzfgXbyt91LuYYmylLmT0nU6
	Sph8NX//X90+zerFzJNKLMUZiYZazEXFiQCu9eFc6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd33bSJBBnsa+SzmfZa1uPD2A5vF
	5YWXWC0u75rDZrF501RmB1aPO9f2sHm8O3eO3aNvyypGjzk/v7F4fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMXPVJpaCq6wVn25tYmlgvMTSxcjJISFgIvHl
	9W9GCFtM4sK99WwgtpDAIkaJNxO9uxi5gOxfjBK3Nl4Da2ATUJP48uUwO4gtImAg8fr0b3aQ
	ImaB2YwSG/88ZIXotpWYv+gzE4jNKWAn8fjHPjBbWCBM4trPq8wgNouAqkTnw16wQbxA9ZMv
	dDNC2IISPybfA1vGLKAlsX7ncSYIW15i85q3QL0cQJeqSzz6qwtxg5HEgTmf2CBKRCT2vXjH
	OIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSngWfSOxhX
	NVgcYhTgYFTi4b2gLBIkxJpYVlyZe4hRgoNZSYR3UTVQiDclsbIqtSg/vqg0J7X4EGMy0KMT
	maVEk/OBKSqvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhir
	eBdtXRn5M41PWig6sbPmw7Tn0xKtXjdwt0oemilnKK3NXxIcoD+RYQnPZOHFi822/NFY3fiT
	ee6T4ARJrg/XI3sPPT4Sci9phUAHb+sfXRHhiy7z11t15QUnhn7Y0C20cNJdZrs9j+ruumpu
	2P61ortnE0/5U/bb+e8SRdruzztfaTlF6ZgSS3FGoqEWc1FxIgD9U2C9RwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/clocksource/sh_mtu2.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 4aac9ee..f02648e 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -346,7 +346,6 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 	ret = sh_mtu2_setup(p, pdev);
 	if (ret) {
 		kfree(p);
-		platform_set_drvdata(pdev, NULL);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
-- 
1.7.10.4


