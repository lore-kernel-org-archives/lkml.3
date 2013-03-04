Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3CDIDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:03:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14039 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3CDIDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:03:07 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-ee-5134553ab64d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 14/24] rtc: rtc-nuc900: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:03:05 +0900
Message-id: <014701ce18ae$b3d68680$1b839380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAMKvA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY12rUJNAg/WbZSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK+LH3GFvBA/aKLUcqGxivs3UxcnJICJhINC6/wAhhi0lcuLceKM7FISSwjFHidfcs
	uKKFK7YwQiSmM0r8vL+SHcL5xSjxeNYpsHY2ATWJL18OAyU4OEQE9CXaWjRAapgFehklzvTu
	ZgepERKwlfjy8AETiM0pYCdx/9wqVhBbWMBLYuv+l2A2i4CqxNMPT8E28wLV/39znRnCFpT4
	MfkeC4jNLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSZz49ZwVokREYt+Ld2APSAjc
	Y5c48GQdO8QuAYlvkw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UXGesWJucWleel6yfm5mxghkdq/g/HuAetDjMlA6ycyS4km5wMjPa8k3tDY2MTM
	xNTE3NLU3JQ0YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFkf/87jnHLoXIDc
	JPk7/zhae65tr3qVvIRLakmTlKHHwqj4cxtOVOw/89Huu16R39foXdJeO7y06w4LndpbrPg9
	b0vg3FDbB/fcNqvMWiBU9eHHvX37Gjm7doaGRE7NmJUscqopsrZigfquBeXFjJs0qqcwO96K
	sb3Cz6nxdusRYaHlrb7HipVYijMSDbWYi4oTAasjx9nqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV2rUJNAg12NEhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZvzYe4yt4AF7xZYjlQ2M19m6GDk5JARMJBau
	2MIIYYtJXLi3HijOxSEkMJ1R4uf9lewQzi9GicezToFVsQmoSXz5chgowcEhIqAv0daiAVLD
	LNDLKHGmdzc7SI2QgK3El4cPmEBsTgE7ifvnVrGC2MICXhJb978Es1kEVCWefngKdgUvUP3/
	N9eZIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHEiV/PWSFKRCT2
	vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSngWfS
	OxhXNVgcYhTgYFTi4RX4ZBwoxJpYVlyZe4hRgoNZSYS3TMIkUIg3JbGyKrUoP76oNCe1+BBj
	MtCjE5mlRJPzgSkqryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFw
	SjUwanSfXLnneF4/X/CmWYlX9wW/kyv9dTvNdaPBAQbPG83uWy0735a/SbmkNU2To9R03RQO
	y5cyJ17vvxWb61C8x+jZvcOhTzZrLPCRb+v5eqotequ8/aOsBrOU6z8O/fML09kw203ujwZH
	5aqc/XN49HjVDQLM/+Zksf0uC78ituhg8w5OCdafSizFGYmGWsxFxYkAyZzmgEcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-nuc900.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 06b98fb..4d9525c 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -311,18 +311,7 @@ static struct platform_driver nuc900_rtc_driver = {
 	},
 };
 
-static int __init nuc900_rtc_init(void)
-{
-	return platform_driver_probe(&nuc900_rtc_driver, nuc900_rtc_probe);
-}
-
-static void __exit nuc900_rtc_exit(void)
-{
-	platform_driver_unregister(&nuc900_rtc_driver);
-}
-
-module_init(nuc900_rtc_init);
-module_exit(nuc900_rtc_exit);
+module_platform_driver_probe(nuc900_rtc_driver, nuc900_rtc_probe);
 
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("nuc910/nuc920 RTC driver");
-- 
1.7.2.5


