Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaH0BLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:11:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42505 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaH0BK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:10:59 -0400
X-AuditID: cbfee68d-f79c46d000000b84-6a-53fd302072bd
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 05/18] backlight: corgi_lcd: add blank line after
 declarations
Date: Wed, 27 Aug 2014 10:10:55 +0900
Message-id: <004901cfc193$c10901e0$431b05a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAEuZg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI10Fg7/BBmtW8Foc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmvXxxh
	K3jAWnFs20TGBsZ7LF2MnBwSAiYSi/ethbLFJC7cW8/WxcjFISSwjFGib/UR9i5GDrCig6/8
	IOKLGCUu7m6DKvrNKHF+wTdWkG42ATWJL18Os4PYIgIKEpt7n4HFmQVyJX7PXMkIYgsJ2Epc
	XriWCcTmFLCTmP1hOli9sECwxMqOfWD1LAKqEpN/bwer5wWqv3jmIDOELSjxYzLE1cwCWhLr
	dx5ngrDlJTavecsMcai6xKO/uhAnGEmcffMTqlxEYt+Ld4wgN0sIHGOXOPzkLdQuAYlvkw+x
	QPTKSmw6wAwJCEmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL
	89L1kvNzNzFCorJ3B+PtA9aHGAU4GJV4eD8s+BMsxJpYVlyZe4jRFOiiicxSosn5wNjPK4k3
	NDYzsjA1MTU2Mrc0UxLnVZT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMdeDLUxHSmAX
	T+qkhYELrk8Oadk84W54OM+8JNnW7T8tZ8zZKbX0tkfcD82PPqWWZjFcUxSP6ek/XizMKWD1
	+xbnqZUx/LM22k2VXOK8tvzyJm+9R063yuxtatnP6t56JH0i4/vRp3xv2qZeSerp7Yta8Pn6
	bd7Iok23yxt6bx28yylxM+fkdiWW4oxEQy3mouJEAGCDGsrFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV0Fg7/BBosncVkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZr18cYSt4wFpxbNtExgbGeyxdjBwcEgImEgdf+XUxcgKZYhIX
	7q1n62Lk4hASWMQocXF3G5Tzm1Hi/IJvrCBVbAJqEl++HGYHsUUEFCQ29z4DizML5Er8nrmS
	EcQWErCVuLxwLROIzSlgJzH7w3SwemGBYImVHfvA6lkEVCUm/94OVs8LVH/xzEFmCFtQ4sdk
	kONAZmpJrN95nAnClpfYvOYtM8TR6hKP/upCnGAkcfbNT6hyEYl9L94xTmAUmoVk0iwkk2Yh
	mTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEx/0xqB+PKBotDjAIcjEo8vB8X
	/AkWYk0sK67MPcQowcGsJMKbrPA3WIg3JbGyKrUoP76oNCe1+BCjKdCjE5mlRJPzgekoryTe
	0NjEzMjSyMzCyMTcXEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDY9j/9gv/b82QZAyYWbe+
	1fphRk/Xr73Tjqya5G/sbpl89fF22bC1vcIcU06etLz41j2p2+ptu1TO1EL5363bn4VfNsi3
	eLlssWvdmVNbvfINtE+v2Myy9OmSAElrVu4qx+rnDUXLnqutcJ0l9OMnH1/9KzuR66eeS4qb
	iG9fVPNIa90Sjqny35RYijMSDbWYi4oTASGX+H0PAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/corgi_lcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 51d18d637e2b..d7c37a8ccd1f 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -143,6 +143,7 @@ static void lcdtg_i2c_send_byte(struct corgi_lcd *lcd,
 				uint8_t base, uint8_t data)
 {
 	int i;
+
 	for (i = 0; i < 8; i++) {
 		if (data & 0x80)
 			lcdtg_i2c_send_bit(lcd, base | POWER0_COM_DOUT);
-- 
2.0.0


