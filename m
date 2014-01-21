Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaAUJD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:03:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56137 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaAUJDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:03:21 -0500
X-AuditID: cbfee690-b7f266d00000287c-f5-52de37d7aa7e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] Documentation: devicetree: mct: Fix counter bit of CPU local
 timers
Date: Tue, 21 Jan 2014 18:03:19 +0900
Message-id: <000001cf1687$a0e5e250$e2b1a6f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8Wh6CHvecSL6aTSbyl5f0jq8u5rg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zY93r5veCDGbOVbGY91nW4vLCS6wW
	vQuuslksbFvCYnF51xw2ixnn9zFZrJ/xmsVi86apzBbHZixhdOD0uHNtD5vHu3Pn2D36tqxi
	9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/RKh4JHnBU9uy+wNTAu4uhi5OSQEDCR6P0wmx3CFpO4
	cG89WxcjF4eQwDJGialXdjPDFL37cpwZIrGIUaLh10FGCOcXo8SSlgmsIFVsAmoSX74cBhsl
	ImAg8fr0b3aQImaBVUwS77adBysSFgiTeP/xLAuIzSKgKnHt9lImEJtXwFZi0ux7jBC2oMSP
	yffAapgFtCQ2b2tihbDlJTaveQt0BgfQSeoSj/7qQuzSk3ix7D4TRImIxL4X78COkxC4xS7x
	6zNEgkVAQOLb5EMsEL2yEpsOQH0mKXFwxQ2WCYxis5BsnoVk8ywkm2chWbGAkWUVo2hqQXJB
	cVJ6kYlecWJucWleul5yfu4mRkhcTtjBeO+A9SHGZKD1E5mlRJPzgXGdVxJvaGxmZGFqYmps
	ZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M/ufmfjQQVCrW/ybve/6v
	0fy8lV02CXYHznU6Bvp8aNu/RyTtf5ht3fOMZW9X33udr7E0eJlTisrlnl1OxyckHVBe/6NK
	2y5+zq3AxvUtX+cdOX5gQeWRsAcqu+/3zE88mLQvpPbRvNa1DqpTnjBbZAa9Siv8+SZazOkZ
	/6d9TtkrqiwqVX0rlFiKMxINtZiLihMB5bAQfuECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd3r5veCDPo/yFvM+yxrcXnhJVaL
	3gVX2SwWti1hsbi8aw6bxYzz+5gs1s94zWKxedNUZotjM5YwOnB63Lm2h83j3blz7B59W1Yx
	enzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeP0SoeCR5wVPbsv
	sDUwLuLoYuTkkBAwkXj35TgzhC0mceHeerYuRi4OIYFFjBINvw4yQji/GCWWtExgBaliE1CT
	+PLlMDuILSJgIPH69G92kCJmgVVMEu+2nQcrEhYIk3j/8SwLiM0ioCpx7fZSJhCbV8BWYtLs
	e4wQtqDEj8n3wGqYBbQkNm9rYoWw5SU2r3kLdBIH0EnqEo/+6kLs0pN4sew+E0SJiMS+F+8Y
	JzAKzEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCofya1g3Fl
	g8UhRgEORiUe3sqNd4OEWBPLiitzDzFKcDArifBOVrwXJMSbklhZlVqUH19UmpNafIgxGejR
	icxSosn5wISUVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M
	ZXcKFW9M41U7+VfsuLrO3QNtQj8mLl5TIcrZuJ4lITc2uUt50tb5Jzsznm16t2JTZ2nk7VNW
	OQaFF+yk3/4zcZk/JclgVkLaHS23BH2ju292pCxVX3IgQ+Wuy6p7+T/iNl9qL/vW9Dtd7Nak
	cIao7+uKJ8xaIvPgiMXBtkYjR46rwvyhMyK1lViKMxINtZiLihMBBI2H4j4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet of Exynos SoCs, the counter bit
of CPU local timers is 31-bit, not 32-bit; thus, it should
be fixed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
index 167d5da..8c77791 100644
--- a/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
+++ b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
@@ -3,7 +3,7 @@ Samsung's Multi Core Timer (MCT)
 The Samsung's Multi Core Timer (MCT) module includes two main blocks, the
 global timer and CPU local timers. The global timer is a 64-bit free running
 up-counter and can generate 4 interrupts when the counter reaches one of the
-four preset counter values. The CPU local timers are 32-bit free running
+four preset counter values. The CPU local timers are 31-bit free running
 down-counters and generate an interrupt when the counter expires. There is
 one CPU local timer instantiated in MCT for every CPU in the system.
 
-- 
1.7.10.4


