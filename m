Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaH0BJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:09:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32313 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbaH0BJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:09:16 -0400
X-AuditID: cbfee68e-f79536d000000fd1-aa-53fd2fba3b12
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 01/18] backlight: adp5520: add blank line after declarations
Date: Wed, 27 Aug 2014 10:09:14 +0900
Message-id: <004501cfc193$845a08c0$8d0e1a40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAA6jg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ91d+n+DDa7flbA4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDKe/9vD
	UtDPVnFhxzL2BsYZrF2MnBwSAiYSE09dh7LFJC7cW8/WxcjFISSwjFHi3rnnQAkOsKKmZgeI
	+CJGiQ/X9rFAOL8ZJY7f/cUI0s0moCbx5cthdhBbREBBYnPvM7CpzAK5Er9nrgSrERKwlbi8
	cC0TiM0pYCcx+8N0sHphAX+J3RtOs4HYLAKqEk33D4LFeYHqHx0+xQxhC0r8mHyPBWKmlsT6
	nceZIGx5ic1r3jJDHKou8eivLogpImAkMe2NDUSFiMS+F+8YIX48xS7R8j8fYpOAxLfJh1gg
	OmUlNh1ghiiRlDi44gbLBEaJWUj2zkKydxaSvbOQbFjAyLKKUTS1ILmgOCm9yEivODG3uDQv
	XS85P3cTIyQi+3Yw3jxgfYhRgINRiYf3w4I/wUKsiWXFlbmHGE2BLprILCWanA+M+7ySeENj
	MyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhXsvh8u/Zl2/UT
	7bNeNYha33+zpcGm0nGCG2+TAutRGaHjZ/oqjKY9DbM3q4zMe+F18vrtl6c6Ay2vmT2uSXxV
	2hyyPLN758xbKXGbeARTrvb5tSTtKc3iWlIxkSW2czf31vB0iRPp1oX7lq58yhmS8y5ERV5W
	e06Z2839Tw4keU0NYlpjc1WJpTgj0VCLuag4EQCW99zXwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd1d+n+DDWbMELU4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgznv/bw1LQz1ZxYccy9gbGGaxdjBwcEgImEk3NDl2MnECmmMSF
	e+vZuhi5OIQEFjFKfLi2jwXC+c0ocfzuL0aQKjYBNYkvXw6zg9giAgoSm3ufsYLYzAK5Er9n
	rgSrERKwlbi8cC0TiM0pYCcx+8N0sHphAX+J3RtOs4HYLAKqEk33D4LFeYHqHx0+xQxhC0r8
	mHyPBWKmlsT6nceZIGx5ic1r3jJDHK0u8eivLogpImAkMe2NDUSFiMS+F+8YJzAKzUIyaBaS
	QbOQDJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCIfya9g3FVg8UhRgEORiUe
	3g8L/gQLsSaWFVfmHmKU4GBWEuFNVvgbLMSbklhZlVqUH19UmpNafIjRFOjPicxSosn5wGSU
	VxJvaGxiZmRpZGZhZGJuriTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBcal0wJPQsJ9X9wqX
	/fr4XCf8n6fI3btW/Gbfc1ZE9nwqdWa8JHKsqkeleNNyjXPzfmUZcZ84I/WyL+Kklly9dNTU
	BNM9S5d8iNpTlfOgfHHlfLlrHc5mC8PynulHa0ZfmFLf/Tb+e3orW9DUi19i7rqyyen4G+9z
	Sdud9HZPJHcGU+HlRWXJSizFGYmGWsxFxYkAVzvV8Q4DAAA=
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
 drivers/video/backlight/adp5520_bl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index f37097a261a2..8280245d7c12 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -67,6 +67,7 @@ static int adp5520_bl_set(struct backlight_device *bl, int brightness)
 static int adp5520_bl_update_status(struct backlight_device *bl)
 {
 	int brightness = bl->props.brightness;
+
 	if (bl->props.power != FB_BLANK_UNBLANK)
 		brightness = 0;
 
-- 
2.0.0


