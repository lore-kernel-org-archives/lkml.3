Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbaHZNCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:02:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20779 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559AbaHZNCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:02:07 -0400
X-AuditID: cbfee68d-f79c46d000000b84-26-53fc854e2624
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 16/18] backlight: jornada720: remove 'else' after a return
Date: Tue, 26 Aug 2014 22:02:06 +0900
Message-id: <00ba01cfc12d$f0202000$d0606000$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAL45A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA12/1j/BBv8Xylkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBl3zr5m
	K5jLXtE76QFLA2MDWxcjB4eEgInE1KPWXYycQKaYxIV764HCXBxCAssYJR5u6GSFSJhIzD57
	jhnEFhJYxCix6aEYRNFvRoklW96AFbEJqEl8+XKYHcQWEVCQ2Nz7DCzOLJAr8XvmSkaIZluJ
	+dtWgMU5Bewklh4+B1YvLOAl8XjeTbAFLAKqEpfX7AaL8wLVn9vdyQRhC0r8mHyPBWKmlsT6
	nceZIGx5ic1r3jJDPKMu8eivLogpImAkcemtNESFiMS+F+8YQU6WEDjGLtF/8xgbxCoBiW+T
	D7FAtMpKbDrADPGupMTBFTdYJjBKzEKyeBaSxbOQLJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5
	xaV56XrJ+bmbGCER2buD8fYB60OMAhyMSjy8N+J/BwuxJpYVV+YeYjQFumgis5Rocj4w7vNK
	4g2NzYwsTE1MjY3MLc2UxHkVpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamC85ONVnLJA
	ZOUkA7vlEUtr70RHN9mv9vBtce+YcZBRIeuo8evth2ecXhBYffnvm+UXrln2Pol8wXFThk+i
	Y8a+6rQZRcsEim8uX/627aSa5OTmTSbrWSYvtlw8I/fll1qz82+WWPCsnXR6fl+2gtiXuZvF
	6mrzOj2cXfWWRZ2wM5xZrtoTL9agxFKckWioxVxUnAgAk14PF8MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAV2/1j/BBrufSVkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZd86+ZiuYy17RO+kBSwNjA1sXIyeHhICJxOyz55ghbDGJC/fW
	g8WFBBYxSmx6KNbFyAVk/2aUWLLlDStIgk1ATeLLl8PsILaIgILE5t5nYHFmgVyJ3zNXMkI0
	20rM37YCLM4pYCex9PA5sHphAS+Jx/Nugi1jEVCVuLxmN1icF6j+3O5OJghbUOLH5HssEDO1
	JNbvPM4EYctLbF7zFqiXA+hQdYlHf3VBTBEBI4lLb6UhKkQk9r14xziBUWgWkkGzkAyahWTQ
	LCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/wzqR2MKxssDjEKcDAq8fDeiP8d
	LMSaWFZcmXuIUYKDWUmE90fSn2Ah3pTEyqrUovz4otKc1OJDjKZAf05klhJNzgcmo7ySeENj
	EzMjSyMzCyMTc3Mlcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYyrRYJ6Z7D19pmpNzs7/O5Z
	PnPFA7+GQ7t1FsjWmVtNXcj6+sfbtlpmK9vXVrofvu4Ku7ir5NPfH4tXqrWc+XP01sSv1/Tu
	vv72boeWfeNFdjf98PPHWQXXH/rktFJi6sHLfWrqzRxx71Kf7Trh4xN6WV9QyqtoTXxzbWDm
	MaF/GXvkZE+tXOaoxFKckWioxVxUnAgA3TARsA4DAAA=
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
 drivers/video/backlight/jornada720_bl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 6ce96b4a8796..7e6ff5346892 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -41,11 +41,11 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
 		dev_err(&bd->dev, "get brightness timeout\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
-	} else {
-		/* exchange txdummy for value */
-		ret = jornada_ssp_byte(TXDUMMY);
 	}
 
+	/* exchange txdummy for value */
+	ret = jornada_ssp_byte(TXDUMMY);
+
 	jornada_ssp_end();
 
 	return BL_MAX_BRIGHT - ret;
-- 
2.0.0


