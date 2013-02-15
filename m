Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935370Ab3BOGCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:02:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43747 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3BOGCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:02:04 -0500
X-AuditID: cbfee68e-b7fc26d000001938-8b-511dcf5bee39
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 08/11] rtc: rtc-vr41xx: use dev_info() instead of printk()
Date: Fri, 15 Feb 2013 15:02:02 +0900
Message-id: <001901ce0b41$f9a912b0$ecfb3810$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAJs7Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ93o87KBBmsfCVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MHcuXshe8Y624crmRuYHxNUsXIyeHhICJxKJHp5ggbDGJC/fW
	s3UxcnEICSxjlLg++R07TNHl78eZIBKLGCWmr9nDCJIQEpjNJDHjdCCIzSagJvHly2GgBg4O
	EQF9ibYWDZB6ZoFeRokzvbvZIeptJSZ8WscMYnMK2El8//OQDcQWFvCSOPTyPiuIzSKgKjGh
	6yLYdbxA9WumNrNC2IISPybfA4szC2hJbN7WxAphy0tsXvOWGWSvhIC6xKO/uiBhEQEjiZ37
	V0CViEjse/GOEeQeCYFl7BIHrt1lgtglIPFt8iEWiF5ZiU0HmCH+lZQ4uOIGywRGiVlINs9C
	snkWks2zkKxYwMiyilE0tSC5oDgpvchIrzgxt7g0L10vOT93EyMksvp2MN48YH2IMRlo/URm
	KdHkfGBk5pXEGxobm5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QD47pLNfnnskxn3ng8a3mO/rYXDrcTDn3bdDNRdbrzBsX7/NtcucX75OrsDZPVOZUehE04
	Z68xQVDGozHh3KHtle4XIt5mc/duvPZW/NKxhcf3ZOx57/ze6O6TtraJL3UuHZ4uLlwRnn70
	wqGin/z+iheKJilPWnz3o+il/9rGf/TDTQ+3+sRd+aLEUpyRaKjFXFScCACS9XvfwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG70edlAg5XbuCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxo7lS9kL3rFWXLncyNzA
	+Jqli5GTQ0LAROLy9+NMELaYxIV769m6GLk4hAQWMUpMX7OHESQhJDCbSWLG6UAQm01ATeLL
	l8PsXYwcHCIC+hJtLRog9cwCvYwSZ3p3s0PU20pM+LSOGcTmFLCT+P7nIRuILSzgJXHo5X1W
	EJtFQFViQtdFsCN4gerXTG1mhbAFJX5MvgcWZxbQkti8rYkVwpaX2LzmLTPIXgkBdYlHf3VB
	wiICRhI796+AKhGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRHLfPpHYwrmywOMQowMGoxMMrICEbKMSaWFZcmXuIUYKDWUmEd00IUIg3JbGy
	KrUoP76oNCe1+BBjMtCjE5mlRJPzgSklryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNL
	UrNTUwtSi2C2MHFwSjUwBpzuPy/lYfX42pqGdCvV6rINFidXvZIJqbnoEL5G6EPtST47z50X
	n67JE/72fvJR5hdOl/9qXV3jpyIh+qfy/MP9lc8WTWLtvzAldkmKAs86FVGhEu4K8/zzxbt0
	bL4+fbosJKoqwMHyOcvaD4c09Lcc4FY8bZ9XPf/E8g09PFrV+7/4+n3bocRSnJFoqMVcVJwI
	AIvmVgMfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-vr41xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 6c3774c..f91be04 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -352,7 +352,7 @@ static int rtc_probe(struct platform_device *pdev)
 	disable_irq(aie_irq);
 	disable_irq(pie_irq);
 
-	printk(KERN_INFO "rtc: Real Time Clock of NEC VR4100 series\n");
+	dev_info(&pdev->dev, "Real Time Clock of NEC VR4100 series\n");
 
 	return 0;
 
-- 
1.7.2.5


