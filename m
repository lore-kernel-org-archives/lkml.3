Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbaHZNCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:02:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52599 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbaHZNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:02:27 -0400
X-AuditID: cbfee68f-f797f6d000001173-bf-53fc8561e617
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 17/18] backlight: jornada720: remove 'else' after a return
Date: Tue, 26 Aug 2014 22:02:25 +0900
Message-id: <00bb01cfc12d$fb662c20$f2328460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAMjEg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zfd3E1j/BBqvWSFkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlHvrSx
	Ftxiq+g9uZStgfEkaxcjJ4eEgInExMc7oWwxiQv31rN1MXJxCAksY5RYPuEvM0xR95Q5LCC2
	kMB0Rokny+whin4zSvS8bWMESbAJqEl8+XKYHcQWEVCQ2Nz7DGwqs0CuxO+ZKxkhmm0l5m9b
	ARbnFLCTWHr4HFi9sICXxMWpEDaLgKrEuaMHwGp4geovdqxhhrAFJX5MvscCMVNLYv3O40wQ
	trzE5jVvgWo4gA5Vl3j0VxfEFBEwkliyPAGiQkRi34t3jCAnSwgcY5c40jaRFWKVgMS3yYdY
	IFplJTYdgHpXUuLgihssExglZiFZPAvJ4llIFs9CsmIBI8sqRtHUguSC4qT0ImO94sTc4tK8
	dL3k/NxNjJCY7N/BePeA9SFGAQ5GJR7em/G/g4VYE8uKK3MPMZoCXTSRWUo0OR8Y+Xkl8YbG
	ZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAMZc7qMZ9o4/qj
	7lr0T987zFP5GbomVpdv2Z5ltiDs4nH5lxyZ9UX3f+Um6bnftlug0h0VlewgXOvJXOZflLZq
	lWzBlf+FW2fE7Vp49t5Zd265r4IrN60s5rit+aNxCsvj9MqH7nVTt1RxMJ6e/z/N/EPAzTN3
	PLcLbNLOWNV0WVnnbuGM2jVKLMUZiYZazEXFiQCXNQ7fxAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd3E1j/BBk9+iVkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZR760sRbcYqvoPbmUrYHxJGsXIyeHhICJRPeUOSwQtpjEhXvr
	2UBsIYHpjBJPltl3MXIB2b8ZJXretjGCJNgE1CS+fDnMDmKLCChIbO59BjaIWSBX4vfMlYwQ
	zbYS87etAItzCthJLD18DqxeWMBL4uJUCJtFQFXi3NEDYDW8QPUXO9YwQ9iCEj8m32OBmKkl
	sX7ncSYIW15i85q3QDUcQIeqSzz6qwtiiggYSSxZngBRISKx78U7xgmMQrOQDJqFZNAsJINm
	IWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM44p9J7WBc2WBxiFGAg1GJh/dG/O9g
	IdbEsuLK3EOMEhzMSiK8P5L+BAvxpiRWVqUW5ccXleakFh9iNAX6cyKzlGhyPjAZ5ZXEGxqb
	mBlZGplZGJmYmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYBQNL+lWZXsYnRy3+ZKbyYVN
	n2cZH24rcvje4f8mgOn0+i9bHTa97f4nHD9h6dZTteEdQT9P6t1OFTFsilD9U66nm7bTJOEi
	18sS1fs/S2eK3vZNu6n62CXn3JqCBO87r6+vO/rz+NzVdh0yAW0N8oyuLhL31J9fTnT5uaLq
	vVKewsOT7ifv31NiKc5INNRiLipOBACnofCvDgMAAA==
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
 drivers/video/backlight/jornada720_lcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index 228bc319de19..1cf3d59f1e7f 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -30,8 +30,8 @@ static int jornada_lcd_get_power(struct lcd_device *ld)
 	/* LDD2 in PPC = LCD POWER */
 	if (PPSR & PPC_LDD2)
 		return FB_BLANK_UNBLANK;	/* PW ON */
-	else
-		return FB_BLANK_POWERDOWN;	/* PW OFF */
+
+	return FB_BLANK_POWERDOWN;	/* PW OFF */
 }
 
 static int jornada_lcd_get_contrast(struct lcd_device *ld)
-- 
2.0.0


