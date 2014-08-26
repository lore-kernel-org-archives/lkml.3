Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbaHZNBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:01:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32511 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559AbaHZNBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:01:50 -0400
X-AuditID: cbfee690-f79ce6d00000115a-c1-53fc853cfe65
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 15/18] backlight: wm831x_bl: add blank line after declarations
Date: Tue, 26 Aug 2014 22:01:48 +0900
Message-id: <00b901cfc12d$e5901d70$b0b05850$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAALMcw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI12b1j/BBkdnGVgc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBndUysK
	7rFWrJn9ka2B8TNLFyMnh4SAicTzr0uZIGwxiQv31rN1MXJxCAksY5TonvKDFaZoc9tWJojE
	dEaJoys+sEI4vxkljq9YClbFJqAm8eXLYXYQW0RAQWJz7zOwOLNArsTvmSsZQWwhAVuJ+dtW
	gMU5Bewklh4+B1YvLOAn0fT0PlgNi4CqxPqGd2An8QLVT126iRHCFpT4MfkeC8RMLYn1O48z
	QdjyEpvXvGXuYuQAulRd4tFfXYgTjCTuHJgOdYKIxL4X7xhBbpYQOMYucXTNLCaIXQIS3yYf
	YoHolZXYdIAZ4mFJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLTPSKE3OL
	S/PS9ZLzczcxQqJywg7GewesDzEKcDAq8fDeiP8dLMSaWFZcmXuI0RTooonMUqLJ+cDYzyuJ
	NzQ2M7IwNTE1NjK3NFMS530t9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Ncx/Vap68R
	ymvPn3XZbZbJx1Jz88DP8PnbjPMCD61p3CrS5s6+9dtWz1YB2ezzMRX/NT8Erc81K9gS2P2r
	Rdb3qspbtnlel1ZPmXr0kLvj8iiHTQ89L6yb8Wb1oZ38iTK/77malETYpreYLKwLLlM6EbhM
	9cNKxRiz+/PDe02W/BZ1rnCe5abEUpyRaKjFXFScCABc+OrFxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV2b1j/BBh1/dCyO7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM7qkVBfdYK9bM/sjWwPiZpYuRk0NCwERic9tWJghbTOLCvfVs
	XYxcHEIC0xkljq74wArh/GaUOL5iKStIFZuAmsSXL4fZQWwRAQWJzb3PwOLMArkSv2euZASx
	hQRsJeZvWwEW5xSwk1h6+BxYvbCAn0TT0/tgNSwCqhLrG96BbeYFqp+6dBMjhC0o8WPyPRaI
	mVoS63ceZ4Kw5SU2r3nL3MXIAXSpusSjv7oQJxhJ3DkwHeoEEYl9L94xTmAUmoVk0iwkk2Yh
	mTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx/0x6B+OqBotDjAIcjEo8vDfi
	fwcLsSaWFVfmHmKU4GBWEuH9kfQnWIg3JbGyKrUoP76oNCe1+BCjKdCjE5mlRJPzgekoryTe
	0NjEzMjSyMzCyMTcXEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QDo4VPsu8Dqe2HfD7oqLMv
	+aHtFq7F67mTzfbPCuOwbDb5cHW1PQ4rixfv96zbfsTFy2PdW9FDlw97mb0v3qOcrSBhcklr
	W65k6rqLcxa+8pNT9blpmpRiu/m8ol51dkYaCwf3yu+3Dlfmv/7+lbn5TPv7Kbf4ZnPc3fTx
	ZejuLRPbPt/+uuCiqxJLcUaioRZzUXEiACffK14PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/wm831x_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 8b9455e93069..07ca98e2a5d4 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -111,6 +111,7 @@ static int wm831x_backlight_update_status(struct backlight_device *bl)
 static int wm831x_backlight_get_brightness(struct backlight_device *bl)
 {
 	struct wm831x_backlight_data *data = bl_get_data(bl);
+
 	return data->current_brightness;
 }
 
-- 
2.0.0


