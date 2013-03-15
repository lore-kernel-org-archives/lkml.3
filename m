Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3COJOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:14:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31905 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3COJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:14:49 -0400
X-AuditID: cbfee690-b7f656d0000007e3-35-5142e6871967
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
In-reply-to: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
Subject: [PATCH 2/6] gpio: max7300: use devm_kzalloc()
Date: Fri, 15 Mar 2013 18:14:46 +0900
Message-id: <006301ce215d$89e9d040$9dbd70c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXW7HXikowtUaTheLztVYvIsx2AAABA3Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY932Z06BBteei1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MR8sVC26wVWya85W1gXEnaxcjJ4eEgInErJkfWCBsMYkL99az
	dTFycQgJLGOUuPDzD1zRq4tn2CESixgl/n1YwQzhzGaSOLS/DaydTUBN4suXw+wgtoiAnsSN
	Cx2MIDazQJHE865ZYJOEBGwljlz/BFbPKWAn8WxdH1hcWMBMYsvGLrB6FgFViT0b9wHZHBy8
	QPWTH0aBhHkFBCV+TL7HAjFSS2L9zuNMELa8xOY1b5lByiUE1CUe/dWFuMBIYvbuV6wQJSIS
	+168YwQ5WUJgHrvE44fLoVYJSHybfIgFoldWYtMBZoh/JSUOrrjBMoFRYhaSzbOQbJ6FZPMs
	JCsWMLKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiJqwk7GO8dsD7EmAy0fiKzlGhyPjAu
	80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6FPX
	ce3Cq9MJHNPvbim5/1fgiSb/twidM9ZsXY4+rcZmfqEa3xItAsM2P87qNv1kLnYntPXd1ts+
	nf6xFxgi51/gcy5cxbm3Wu1D1fOKe2I71hhzysTVrdwpzbz41ZrT38UPP15kKr3uUw5X3d4D
	HWGPdmgWZfgZH54tkvzL7Ybeo/M62/YeUGIpzkg01GIuKk4EAMdGgtfBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG77M6dAg5ONQhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49FyxYIbbBWb5nxlbWDc
	ydrFyMkhIWAi8eriGXYIW0ziwr31bF2MXBxCAosYJf59WMEM4cxmkji0v40FpIpNQE3iy5fD
	YB0iAnoSNy50MILYzAJFEs+7ZoFNFRKwlThy/RNYPaeAncSzdX1gcWEBM4ktG7vA6lkEVCX2
	bNwHZHNw8ALVT34YBRLmFRCU+DH5HgvESC2J9TuPM0HY8hKb17xlBimXEFCXePRXF+ICI4nZ
	u1+xQpSISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECI7aZ1I7GFc2WBxiFOBgVOLhPdDvECjEmlhWXJl7iFGCg1lJhNfTyzFQiDclsbIqtSg/
	vqg0J7X4EGMy0J8TmaVEk/OBCSWvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2amp
	BalFMFuYODilGhiDuXvSa1NrBCbukui409+mlDTrnNLLs7YRr9SKdj1WC0j1Sz/lH2bQPD/1
	ZJZ+k0zGDuHZ0mIqn+7cKvIxFDyVtS8+vOLYypUsVsrTTN3WiG6qerYkgCOW3dH18ee6dvcT
	1nf7d8ubhxszLIg7+MCzepaZ3/2bJs47ORfH1x46KxdisSpxjxJLcUaioRZzUXEiAPvvrdMe	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-max7300.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-max7300.c b/drivers/gpio/gpio-max7300.c
index 4b6b9a0..40ab6df 100644
--- a/drivers/gpio/gpio-max7300.c
+++ b/drivers/gpio/gpio-max7300.c
@@ -41,7 +41,7 @@ static int max7300_probe(struct i2c_client *client,
 			I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
+	ts = devm_kzalloc(&client->dev, sizeof(struct max7301), GFP_KERNEL);
 	if (!ts)
 		return -ENOMEM;
 
@@ -50,8 +50,6 @@ static int max7300_probe(struct i2c_client *client,
 	ts->dev = &client->dev;
 
 	ret = __max730x_probe(ts);
-	if (ret)
-		kfree(ts);
 	return ret;
 }
 
-- 
1.7.2.5


