Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbaHZNAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:00:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaHZNAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:00:12 -0400
X-AuditID: cbfee690-f79ce6d00000115a-44-53fc84dbc9c1
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 10/18] backlight: lms501kf03: remove 'else' after a return
Date: Tue, 26 Aug 2014 22:00:11 +0900
Message-id: <00b401cfc12d$ab9f59f0$02de0dd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAHlbw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ93bLX+CDWYsUrY4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDK2P17J
	XvCeo6Lr0V6mBsZl7F2MnBwSAiYSR7a1MULYYhIX7q1n62Lk4hASWMYosbD9GhNMUf/hPqjE
	dEaJ2zsWsUI4vxklDp3ZzwxSxSagJvHly2GwsSICChKbe5+xgtjMArkSv2euBFshJGArMX/b
	CrA4p4CdxNLD58DqhQW8JG7s+AC2jUVAVeLIo042EJsXqH7v7hksELagxI/J91ggZmpJrN95
	nAnClpfYvOYt0A0cQJeqSzz6qwtxgpHEhY+noUpEJPa9eAf15TF2iad/MyFWCUh8m3yIBaJV
	VmLTAWaIEkmJgytusExglJiFZPEsJItnIVk8C8mGBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1
	kvNzNzFConLCDsZ7B6wPMQpwMCrx8N6I/x0sxJpYVlyZe4jRFOiiicxSosn5wNjPK4k3NDYz
	sjA1MTU2Mrc0UxLnfS31M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDI3es2a8QndvS2nF+
	vNPN2DacrWLb+Tr4mt672Z6va07/3bj8bLTwTdZJzgcN9j48U7Pq7kafoPBFOxgc5z35Mruw
	/+9mLYcvgScnb1mQZ8X81bou9UDIYcEXm7Nmcy2avoL7/VPeWzYLkpyPnlVI7Ra9ceWK0P52
	679T/DOi+0pO+3p4bp5/YL8SS3FGoqEWc1FxIgD4tPUMxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd3bLX+CDW6flLc4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgztj9eyV7wnqOi69FepgbGZexdjJwcEgImEv2H+9ggbDGJC/fW
	A9lcHEIC0xklbu9YxArh/GaUOHRmPzNIFZuAmsSXL4fBukUEFCQ29z5jBbGZBXIlfs9cyQhi
	CwnYSszftgIszilgJ7H08DmwemEBL4kbOz4wgdgsAqoSRx51gm3mBarfu3sGC4QtKPFj8j0W
	iJlaEut3HmeCsOUlNq95C3QDB9Cl6hKP/upCnGAkceHjaagSEYl9L94xTmAUmoVk0iwkk2Yh
	mTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFR/0x6B+OqBotDjAIcjEo8vDfi
	fwcLsSaWFVfmHmKU4GBWEuH9kfQnWIg3JbGyKrUoP76oNCe1+BCjKdCjE5mlRJPzgQkpryTe
	0NjEzMjSyMzCyMTcXEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QD45SCWiGvc4/WTVo6r+PT
	9pwjKcJZZu/d3h67EqrrmW//c+7ShOmzLqeYf2cM4LupqZG8/J3N4j2MHDyM/5j22M/5fLyp
	WClSNUjXOZ83PaHr1s0V58wEy/tmHhZm3Xkznane3KZ+/RmWo/cKjt5Udd5k+MZHbNXDjzd/
	yVzcVndUv33pzcNat5VYijMSDbWYi4oTAZjVRQAQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms501kf03.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
index 77258b7b04be..7e3810308c3e 100644
--- a/drivers/video/backlight/lms501kf03.c
+++ b/drivers/video/backlight/lms501kf03.c
@@ -232,19 +232,19 @@ static int lms501kf03_power_on(struct lms501kf03 *lcd)
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
 		return -EINVAL;
-	} else {
-		pd->power_on(lcd->ld, 1);
-		msleep(pd->power_on_delay);
 	}
 
+	pd->power_on(lcd->ld, 1);
+	msleep(pd->power_on_delay);
+
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
 		return -EINVAL;
-	} else {
-		pd->reset(lcd->ld);
-		msleep(pd->reset_delay);
 	}
 
+	pd->reset(lcd->ld);
+	msleep(pd->reset_delay);
+
 	ret = lms501kf03_ldi_init(lcd);
 	if (ret) {
 		dev_err(lcd->dev, "failed to initialize ldi.\n");
-- 
2.0.0


