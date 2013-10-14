Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3JNIzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:55:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37452 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3JNIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:55:07 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-43-525bb169362e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@linaro.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Balaji T K'" <balajitk@ti.com>,
        "'Nishanth Menon'" <nm@ti.com>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 11/11] regulator: twl: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:55:05 +0900
Message-id: <000a01cec8bb$13bf5970$3b3e0c50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAU+bw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zI93MjdFBBq+7jCymTt7OZrHp+nVW
	i8sLL7FafLvSwWRxedccNos3P84yObB57Jx1l93jzrU9bB59W1Yxehy/sZ3J4/MmuQDWKC6b
	lNSczLLUIn27BK6M/p0aBY0cFS0re5gaGA+ydTFyckgImEj0HTrGCmGLSVy4tx4ozsUhJLCM
	UeLNqjfsMEUr3/VDJaYzSnzedJcRwvnFKPGpbzkTSBWbgJrEly+HwTpEBFQl9jx/AmYzC6xl
	lJjT7Q1iCwnYStw9fYkZxOYUsJNY+G0XC4gtLGAtsW7ZcbAzWIB6J6z6A9bLC1R/pGc2E4Qt
	KPFj8j0WiJlaEut3HmeCsOUlNq95CzSTA+hSdYlHf3UhTjCSeLp0IlS5iMS+F+/AbpYQuMUu
	sel+JxPELgGJb5MPsUD0ykpsOsAM8bCkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkF
	yQXFSelFhnrFibnFpXnpesn5uZsYITHbu4Px9gHrQ4zJQOsnMkuJJucDYz6vJN7Q2MzIwtTE
	1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxrIxwMDsnmXQo+37Ry
	arGZ1NeiBbPEEqJqGTdeskls1i5bKSzKrz+tpOkB9zWzzWuaLl+a9PSiJu/CXSd1jfhr/Ty/
	WEZy5bi5y+ip1CU5dmn/fKiaIPYqYuKRO4tVBXY0Wq1zOLtFQ2yBleD1afnFl0MN1svtcU5+
	Jq2ZvuvSPe1nzBnxHkosxRmJhlrMRcWJAGd3VinvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQd3MjdFBBhMX6VlMnbydzWLT9eus
	FpcXXmK1+Halg8ni8q45bBZvfpxlcmDz2DnrLrvHnWt72Dz6tqxi9Dh+YzuTx+dNcgGsUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM/p3ahQ0clS0rOxhamA8yNbFyMkh
	IWAisfJdP5QtJnHh3nogm4tDSGA6o8TnTXcZIZxfjBKf+pYzgVSxCahJfPlymB3EFhFQldjz
	/AmYzSywllFiTrc3iC0kYCtx9/QlZhCbU8BOYuG3XSwgtrCAtcS6ZcdZQWwWoN4Jq/6A9fIC
	1R/pmc0EYQtK/Jh8jwVippbE+p3HmSBseYnNa94CzeQAulRd4tFfXYgTjCSeLp0IVS4ise/F
	O8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOCE8k97B
	uKrB4hCjAAejEg+vgFN0kBBrYllxZe4hRgkOZiURXsF5QCHelMTKqtSi/Pii0pzU4kOMyUCP
	TmSWEk3OByarvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	VHGP8nl9beOfO76iDIsWnlHPv5Ijofz44Hp/1usakdXeDPNv1ORIn2VKTeE44c6UuWhfnUJP
	28v8AF6jnr8fPD7EvjywsMk07dUq/XuV9je3ZDEEZ5rfkKrf6e+SZ56ieLXAah2vzaOl3LPm
	9e9Rvsg6cUL345Zl5iqb3672PX1T6tek0qRzSizFGYmGWsxFxYkAFY1gdEwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings.

  WARNING: please, no space before tabs
  WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/twl-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 8ebd785..fed28ab 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -58,7 +58,7 @@ struct twlreg_info {
 	struct regulator_desc	desc;
 
 	/* chip specific features */
-	unsigned long 		features;
+	unsigned long		features;
 
 	/*
 	 * optional override functions for voltage set/get
@@ -1128,7 +1128,7 @@ static int twlreg_probe(struct platform_device *pdev)
 	if (!initdata)
 		return -EINVAL;
 
-	info = kmemdup(template, sizeof (*info), GFP_KERNEL);
+	info = kmemdup(template, sizeof(*info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
-- 
1.7.10.4


