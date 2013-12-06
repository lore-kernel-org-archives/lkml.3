Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3LFHMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:12:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63972 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3LFHMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:12:05 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-d6-52a178bfa330
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Robin Gong'" <b38343@freescale.com>,
        "'Axel Lin'" <axel.lin@ingics.com>,
        "'Tim Harvey'" <tharvey@gateworks.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
In-reply-to: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
Subject: [PATCH 5/6] regulator: pfuze100: use devm_regulator_register()
Date: Fri, 06 Dec 2013 16:11:58 +0900
Message-id: <000e01cef252$7423b3e0$5c6b1ba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yUb+lAqO9MkXdRJaD6VTAoDhw9gAAId0A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zY939FQuDDL7c47M4Mucrs0Xn5mOs
	FlMfPmGzuLzwEqvFtysdTBaXd81hs7h44hOzA7vHv8P9TB7neu6yeeycdZfdo+1nmcemVZ1s
	Hn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJVx+uVGloK/vBWnP81ib2C8wt3FyMkhIWAi0d03
	hRXCFpO4cG89WxcjF4eQwDJGibkTF7HBFC1oe8QEkVjEKLGtvZcdJCEk8ItR4tY3GxCbTUBN
	4suXw0BxDg4RAVWJ/6/cQeqZBe4wSqz8/gIsLiRgK7HqfjVIOaeAncSfo2+YQWxhAXeJv7uP
	gY1kAWp9P2cFE4jNC1T+cOFMNghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yg4yXEFCXePRX
	FyQsImAkcX3PJahyEYl9L94xQrzyl11ic6cHxCoBiW+TD7FAtMpKbDrADFEiKXFwxQ2WCYwS
	s5AsnoVk8Swki2ch2bCAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRkgsT9zBeP+A9SHG
	ZKD1E5mlRJPzgakgryTe0NjMyMLUxNTYyNzSjDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmp
	xYcYmTg4pRoY41xcdp88qJGRd7NQI1XgU51JsOTvS3PcTnZsn/xk5tpHPZw3Ds2te3lAYXvu
	74ZL1rsj3zL0WUwoZ26415Eu+PfbR45Ns7dLXOJuuTGdo23uzgaHFw5tj/28DpzK/R95+oVY
	EnPfFie+v65r1n2U+/127sfPxyQ1NU4/ayiKYU5UCtSztwnaosRSnJFoqMVcVJwIADWaG4L7	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jAd39FQuDDF5c4rI4Mucrs0Xn5mOs
	FlMfPmGzuLzwEqvFtysdTBaXd81hs7h44hOzA7vHv8P9TB7neu6yeeycdZfdo+1nmcemVZ1s
	Hn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/TLjSwF
	f3krTn+axd7AeIW7i5GTQ0LARGJB2yMmCFtM4sK99WxdjFwcQgKLGCW2tfeygySEBH4xStz6
	ZgNiswmoSXz5chgozsEhIqAq8f+VO0g9s8AdRomV31+AxYUEbCVW3a8GKecUsJP4c/QNM4gt
	LOAu8Xf3MbCRLECt7+esANvLC1T+cOFMNghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yg4yX
	EFCXePRXFyQsImAkcX3PJahyEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMGp4pn0DsZVDRaHGAU4GJV4eDlWLQgSYk0sK67MPcQowcGsJMLb
	I74wSIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgWksryTe0NjEzMjSyMzCyMTcnDRhJXHe
	g63WgUIC6YklqdmpqQWpRTBbmDg4pRoY04VunPy7KGfaPJ4Jk/73GdqLA80QdnYqc3nPM2PB
	NJ6lAhr7X/hkac/teHhrt/Aey2/3mgJy+2ssbsjWV9rqvTopdWjGLsvtWvPTQtcWX/Fv+nH5
	4GtTv7xHZX4mydc8eFtUBLw4ew5+nJPyr+TAiwxve1/LBxvvMQQ856jQjxCYGNjGz6PEUpyR
	aKjFXFScCAD0h7inWQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/pfuze100-regulator.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 032df37..50c1bf8 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -408,31 +408,18 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		config.driver_data = pfuze_chip;
 		config.of_node = match_of_node(i);
 
-		pfuze_chip->regulators[i] = regulator_register(desc, &config);
+		pfuze_chip->regulators[i] =
+			devm_regulator_register(&client->dev, desc, &config);
 		if (IS_ERR(pfuze_chip->regulators[i])) {
 			dev_err(&client->dev, "register regulator%s failed\n",
 				pfuze100_regulators[i].desc.name);
-			ret = PTR_ERR(pfuze_chip->regulators[i]);
-			while (--i >= 0)
-				regulator_unregister(pfuze_chip->regulators[i]);
-			return ret;
+			return PTR_ERR(pfuze_chip->regulators[i]);
 		}
 	}
 
 	return 0;
 }
 
-static int pfuze100_regulator_remove(struct i2c_client *client)
-{
-	int i;
-	struct pfuze_chip *pfuze_chip = i2c_get_clientdata(client);
-
-	for (i = 0; i < PFUZE100_MAX_REGULATOR; i++)
-		regulator_unregister(pfuze_chip->regulators[i]);
-
-	return 0;
-}
-
 static struct i2c_driver pfuze_driver = {
 	.id_table = pfuze_device_id,
 	.driver = {
@@ -441,7 +428,6 @@ static struct i2c_driver pfuze_driver = {
 		.of_match_table = pfuze_dt_ids,
 	},
 	.probe = pfuze100_regulator_probe,
-	.remove = pfuze100_regulator_remove,
 };
 module_i2c_driver(pfuze_driver);
 
-- 
1.7.10.4


