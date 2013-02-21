Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3BUIbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:31:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44532 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3BUIbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:31:37 -0500
X-AuditID: cbfee691-b7f556d000001a24-cc-5125db674a4f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: rtc-v3020: use gpio_request_one()
Date: Thu, 21 Feb 2013 17:31:35 +0900
Message-id: <00cb01ce100d$dc282200$94786600$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDdwKC6fcYlQATrOgz+ir+bOZGw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zI93026qBBvsvWllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mm5dyCuawV7z7t4elgfEXaxcjJ4eEgIlEw+x9jBC2mMSFe+vZ
	uhi5OIQEljFKNPS0McMUnZtziwkiMZ1RYvbRa4wQzmwmif+bjrOAVLEJqEl8+XKYvYuRg0NE
	QF+irUUDpIZZoJdR4kzvbnaQGmEBc4lbH9eD1bMIqEpMOXaDGaSeV8BWon8SJ0iYV0BQ4sfk
	e2AlzAJaEut3HmeCsOUlNq95C1YuIaAu8eivLkhYREBPYtbjZVDlIhL7XrwDO01CoJtdYvbP
	C1CrBCS+TT7EAtErK7HpANRfkhIHV9xgmcAoNgvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCel
	F5nqFSfmFpfmpesl5+duYoTEycQdjPcPWB9iTAZaP5FZSjQ5HxhneSXxhsbGJmYmpibmlqbm
	pqQJK4nzyl+SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaL74s71619G6ecx2VU9Oix41
	YjBrW39oyimF+4q39Se88VhxYLPz5sb+LJN9JbXqXo6TZapuf0rk36Yz567Tpv3fuHfP7T9U
	+rcwb1lk8fV1Wv3rJm3xtvUwsIha8fAj9zz2BvZJDBbTD5/ozeGwnqOrZXLUpmmG5ao0u4mu
	b1YtiGN+e9bZVYmlOCPRUIu5qDgRANUT79ypAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd3026qBBo/Omlhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjJuXcgrmsFe8+7eHpYHx
	F2sXIyeHhICJxLk5t5ggbDGJC/fWs3UxcnEICUxnlJh99BojhDObSeL/puMsIFVsAmoSX74c
	Zu9i5OAQEdCXaGvRAKlhFuhllDjTu5sdpEZYwFzi1sf1YPUsAqoSU47dYAap5xWwleifxAkS
	5hUQlPgx+R5YCbOAlsT6nceZIGx5ic1r3oKVSwioSzz6qwsSFhHQk5j1eBlUuYjEvhfvGCcw
	CsxCMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgKHwmvYNxVYPF
	IUYBDkYlHt4FL1UChVgTy4orcw8xSnAwK4nwmh5RDRTiTUmsrEotyo8vKs1JLT7EmAz050Rm
	KdHkfGCCyCuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwcnFINjO0W
	X1V1t7xZJGm1db/cw4Clez39DOw1tvb0My55Fp7RVSJWor+SS9Ls4A6RX5wt3ys6doumsfy0
	2N3LecbYbt0Dh8P5oXyKCvfL04wddqWES9iELHf7U8u/doKeuNwD+1OvDyQn/H3wVcTnh0V7
	u+ex46dqqxY8OVc8KfS5/WHW/zd29rIcUGIpzkg01GIuKk4EAM0wgYYGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using gpio_request_one() can make the code simpler because it can
set the direction and initial value in one shot.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-v3020.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index bca5d67..d59cd24 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -125,11 +125,10 @@ static int v3020_gpio_map(struct v3020 *chip, struct platform_device *pdev,
 	v3020_gpio[V3020_IO].gpio = pdata->gpio_io;
 
 	for (i = 0; i < ARRAY_SIZE(v3020_gpio); i++) {
-		err = gpio_request(v3020_gpio[i].gpio, v3020_gpio[i].name);
+		err = gpio_request_one(v3020_gpio[i].gpio, GPIOF_OUT_INIT_HIGH,
+					v3020_gpio[i].name);
 		if (err)
 			goto err_request;
-
-		gpio_direction_output(v3020_gpio[i].gpio, 1);
 	}
 
 	chip->gpio = v3020_gpio;
-- 
1.7.2.5


