Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967641Ab3DSABK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 20:01:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48281 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967466Ab3DSABI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:01:08 -0400
X-AuditID: cbfee68e-b7f946d000001e37-4a-517089419a6e
Date: Fri, 19 Apr 2013 00:01:05 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH]  I2C: Change the value of octeon i2c adapter timeout value
To: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130418235934899@eunb.song
Msgkey: 20130418235934899@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130418235934899@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <22387590.3491366329664571.JavaMail.weblogic@epv6ml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zpq5jZ0GgQctGA4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx/dchloJLbBXnJ+1jb2DcwdbFyMkhJKAi0fL/OyOILSFgIrFx
	yUM2CFtM4sK99UA2F1DNMkaJr8v2wRW9X/KRCSIxn1Fi+f8XLCAJFgFVicc3TrGC2GwC2hJv
	vzwAs4UFvCUOXf7HDGKLCKRJ3J7SCzaIWcBR4tHlO8wQV8hLTD59mR3E5hUQlDg58wkLxDIl
	iVfvzkPFlSUezDsGdYSExKzpF1ghbF6JGe1PoerlJKZ9XcMMYUtLnJ+1gRHmm8XfH0PF+SWO
	3d4B9AAHWO+T+8EwY3Zv/gL1vIDE1DMHoVrVJTa9XwK1ik9izcK3LDBjdp1azgzTe3/LXCaI
	txQlpnQ/ZIewtSS+/NjHhu4tXgEniafbFrNPYFSehSQ1C0n7LCTtyGoWMLKsYhRNLUguKE5K
	LzLSK07MLS7NS9dLzs/dxAhJDH07GG8esD7EmAyMkonMUqLJ+cDEklcSb2hsZmRhamJqbGRu
	aUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRpcvipKnnE8z3zgmZvbV36ud
	48XhtyIRrJHukfJfX2nv+veNVS1j15++iAu7HNxnFpzfKdNrNDFz+YYN99RCNW2TN6loRqvX
	xe4SOj9BcGm6vcqsrCO6lksaK5jCHt2QD1/loiXuXZTw0X5etlpAgEqBkeO2uOv/NLeniHSa
	HN5obfVKY2q0EktxRqKhFnNRcSIAuPnXQiIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TF3HzoJAg9d7dS0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xvVfh1gKLrFVnJ+0j72BcQdbFyMnh5CAikTL/++MILaEgInE+yUfmSBsMYkL99YD1XAB1cxn
	lFj+/wULSIJFQFXi8Y1TrCA2m4C2xNsvD8BsYQFviUOX/zGD2CICaRK3p/SCDWUWcJR4dPkO
	M8QyeYnJpy+zg9i8AoISJ2c+YYFYpiTx6t15qLiyxIN5x6AOkpCYNf0CK4TNKzGj/SlUvZzE
	tK9rmCFsaYnzszYwwhy9+PtjqDi/xLHbO4Ce4QDrfXI/GGbM7s1f2CBsAYmpZw5CtapLbHq/
	BGoVn8SahW9ZYMbsOrWcGab3/pa5TBBvKUpM6X7IDmFrSXz5sY8N3Vu8Ak4ST7ctZp/AKDcL
	SWoWkvZZSNqR1SxgZFnFKJpakFxQnJReYahXnJhbXJqXrpecn7uJEZyini3cwfjlvPUhRgEO
	RiUe3htSBYFCrIllxZW5hxglOJiVRHinJwGFeFMSK6tSi/Lji0pzUosPMSYDI3Ais5Rocj4w
	feaVxBsaGxgbGlqaG5gaGlmQJqwkzvu01TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OhHyc8z87d
	6/9f3XFKl3Kz4uRroVyHdawWXGVISDih2fFIa84OdoaiqpU+tv0/KrcfWWWgWW0f3Lv/h51d
	gJzRlt0W2hWs0vdaeiojjVqjfVTvO3Px7gj48iX0osKngtLm7rYbLxN0u1NMnN5Jn7HwLk65
	NodnJ9vcy6/Zjsu1zPdd9XDuTCWW4oxEQy3mouJEAISp2+iVAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3J01GsO020693


I think HZ/50 is better than 2 for adapter timeout.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 drivers/i2c/busses/i2c-octeon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 935585e..ca489f3 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -440,7 +440,7 @@ static struct i2c_adapter octeon_i2c_ops = {
 	.owner = THIS_MODULE,
 	.name = "OCTEON adapter",
 	.algo = &octeon_i2c_algo,
-	.timeout = 2,
+	.timeout = HZ/50,
 };
 
 /**
-- 
1.7.0.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
