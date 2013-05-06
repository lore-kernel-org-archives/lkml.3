Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3EFEQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:16:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48344 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3EFEQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:16:31 -0400
X-AuditID: cbfee68d-b7f016d000007930-34-51872e9e58ef
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Jett.Zhou'" <jtzhou@marvell.com>
Subject: [PATCH 1/8] 88pm860x_battery: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:16:30 +0900
Message-id: <003601ce4a10$7c1adaf0$745090d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEFHBi5jT+Ri3RBuFL8q1DtHQRQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfd15eu2BBu2/FSwObtW0mLhyMrPF
	5YWXWC2W/XkIZO2aw+bA6jGh/xOjx+YVWh6TF15k9ujbsorR4/MmuQDWKC6blNSczLLUIn27
	BK6MF7M+sRQ0s1csn/iSrYHxJ2sXIyeHhICJxN0tr9kgbDGJC/fWA9lcHEICyxgl3l09ztzF
	yAFW9OeiCkR8OqPEroYPLBDOL0aJTbdfMYN0swmoSXz5cpgdxBYR0JBoWz0FrIhZYDKjxP/G
	VWArhAUCJKbcWQLWwCKgKvHm/lMmEJtXwFLixsJJ7BC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb
	17xlhjhVQWLH2deMEMv0JDoe72eDqBGR2PfiHSNEzSF2iQMfEyF2CUh8m3yIBeIbWYlNB6DG
	SEocXHGDZQKj2Cwkm2ch2TwLyeZZSDYsYGRZxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iRES
	d707GG8fsD7EmAy0fiKzlGhyPjBu80riDY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1O
	TS1ILYovKs1JLT7EyMTBKdXAeJnR1DBl6fUDwcEPLHJTHNauVXkmYruQ70F3N1fvMuWnftde
	6znI288vNtp05ezNO/KRnTybJbYtl486P8fmTMeXpNmxUzeISWpEqO4Pb9GRiVaV3u5x9dTy
	7f58ZhfCv5nfvj8hYKW/lXnPColo/jWHIv5rtOW0+L41vvvsJsejmQV9nEaTlFiKMxINtZiL
	ihMBeprEGtECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd15eu2BBrMWyVoc3KppMXHlZGaL
	ywsvsVos+/MQyNo1h82B1WNC/ydGj80rtDwmL7zI7NG3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqp
	ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAu5UUyhJzSoFCAYnFxUr6
	dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGS9mfWIpaGavWD7xJVsD40/WLkYODgkBE4k/F1W6
	GDmBTDGJC/fWs3UxcnEICUxnlNjV8IEFwvnFKLHp9itmkCo2ATWJL18Os4PYIgIaEm2rp4AV
	MQtMZpT437iKDSQhLBAgMeXOErAGFgFViTf3nzKB2LwClhI3Fk5ih7AFJX5MvscCYjMLaEms
	33mcCcKWl9i85i0zxEkKEjvOvmaEWKYn0fF4PxtEjYjEvhfvGCcwCsxCMmoWklGzkIyahaRl
	ASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzguH4mvYNxVYPFIUYBDkYlHt6CJ22BQqyJ
	ZcWVuYcYJTiYlUR4ffYChXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmHLySuINjU3MjCyN
	zCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFxbt5s23VBbZJrvmUzq/w42st2
	66bwi6PrTrT2hykdct0vcKoj7bJK9cml3Vd+iolunO0rNJHnjA3Pd0OFPnWf0pInXxlccpfe
	ZZdwnbIr5db6lPmBnncr9xw5ES6+9InK9rWfnv2p6lU0mvTF55iR7JrXrH9frGS+sdD+6daM
	3MTdGTsZLuVGKrEUZyQaajEXFScCALVp19IvAwAA
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
 drivers/power/88pm860x_battery.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
index d338c1c..dfcda3a 100644
--- a/drivers/power/88pm860x_battery.c
+++ b/drivers/power/88pm860x_battery.c
@@ -992,7 +992,6 @@ static int pm860x_battery_remove(struct platform_device *pdev)
 	free_irq(info->irq_batt, info);
 	free_irq(info->irq_cc, info);
 	power_supply_unregister(&info->battery);
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


