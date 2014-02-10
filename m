Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaBJARO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 19:17:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65353 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaBJARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 19:17:13 -0500
X-AuditID: cbfee690-b7f266d00000287c-fb-52f81a873924
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Mark Brown'" <broonie@kernel.org>, "'Milo Kim'" <milo.kim@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] MAINTAINERS: add backlight co-maintainers
Date: Mon, 10 Feb 2014 09:17:10 +0900
Message-id: <003601cf25f5$70cbbf90$52633eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8l9XCtGspVfLuQQZ6nWQ98fiaDWw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zA912qR9BBl37WS3mrF/DZjH14RM2
	i6M7JzJZXF54idXi/tejjBaXd81hs1j+ax2LA7vHzll32T02repk87hzbQ+bx4kZv1k8+ras
	YvQ4fmM7k8fnTXIB7FFcNimpOZllqUX6dglcGf1bW5kLmtgqfn3Ib2D8z9LFyMkhIWAi8ffH
	ayYIW0ziwr31bF2MXBxCAssYJbavPwZX9HraRnaIxHRGiV3b/kA5vxglprZ0sIJUsQmoSXz5
	chgowcEhIqAv0daiAVLDLHCOUeLJsitgk4QFrCQ6OtaArWMRUJXoXDqXGcTmFbCVOHB6BjuE
	LSjxY/I9sHpmAS2J9TuPM0HY8hKb17xlBpkvIaAu8eivLsQqPYnpj2MgKkQk9r14xwiyVkLg
	HrtE97w7LBCrBCS+TT7EAtEqK7HpADPEX5ISB1fcYJnAKDYLyeJZSBbPQrJ4FpIVCxhZVjGK
	phYkFxQnpReZ6BUn5haX5qXrJefnbmKExOeEHYz3DlgfYkwGWj+RWUo0OR8Y33kl8YbGZkYW
	piamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBj2cx8n/wblZ+r7
	Yyb79qWyHWn00g7TlBYLO3z14fPKrJgptq9thU9UKsRM+ZNbuXEly6xFHz3tP2o+O6O4weiH
	ueHazr/WmxeGuijpPjdyON63/IttzKllnLJTz/DFrHu6KDTiYNyatW9rUo40K+40Dp7Ln8op
	Y3bIzZONscT74Oey3R7ZW5RYijMSDbWYi4oTAfbIgyTlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd12qR9BBvMOMVrMWb+GzWLqwyds
	Fkd3TmSyuLzwEqvF/a9HGS0u75rDZrH81zoWB3aPnbPusntsWtXJ5nHn2h42jxMzfrN49G1Z
	xehx/MZ2Jo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNT
	bZVcfAJ03TJzgC5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWb0b21l
	Lmhiq/j1Ib+B8T9LFyMnh4SAicTraRvZIWwxiQv31rN1MXJxCAlMZ5TYte0PO4Tzi1FiaksH
	K0gVm4CaxJcvh4ESHBwiAvoSbS0aIDXMAucYJZ4suwI2VVjASqKjYw0TiM0ioCrRuXQuM4jN
	K2ArceD0DHYIW1Dix+R7YPXMAloS63ceZ4Kw5SU2r3nLDDJfQkBd4tFfXYhVehLTH8dAVIhI
	7HvxjnECo8AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjv5n
	UjsYVzZYHGIU4GBU4uHd8ed7kBBrYllxZe4hRgkOZiUR3pd3gUK8KYmVValF+fFFpTmpxYcY
	k4H+nMgsJZqcD0xMeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAmLdqntDtGV++dJt3zpnS17FG9KjyiaKTmozWPaeehUVqhy0+M335W+5l7JWL/n6yT90o
	Np9nzT1n06up67allZ+TihBp26L2w+TZUZ+jyqXR8Q/duB80y/AemPtgoXHDj2Ku3fwPDkk3
	h3qn/12wUHVRj8wZDrO8TfNVdvcx5TuwT+1dnvfshxJLcUaioRZzUXEiAJvKSqVCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu and Lee Jones volunteer to maintain backlight drivers
and help to setup git-tree for backlight subsystem. Thus, I add
them as backlight co-maintainers.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Bryan Wu <cooloney@gmail.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 39def20..db59428 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1695,6 +1695,8 @@ F:	drivers/net/wireless/b43legacy/
 
 BACKLIGHT CLASS/SUBSYSTEM
 M:	Jingoo Han <jg1.han@samsung.com>
+M:	Bryan Wu <cooloney@gmail.com>
+M:	Lee Jones <lee.jones@linaro.org>
 S:	Maintained
 F:	drivers/video/backlight/
 F:	include/linux/backlight.h
-- 
1.7.10.4


