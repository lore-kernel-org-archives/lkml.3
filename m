Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaH0BJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:09:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32500 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbaH0BJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:09:53 -0400
X-AuditID: cbfee68f-f797f6d000001173-98-53fd2fe0101f
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 02/18] backlight: adp8860: add blank line after declarations
Date: Wed, 27 Aug 2014 10:09:52 +0900
Message-id: <004601cfc193$9afed920$d0fc8b60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAACbVQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zA90H+n+DDRZ+l7Q4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDKeHTjD
	WnCJq2LhvwusDYyfOboYOTgkBEwkLp2s6GLkBDLFJC7cW8/WxcjFISSwjFFi+c+JTBAJE4nN
	rduYIBKLGCWOf50BVfWbUeLPhF5WkCo2ATWJL18Os4PYIgIKEpt7n4HFmQVyJX7PXMkIYgsJ
	2EpcXrgWbCqngJ3E7A/TweqFBfwlnredYwOxWQRUJc7tOQBWwwtUf/37bShbUOLH5HssEDO1
	JNbvPM4EYctLbF7zlhniG3WJR391IU4wktg5/RZUiYjEvhfvGEFulhA4xi4x7/FidohdAhLf
	Jh9igeiVldh0gBniYUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9YoT
	c4tL89L1kvNzNzFCorJ/B+PdA9aHGAU4GJV4eD8s+BMsxJpYVlyZe4jRFOiiicxSosn5wNjP
	K4k3NDYzsjA1MTU2Mrc0UxLnXSj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo7xSy+nN
	f5/flJ3/wX5G0eRIvgeVs7VcuzaYV96213rguEDZmDkkR4rpDc+n6bxGc7fur8nrWTrN88KO
	/pIFOv8lrO745Cw8eNkjXz2Q59Ou5pikSzEr5rCJKHJF/ygsW3D4Qt6L8lsX3DZLND2f0tQl
	1lhYGeMjyuzP5Rd/Z3GKm0iBV6GJEktxRqKhFnNRcSIAhUyGLsUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd0H+n+DDRq2iFkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZzw6cYS24xFWx8N8F1gbGzxxdjJwcEgImEptbtzFB2GISF+6t
	Z+ti5OIQEljEKHH86wwo5zejxJ8JvawgVWwCahJfvhxmB7FFBBQkNvc+A4szC+RK/J65khHE
	FhKwlbi8cC3YVE4BO4nZH6aD1QsL+Es8bzvHBmKzCKhKnNtzAKyGF6j++vfbULagxI/J91gg
	ZmpJrN95nAnClpfYvOYtcxcjB9Cl6hKP/upCnGAksXP6LagSEYl9L94xTmAUmoVk0iwkk2Yh
	mTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFR/0xqB+PKBotDjAIcjEo8vB8X
	/AkWYk0sK67MPcQowcGsJMKbrPA3WIg3JbGyKrUoP76oNCe1+BCjKdCjE5mlRJPzgQkpryTe
	0NjEzMjSyMzCyMTcXEmc90CrdaCQQHpiSWp2ampBahFMHxMHp1QDo2itw4abU1e8Yzrslbzn
	kP1XlfUay+LSCy0avDaZBAmvaBDlkjNnFVn6VJr/7v5zDXuftPC2pE7SPixosnWm3YJMNe2v
	tQGKzp058YYzXHvT/I7UnU3efGNq0qkTN2v7L/rJz/z8r2CJsLgNb/2lMPvZklb1tl5bGtYd
	/rnUIcBjksJhJ6FnSizFGYmGWsxFxYkAdavdPhADAAA=
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
 drivers/video/backlight/adp8860_bl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index be8d83deca7d..71147f4461b8 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -181,6 +181,7 @@ static int adp8860_clr_bits(struct i2c_client *client, int reg, uint8_t bit_mask
 static void adp8860_led_work(struct work_struct *work)
 {
 	struct adp8860_led *led = container_of(work, struct adp8860_led, work);
+
 	adp8860_write(led->client, ADP8860_ISC1 - led->id + 1,
 			 led->new_brightness >> 1);
 }
@@ -362,6 +363,7 @@ static int adp8860_bl_set(struct backlight_device *bl, int brightness)
 static int adp8860_bl_update_status(struct backlight_device *bl)
 {
 	int brightness = bl->props.brightness;
+
 	if (bl->props.power != FB_BLANK_UNBLANK)
 		brightness = 0;
 
@@ -499,6 +501,7 @@ static ssize_t adp8860_bl_l1_daylight_max_store(struct device *dev,
 {
 	struct adp8860_bl *data = dev_get_drvdata(dev);
 	int ret = kstrtoul(buf, 10, &data->cached_daylight_max);
+
 	if (ret)
 		return ret;
 
-- 
2.0.0


