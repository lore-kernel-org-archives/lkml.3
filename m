Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3JNIvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:51:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9578 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3JNIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:51:53 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-67-525bb0a7b33c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 08/11] regulator: tps6105x: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:51:51 +0900
Message-id: <000701cec8ba$a01ed310$e05c7930$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAPsxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ90VG6KDDNqmMVpMffiEzeLywkus
	Ft+udDBZTPmznMni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CV0fN3MXvBebaKZ7/a2BoYd7F2MXJySAiYSEx784URwhaTuHBvPVsXIxeHkMAyRol7
	e1azwxS9/PwHzBYSWMQosXKiMoT9i1Gid7cpiM0moCbx5cthoBoODhEBVYn/r9xB5jALzGSU
	2Nm/gwmi3lbi7ulLzCA2p4CdxMJvu1hAbGEBB4lPExvA5rMA9bY+bgOr5wWqn/FmBSuELSjx
	Y/I9sHpmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBIYsrmg4wQJSIS+168YwS5R0Lg
	FrvEvi8ToXYJSHybfIgFoldWYtMBZoh3JSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRN
	LUguKE5KLzLVK07MLS7NS9dLzs/dxAiJ04k7GO8fsD7EmAy0fiKzlGhyPjDO80riDY3NjCxM
	TUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGFFzbu60MzaXauZd
	+R3o+a9jK2vr3fr3RtFOV1gu8lY/6eJd6fU39eC1qQoP/opM63tVeGna71P1d/ZabVox4d6v
	rMcPTMvF13V2K/+9cfBcTdRX5iMtOrxbfCI3/zxydcVR9w2974Ti+xY0dD5eL7Zi3YHoB4Eb
	OP1V5vXVngiM7sw5vmexT5wSS3FGoqEWc1FxIgArQWeR6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd3lG6KDDP5esbKY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaPn72L2gvNsFc9+tbE1MO5i7WLk5JAQMJF4
	+fkPO4QtJnHh3no2EFtIYBGjxMqJyhD2L0aJ3t2mIDabgJrEly+Hgeo5OEQEVCX+v3LvYuTi
	YBaYySixs38HE0S9rcTd05eYQWxOATuJhd92sYDYwgIOEp8mNoDtYgHqbX3cBlbPC1Q/480K
	VghbUOLH5Htg9cwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHElM0HGSFKRCT2vXjH
	OIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQngWdSOxhX
	NlgcYhTgYFTi4RVwig4SYk0sK67MPcQowcGsJMIrOA8oxJuSWFmVWpQfX1Sak1p8iDEZ6NGJ
	zFKiyfnABJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxz
	D+tHtRyIMuq2tzn35v3ZGJ8P+3WjH7wNtNRefnLFH6XU/4fPaZ9MKj357+wUoZoFlyyruX3a
	7ad82c6h6ntrlfb0bx+/ZIe/LGmO65J4tLv6ikPBjOlWdy1DrJj6P2v959iusOz3nCpu3n/s
	LEf51ZeU8nfkb357NuTZNN1XCyPD5t4J+vdDiaU4I9FQi7moOBEABzKaRkYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warning.

  WARNING: unnecessary whitespace before a quoted newline

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/tps6105x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index e0e818d..c1e33a3 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -137,7 +137,7 @@ static int tps6105x_regulator_probe(struct platform_device *pdev)
 	/* This instance is not set for regulator mode so bail out */
 	if (pdata->mode != TPS6105X_MODE_VOLTAGE) {
 		dev_info(&pdev->dev,
-			 "chip not in voltage mode mode, exit probe \n");
+			"chip not in voltage mode mode, exit probe\n");
 		return 0;
 	}
 
-- 
1.7.10.4


