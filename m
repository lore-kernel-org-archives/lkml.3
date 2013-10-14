Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3JNIws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:52:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53670 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3JNIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:52:47 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-1b-525bb0de135c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
In-reply-to: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com>
Subject: [PATCH 09/11] regulator: tps65023: Fix checkpatch issue
Date: Mon, 14 Oct 2013 17:52:45 +0900
Message-id: <000801cec8ba$c08d21b0$41a76510$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IuZK01KcLw1AZSDCREfGxHfkpOgAAQ6CA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY917G6KDDC6d4bOY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpsDi8fOWXfZPTat6mTz6NuyitHj8ya5AJYoLpuU1JzMstQifbsEroytU/qZ
	C9awVSztOcXUwLiatYuRk0NCwESicc9WZghbTOLCvfVsXYxcHEICyxglHs6bwgZTtP7XUnaI
	xCJGiQszpzJDOL8YJf4+O8gEUsUmoCbx5cthoCoODhEBVYn/r9xBTGaBXInubekgFUICthJ3
	T18CW8YpYCex8NsuFhBbWMBBYu3jKWA2C1Dnmglv2EFsXqD6TUv2MEHYghI/Jt8Dq2EW0JJY
	v/M4E4QtL7F5zVtmkFUSAuoSj/7qgoRFBIwkjsxtgCoXkdj34h0jyMUSAufYJR6teckMsUtA
	4tvkQywQvbISmw5Aw0FS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiU73i
	xNzi0rx0veT83E2MkJicuIPx/gHrQ4zJQOsnMkuJJucDYzqvJN7Q2MzIwtTE1NjI3NKMNGEl
	cV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxldy4UqeWIfeO+GsKv5tN/sM18i5tF
	uapkoZ9Dx/4D33K6FP8t1juas32PTMT7uYKqmZz3drxbFV8T/lrMu9pwf/LGp6eb474x7qzY
	eHeLe6TnXZvjmx/echJd9SPj0MbQwHUV/n2b2uZMXG51V/3uhUczRdxKZwhqLvMyvL+KVTqi
	5fL+X8+UWIozEg21mIuKEwFfFhn23wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd17G6KDDL61cltMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG1in9zAVr2CqW9pxiamBczdrFyMkhIWAisf7XUnYIW0ziwr31
	bF2MXBxCAosYJS7MnMoM4fxilPj77CATSBWbgJrEly+HgTo4OEQEVCX+v3IHMZkFciW6t6WD
	VAgJ2ErcPX2JGcTmFLCTWPhtFwuILSzgILH28RQwmwWoc82EN2B7eYHqNy3ZwwRhC0r8mHwP
	rIZZQEti/c7jTBC2vMTmNW+ZQVZJCKhLPPqrCxIWETCSODK3AapcRGLfi3eMExiFZiGZNAvJ
	pFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDEP5PewbiqweIQowAHoxIP
	r4BTdJAQa2JZcWXuIUYJDmYlEV7BeUAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcmo7yS
	eENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYExdfzZ7zowYAdXY
	6cFZ16WnZ3O/OnNxB8fup7vuX1miIyN8kzP+3tbTk9RWXb+61OzXjWqVP1ZPPk9TPONYtclK
	68ziZXppB9V6LtnH3725W9X2c/xzj91CU/9ZLb5oubt0x8Faz/eFimov5GWO8LiXajxPTvoW
	Yd7DrzKP57kgQ8z9m/fU109RYinOSDTUYi4qTgQAGM5ICjwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warning.

  WARNING: line over 80 characters

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/tps65023-regulator.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index a957579..3ef67a8 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -293,7 +293,8 @@ static int tps_65023_probe(struct i2c_client *client,
 
 	/* Enable setting output voltage by I2C */
 	regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
-			TPS65023_REG_CTRL2_CORE_ADJ, TPS65023_REG_CTRL2_CORE_ADJ);
+					TPS65023_REG_CTRL2_CORE_ADJ,
+					TPS65023_REG_CTRL2_CORE_ADJ);
 
 	return 0;
 }
-- 
1.7.10.4


