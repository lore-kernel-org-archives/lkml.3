Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbaHZM5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:57:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20385 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaHZM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:57:38 -0400
X-AuditID: cbfee68d-f79c46d000000b84-4c-53fc84404bbb
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 02/18] backlight: adp8860: add blank line after declarations
Date: Tue, 26 Aug 2014 21:57:36 +0900
Message-id: <00ac01cfc12d$4f288b60$ed79a220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAABoAA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ12Hlj/BBo8bpC2O7pzIZHF54SVW
	i/tfjzJaXN41h82BxWPnrLvsHneu7WHz6NuyitHj8ya5AJYoLpuU1JzMstQifbsErozrG/4w
	FSzjqvj49iVLA+MZji5GTg4JAROJ+4/esEDYYhIX7q1n62Lk4hASWMYo8f7nGiaYoiu357JA
	JKYzSvz+/owZwvnNKDF9bTczSBWbgJrEly+H2UFsEQEFic29z1hBbGaBXInfM1cygthCArYS
	87etAItzCthJLD18DqxeWMBH4uaqhWwgNouAqsSaAyfA6nmB6rfNfwFlC0r8mHyPBWKmlsT6
	nceZIGx5ic1r3gLdwAF0qbrEo7+6ECcYSdxe9wrqBBGJfS/eMUI8c4pdovGjGMQqAYlvkw+x
	QLTKSmw6wAxRIilxcMUNlgmMErOQLJ6FZPEsJItnIdmwgJFlFaNoakFyQXFSepGhXnFibnFp
	Xrpecn7uJkZIVPbuYLx9wPoQowAHoxIP743438FCrIllxZW5hxhNgS6ayCwlmpwPjP28knhD
	YzMjC1MTU2Mjc0szJXFeRamfwUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYzRMv3083eL4w
	6WDOWrmSV/PTb/KEst6bYRy3k7/0VMvT7w7CGvssAhcUiDBszDv26vuc0x7RBbmi35q5o/vE
	Uvc98J84aW/s7icvHBO5K1Kl28/JH/QTLvz2iSNd7uqqDnvryzfes53ffnZvr4rE1yVMrc7u
	tpVlP/kMqnabiD/tv5P0Kf6VEktxRqKhFnNRcSIA4awAq8UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQV2Hlj/BBj9PiVsc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ1zf8YSpYxlXx8e1LlgbGMxxdjJwcEgImElduz2WBsMUkLtxb
	z9bFyMUhJDCdUeL392fMEM5vRonpa7uZQarYBNQkvnw5zA5iiwgoSGzufcYKYjML5Er8nrmS
	EcQWErCVmL9tBVicU8BOYunhc2D1wgI+EjdXLWQDsVkEVCXWHDgBVs8LVL9t/gsoW1Dix+R7
	LBAztSTW7zzOBGHLS2xe8xboBg6gS9UlHv3VhTjBSOL2uldQJ4hI7HvxjnECo9AsJJNmIZk0
	C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvpn0jsYVzVYHGIU4GBU4uG9
	Ef87WIg1say4MvcQowQHs5II74+kP8FCvCmJlVWpRfnxRaU5qcWHGE2BHp3ILCWanA9MSHkl
	8YbGJmZGlkZmFkYm5uZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhg5hboYMmauC5/ud+st
	C/vjmZFT5r22TPkbu/hgqKN/9GF/Q0b5/8vvivIUV2WrONRW8l69OnHS9m/hDaZffKOiXL77
	PvPht3o832Tb6a+er3/p7p5ZYlrCfsVl0vcdHDsVY+P/vdIQv7hxg5SXevS8510amx5W//zy
	W3aKwMxVe8+oBsbbZb1SYinOSDTUYi4qTgQA3CP0RhADAAA=
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


