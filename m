Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaAGBc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:32:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44874 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaAGBc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:32:26 -0500
X-AuditID: cbfee68f-b7f156d00000276c-fa-52cb5929175b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Milo Kim'" <milo.kim@ti.com>
References: <002101cf0b48$0d38a280$27a9e780$%han@samsung.com>
In-reply-to: <002101cf0b48$0d38a280$27a9e780$%han@samsung.com>
Subject: [PATCH 3/3] backlight: lp8788: remove unnecessary parentheses
Date: Tue, 07 Jan 2014 10:32:25 +0900
Message-id: <002301cf0b48$51bb8b70$f532a250$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8LSA0gEKLTvq6wRRuOH6kV6zbuQQAAC+MQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY13NyNNBBjMnqVrMWb+GzeLywkus
	Fpd3zWGzWP5rHYsDi8eJGb9ZPPq2rGL0OH5jO5PH501yASxRXDYpqTmZZalF+nYJXBmXVv9i
	KnjEUXHp91HmBsYt7F2MnBwSAiYSbUfOQtliEhfurWfrYuTiEBJYxiix8esili5GDrCirwsK
	IeKLGCVWTtvKBOH8YpRYsGkVK0g3m4CaxJcvh9lBGkQE9CXaWjRAwswCKRJnrq1mA7GFBGwl
	XjYfYAaxOQXsJLb8+swCYgsLuEm8278dzGYRUJV4sOMKWD0vUP2pv5cYIWxBiR+T77FAzNSS
	2LytiRXClpfYvOYtM8Sd6hKP/uqChEUEjCReLV/BBlEiIrHvxTtGkJMlBM6xSxz7NRVql4DE
	t8mHoH6UldgEcZqEgKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UXGesWJ
	ucWleel6yfm5mxghMdm/g/HuAetDjMlA6ycyS4km5wNjOq8k3tDYzMjC1MTU2Mjc0ow0YSVx
	3vsPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MBobtYlsX3F85qfcyQoCd4LWbVTO5rJ/
	rrHlpz3HkxzGQxb6z+anTz5l//r2ws/73dP425l//LjaX7aFW+lB9suzldtU43Vv7by35rha
	0B8hU/nfrKLF87qtOAqzN3S11dyzTZxn6lYW4C7NHTftavYsi0tbWS+nJMV0LO/sn5V3dIf1
	wf4FLUosxRmJhlrMRcWJANv55mrfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV3NyNNBBss3KFrMWb+GzeLywkus
	Fpd3zWGzWP5rHYsDi8eJGb9ZPPq2rGL0OH5jO5PH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZl1b/Yip4xFFx6fdR5gbGLexdjBwcEgImEl8XFHYxcgKZYhIX
	7q1n62Lk4hASWMQosXLaViYI5xejxIJNq1hBqtgE1CS+fDkM1iwioC/R1qIBEmYWSJE4c201
	G4gtJGAr8bL5ADOIzSlgJ7Hl12cWEFtYwE3i3f7tYDaLgKrEgx1XwOp5gepP/b3ECGELSvyY
	fI8FYqaWxOZtTawQtrzE5jVvmSFuVpd49FcXJCwiYCTxavkKNogSEYl9L94xTmAUmoVk0iwk
	k2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER/0x6B+OqBotDjAIcjEo8
	vC/2ngoSYk0sK67MPcQowcGsJMIronQ6SIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgcko
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYF7G0t7avfe0Q
	+PDd9rNWfVpFtYH1rdlGyTucp7Tk+MaFZ13wrqg8fukft2JPX/7l5hvHrnwJml2tzcxfrShh
	MjPiWMK5fl3RQFYu3ponZ0tOsl370faJSTK97ZIAS8MBrwePIk29t6apBS9JU8yq2zj9md3n
	NjUtpe7Ts7/wWzx5UbXvmLUSS3FGoqEWc1FxIgAJjiZzPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary parentheses in order to fix the following
checkpatch error.

  ERROR: return is not a function, parentheses are not required

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lp8788_bl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
index e49905d..daba34d 100644
--- a/drivers/video/backlight/lp8788_bl.c
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -63,13 +63,13 @@ static struct lp8788_bl_config default_bl_config = {
 
 static inline bool is_brightness_ctrl_by_pwm(enum lp8788_bl_ctrl_mode mode)
 {
-	return (mode == LP8788_BL_COMB_PWM_BASED);
+	return mode == LP8788_BL_COMB_PWM_BASED;
 }
 
 static inline bool is_brightness_ctrl_by_register(enum lp8788_bl_ctrl_mode mode)
 {
-	return (mode == LP8788_BL_REGISTER_ONLY ||
-		mode == LP8788_BL_COMB_REGISTER_BASED);
+	return mode == LP8788_BL_REGISTER_ONLY ||
+		mode == LP8788_BL_COMB_REGISTER_BASED;
 }
 
 static int lp8788_backlight_configure(struct lp8788_bl *bl)
-- 
1.7.10.4


