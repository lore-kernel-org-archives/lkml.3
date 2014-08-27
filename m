Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaH0BMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:12:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33079 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbaH0BMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:12:16 -0400
X-AuditID: cbfee68e-f79536d000000fd1-37-53fd306ec05d
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 09/18] backlight: lm3639: remove unnecessary return
 statements
Date: Wed, 27 Aug 2014 10:12:14 +0900
Message-id: <004d01cfc193$effea4f0$cffbeed0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAHoeQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY908g7/BBkd+WFsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBl3V+5m
	LtjLXrF65zSWBsYFbF2MnBwSAiYSkyZ8Y4SwxSQu3FsPFOfiEBJYxihxt/kKkMMBVnRkvzlI
	jZDAIkaJl9t9IGp+M0o0PuhhAUmwCahJfPlymB3EFhFQkNjc+4wVxGYWyJX4PXMlI0SzrcTl
	hWuZQGxOATuJ2R+mg9ULCwRLdHzZBRZnEVCVuN14EWwmL1D9q1eXmCFsQYkfk++xQMzUkli/
	8zgThC0vsXnNW2aIO9UlHv3VhTjBSGJ19zM2iBIRiX0v3kH9eIxdYtHHQIhVAhLfJh9igWiV
	ldh0gBmiRFLi4IobLBMYJWYhWTwLyeJZSBbPQrJhASPLKkbR1ILkguKk9CIjveLE3OLSvHS9
	5PzcTYyQiOzbwXjzgPUhRgEORiUe3g8L/gQLsSaWFVfmHmI0BbpoIrOUaHI+MO7zSuINjc2M
	LExNTI2NzC3NlMR5E6R+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgNFy0ieXfocvfHiby
	Lu4V+Xxl55sFxcsWFOb+a1aNfTFjs52i7ZVfLgsjOEMlCk3j/feX2K2LPvWs6LXx4057Y6aZ
	x/wz3q+a4JfbsGnO/RcFj+VZZvpV2B0paP3OuvTi5dBFLBwlvOt/ijTEHFY8yiLye/8tad9/
	6sfmHGk/7KHmFtV63cY7UImlOCPRUIu5qDgRAJRrdj3DAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd08g7/BBlMPWFgc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZd1fuZi7Yy16xeuc0lgbGBWxdjBwcEgImEkf2m3cxcgKZYhIX
	7q1nA7GFBBYxSrzc7tPFyAVk/2aUaHzQwwKSYBNQk/jy5TA7iC0ioCCxufcZK4jNLJAr8Xvm
	SkaIZluJywvXMoHYnAJ2ErM/TAerFxYIluj4sgssziKgKnG78SLYTF6g+levLjFD2IISPybf
	Y4GYqSWxfudxJghbXmLzmrfMEDerSzz6qwtxgpHE6u5nbBAlIhL7XrxjnMAoNAvJpFlIJs1C
	MmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj/pn0DsZVDRaHGAU4GJV4eD8s
	+BMsxJpYVlyZe4hRgoNZSYQ3WeFvsBBvSmJlVWpRfnxRaU5q8SFGU6BHJzJLiSbnA5NRXkm8
	obGJmZGlkZmFkYm5uZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGRp8NHcdXtAZNmN51r8Vr
	kTf3/Py9Xst6tu84fW9rx+nXrH+TkjM37e+pC6lt0tlquZxvcus89TWFvaabd6c0V7xKWGIk
	+/WhwkQN/pu60y/kLD6rejg/S0bhcNOtzHTnab+sJ3w2uuMXNt3XMb049ujZJy5nzz9v2lHT
	3ew76c/ibSFVdWomKUosxRmJhlrMRcWJAJMjcL8OAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: void function return statements are not generally useful

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/lm3639_bl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index 5f36808d214f..cd50df5807ea 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -254,7 +254,6 @@ static void lm3639_torch_brightness_set(struct led_classdev *cdev,
 	return;
 out:
 	dev_err(pchip->dev, "i2c failed to access register\n");
-	return;
 }
 
 /* flash */
@@ -293,7 +292,6 @@ static void lm3639_flash_brightness_set(struct led_classdev *cdev,
 	return;
 out:
 	dev_err(pchip->dev, "i2c failed to access register\n");
-	return;
 }
 
 static const struct regmap_config lm3639_regmap = {
-- 
2.0.0


