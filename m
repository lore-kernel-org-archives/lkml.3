Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbaD2I1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:27:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12934 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbaD2I1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:27:05 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-e3-535f6257b6f5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Magnus Damm'" <damm@opensource.se>
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
In-reply-to: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
Subject: [PATCH 2/4] clocksource: sh_cmt: remove unnecessary OOM messages
Date: Tue, 29 Apr 2014 17:27:03 +0900
Message-id: <002e01cf6384$cc7ef920$657ceb60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9jhHgACh38PpSJS1ewNnY0fIuPzwAADBWg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA93wpPhgg4VLtC3uP77FZDHvs6zF
	5YWXWC0u75rDZrF501RmB1aPO9f2sHm8O3eO3WPlj0vsHn1bVjF6fN4kF8AaxWWTkpqTWZZa
	pG+XwJWxYWYvW8En1oqHu4+wNzA+Zeli5OSQEDCROLeqgxHCFpO4cG89G4gtJLCMUWJysxtM
	zd0f81i7GLmA4tMZJebMm84O4fxmlHg+5RozSBWbgJrEly+H2UFsEQEDidenf4MVMQtMYpS4
	dnUhI8RYW4kJJ26CreAUsJOYc2QfkM3BISzgKfFucRFImEVAVaLx40cmEJsXqPzyorksELag
	xI/J98BsZgEtifU7jzNB2PISm9e8ZQYZIyGgLvHory7ECUYST5/NZYUoEZHY9+IdI8g5EgL3
	2CXuX33DBrFLQOLb5EMsEL2yEpsOMEM8LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNo
	akFyQXFSepGJXnFibnFpXrpecn7uJkZInE7YwXjvgPUhxmSg9ROZpUST84FxnlcSb2hsZmRh
	amJqbGRuaUaasJI4r9qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjBkTHR7+3sqrotf+
	SDZe+fp1AZupq2f0R0bG319n/EhSPyH0qPuV+5l9Vo8qDzkK1PSmFipcjHksMJnzUGZE32G2
	pYaTZM1i9Q4VFQSvPH36w/u2m9c5D8+a98Byn3VD6DHhT+ndBzWM1CQ0jWudLVICZk8/XPXi
	9303lcMGPJczTOMbUiOPKbEUZyQaajEXFScCAMrGB+TpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd3wpPhgg7tH1C3uP77FZDHvs6zF
	5YWXWC0u75rDZrF501RmB1aPO9f2sHm8O3eO3WPlj0vsHn1bVjF6fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWFmL1vBJ9aKh7uPsDcwPmXpYuTkkBAwkbj7
	Yx4rhC0mceHeerYuRi4OIYHpjBJz5k1nh3B+M0o8n3KNGaSKTUBN4suXw+wgtoiAgcTr07/B
	ipgFJjFKXLu6kBEkISRgKzHhxE02EJtTwE5izpF9QDYHh7CAp8S7xUUgYRYBVYnGjx+ZQGxe
	oPLLi+ayQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhlkjISAusSjv7oQJxhJPH02lxWiRERi
	34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwGngm
	vYNxVYPFIUYBDkYlHt6OmLhgIdbEsuLK3EOMEhzMSiK8+VbxwUK8KYmVValF+fFFpTmpxYcY
	k4EencgsJZqcD0xReSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXA6BQs9e7wlugugxhJl+PLPz34524Zn37kzdPGPVdD1nLMTp2Q9z1S9YcN+8s/+UebvYRe
	h1Ur/WiNrLA5ZMVVGdRXGSYnX/hdLLP/IkfPY8Zc+d4VdX/vPPX4OSlHP2pDfBlbuRvrxnm8
	QUb83QkVisaaMta8Uy8fmjDxi9Slr3tXTkvr5pymxFKckWioxVxUnAgA2qVDJEcDAAA=
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
 drivers/clocksource/sh_cmt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 0b1836a..d2aa209 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -824,10 +824,8 @@ static int sh_cmt_probe(struct platform_device *pdev)
 	}
 
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p == NULL) {
-		dev_err(&pdev->dev, "failed to allocate driver data\n");
+	if (p == NULL)
 		return -ENOMEM;
-	}
 
 	ret = sh_cmt_setup(p, pdev);
 	if (ret) {
-- 
1.7.10.4


