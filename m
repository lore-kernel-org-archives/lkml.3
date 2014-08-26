Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbaHZNBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:01:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65525 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaHZNBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:01:14 -0400
X-AuditID: cbfee691-f79546d0000011a1-9e-53fc8518029e
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 13/18] backlight: s6e63m0: remove 'else' after a return
Date: Tue, 26 Aug 2014 22:01:12 +0900
Message-id: <00b701cfc12d$cff2f910$6fd8eb30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAJ6KQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA12J1j/BBq9XyVsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnff7Yz
	FVznqDhxIL+BsY+9i5GTQ0LARGLJlMnMELaYxIV769m6GLk4hASWMUqs2f2BDaZo+9T5rCC2
	kMAiRon2ZTEQ9m9GiVkNxiA2m4CaxJcvh8GGiggoSGzufQZWzyyQK/F75kpGiHpbifnbVoDF
	OQXsJJYePgdWLyzgLnH5XzMTiM0ioCqxvXc1mM0LVN/37jcjhC0o8WPyPRaImVoS63ceZ4Kw
	5SU2r3kL9AAH0J3qEo/+6kKcYCTxadZGZogSEYl9L94xgvwlIbCPXWLdo7lQuwQkvk0+xALR
	Kyux6QA0HCQlDq64wTIB6Dkkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66X
	nJ+7iRESkRN3MN4/YH2IUYCDUYmH90b872Ah1sSy4srcQ4ymQBdNZJYSTc4Hxn1eSbyhsZmR
	hamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MmUec47sWVOqfP5PQ
	V73akUPZY7Vo3K1T9cI3Z2dP3XXi0RHeDYwcma9PhTEmHS0quLApt7Zj2aT+kycYbb6v4qr8
	lLjyNvu11p96SptnzRcyOdOR9998WbJlPF9nulDwy9SyKNtDfj5rmHZvUb/hOyNH6N3FT6xN
	t1UXWbYkZE3Vzdn1tXiJEktxRqKhFnNRcSIA1NkNssMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAV2J1j/BBhsbZSyO7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM7z/bmQquc1ScOJDfwNjH3sXIySEhYCKxfep8VghbTOLCvfVs
	ILaQwCJGifZlMRD2b0aJWQ3GIDabgJrEly+HwXpFBBQkNvc+A+tlFsiV+D1zJSNEva3E/G0r
	wOKcAnYSSw+fA6sXFnCXuPyvmQnEZhFQldjeuxrM5gWq73v3mxHCFpT4MfkeC8RMLYn1O48z
	QdjyEpvXvGXuYuQAulNd4tFfXYgTjCQ+zdrIDFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnA
	yLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjen0ntYFzZYHGIUYCDUYmH90b872Ah1sSy
	4srcQ4wSHMxKIrw/kv4EC/GmJFZWpRblxxeV5qQWH2I0BXp0IrOUaHI+MBXllcQbGpuYGVka
	mVkYmZibK4nzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpg7EjcXJ1+ez9n8Ub+hV1x9SpqjNra
	xzJ3zC5dvdRjyXoLzT12MVxZ3jIy3i23vJjrH+stCr7T8uD5rHsxXwpbgubsKrzLF71j9S2O
	J8+PiUl+quRetXdWj3Xy/kTT28+fZuvwBVqb3nr0U5OxlDvzunLI0bOXI+9vKI+cOa/3f3ta
	/JxNe7/OVWIpzkg01GIuKk4EAIsRB4YNAwAA
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
 drivers/video/backlight/s6e63m0.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index f3a65c8940ed..28bfa127fee4 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -507,19 +507,19 @@ static int s6e63m0_power_on(struct s6e63m0 *lcd)
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
 	ret = s6e63m0_ldi_init(lcd);
 	if (ret) {
 		dev_err(lcd->dev, "failed to initialize ldi.\n");
-- 
2.0.0


