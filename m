Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3IWJkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:40:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21792 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3IWJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:40:30 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-38-52400c8dd5c9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 02/15] rtc: rtc-88pm860x: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:40:28 +0900
Message-id: <001e01ceb840$f0628810$d1279830$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAD3WQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zI91eHocgg5mtHBZLLl5lt5izfg2b
	xeVzhxktLi+8xGpxedccNov9nR2MDmweeyaeZPO4c20Pm8eJGb9ZPPq2rGL0mD7vJ5PH501y
	AWxRXDYpqTmZZalF+nYJXBmHl09nLtjAVrFtyw+mBsbFrF2MHBwSAiYSX64odDFyApliEhfu
	rWfrYuTiEBJYxijx8uVyVoiEiUTPtRWsEIlFjBLfV89jAUkICfxilNj7mR/EZhNQk/jy5TA7
	yFARAX2JthYNkHpmgb2MEltezYaqt5WYOO0rE4jNKWAnsebzMjBbWMBB4uLGSUwgvSwCqhI3
	bnCAhHmBys83H2KGsAUlfky+BzaGWUBLYvO2JlYIW15i85q3zBC/qEs8+qsLEhYRMJJYdm8Z
	M0SJiMS+F+8YIV75yC6xfa8+iM0iICDxbfIhFohWWYlNB5ghSiQlDq64wTKBUWIWksWzkCye
	hWTxLCQbFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIidveHYy3D1gfYkwGWj+RWUo0
	OR8Y93kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YDziyBUm/MSu9NLFZZHxWt9VqvkNN1jo5N/+591SyeRQvTalv6MxeP2p7sxnS4IzboVOcclW
	b/jbbvZqyZXLekuXH1PzSCr/OyXk1Pu7TdrHnrMr7r/Js7s68QHzh8LIsC/GjyRjih/P+jH1
	XR8Pw153/3P+ZgduMUoli7poh5tJHbrUeHjKTiWW4oxEQy3mouJEAJ2WdvDxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd1eHocggx1XmC2WXLzKbjFn/Ro2
	i8vnDjNaXF54idXi8q45bBb7OzsYHdg89kw8yeZx59oeNo8TM36zePRtWcXoMX3eTyaPz5vk
	AtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHF4+nblgA1vFti0/mBoY
	F7N2MXJySAiYSPRcWwFli0lcuLeerYuRi0NIYBGjxPfV81hAEkICvxgl9n7mB7HZBNQkvnw5
	zN7FyMEhIqAv0daiAVLPLLCXUWLLq9lQ9bYSE6d9ZQKxOQXsJNZ8XgZmCws4SFzcOIkJpJdF
	QFXixg0OkDAvUPn55kPMELagxI/J98DGMAtoSWze1sQKYctLbF7zlhmkVUJAXeLRX12QsIiA
	kcSye8uYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBCeGZ9I7GFc1WBxiFOBgVOLhjUy0DxJiTSwrrsw9xCjBwawkwuvH6hAkxJuSWFmV
	WpQfX1Sak1p8iDEZ6M+JzFKiyfnApJVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU
	7NTUgtQimC1MHJxSDYxGM3JLth7dmLz1fsuyix45J+32ivVsmrr3yMoMwY9HBDXVzipclpng
	tyt+7fTvR2xmB/gKbZ1lGGDZF7rB+8L5p+3PZLsttseFeRlU/j/6Z9HuC39YLBTent9aIX9w
	25ozwS8+btBTP/WH9c0l1uv11j+fLSzatepPprul36cFYtL3q9hnnr0Ur8RSnJFoqMVcVJwI
	AP+blBFQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-88pm860x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 4e30c85..81650484 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -316,7 +316,7 @@ static int pm860x_rtc_probe(struct platform_device *pdev)
 	unsigned long ticks = 0;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_rtc_info),
 			    GFP_KERNEL);
-- 
1.7.10.4


