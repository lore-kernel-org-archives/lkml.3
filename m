Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab3ECGhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:37:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61705 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab3ECGho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:37:44 -0400
X-AuditID: cbfee68d-b7f016d000007930-ca-51835b37cd15
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 37/42] rtc: rtc-vr41xx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:37:42 +0900
Message-id: <003301ce47c8$b70df6a0$2529e3e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyLZms/huFw1SQg6tju6VBRyLlw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zfV3z6OZAg//9PBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlPPz/nqngJFtF+5M77A2Mu1i7GDk5JARMJK60TmCCsMUkLtxbz9bFyMUhJLCMUWLm
	8S3MMEVzv+1kgkgsYpRY/qidESQhJPCLUeLa7DoQm01ATeLLl8PsXYwcHCIC+hJtLRog9cwC
	3YwSj5rngg0SFgiW+PHyOdhmFgFViWfzGthBbF4BS4m2+wuZIWxBiR+T77GA2MwCWhLrdx5n
	grDlJTaveQt1kILEjrOvwW4QEdCTuL76NDNEjYjEvhfvGEEWSwicYpfY3LmBHWKZgMS3yYdY
	QI6TEJCV2HQAao6kxMEVN1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFhnrFibnF
	pXnpesn5uZsYIbHXu4Px9gHrQ4zJQOsnMkuJJucDYzevJN7Q2MzIwtTE1NjI3NKMNGElcV61
	FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwTszpatmeUXZEL93kXvjQ5jqXbfcJDF9lF
	HaFZj87elP3/rmHH3xkJcZ/yvpplHX85feYv+xmHtmc/P5hjtPzWmqXcl6cdcpkbEr3ZV30/
	J0OISUSo87tnFnc1X/ktqTimv3J++jLnUyluXPty9J6Xd7V47PivoWhvYvJgZlt/g+gUtpeJ
	SWeUWIozEg21mIuKEwHp7ana0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAV3z6OZAg8aDHBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZjz8/56p4CRbRfuTO+wNjLtYuxg5OSQETCTm
	ftvJBGGLSVy4t56ti5GLQ0hgEaPE8kftjCAJIYFfjBLXZteB2GwCahJfvhxm72Lk4BAR0Jdo
	a9EAqWcW6GaUeNQ8lxmkRlggWOLHy+dgC1gEVCWezWtgB7F5BSwl2u4vZIawBSV+TL7HAmIz
	C2hJrN95nAnClpfYvOYtM8RBChI7zr4Gu0FEQE/i+urTzBA1IhL7XrxjnMAoMAvJqFlIRs1C
	MmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj+5n0DsZVDRaHGAU4GJV4eBVa
	mgKFWBPLiitzDzFKcDArifC6/QAK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w6eSVxBsa
	m5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6PGjyrx2wziXVfz5xdv
	8d/nHP1h9tHL76509LZ5yXqxvmd3mC5bwqU1MyFmDYPmu54fDIc/2b3J+XLSNSu1R+nG2hkv
	zE/Gu2nc5ZGRtre2XcPxonZz7D6R3han0wvmHPOxPvNwWklW77dbr7782sqXeq5WMCgtaUF3
	WnKI17SF6U9SI9+fma/EUpyRaKjFXFScCACjQRluMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-vr41xx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index f91be04..30dd89b 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -381,8 +381,6 @@ static int rtc_remove(struct platform_device *pdev)
 	if (rtc)
 		rtc_device_unregister(rtc);
 
-	platform_set_drvdata(pdev, NULL);
-
 	free_irq(aie_irq, pdev);
 	free_irq(pie_irq, pdev);
 	if (rtc1_base)
-- 
1.7.2.5


