Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaH0BKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:10:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64942 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbaH0BKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:10:14 -0400
X-AuditID: cbfee690-f79ce6d00000115a-72-53fd2ff41dae
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 03/18] backlight: adp8870: add blank line after declarations
Date: Wed, 27 Aug 2014 10:10:11 +0900
Message-id: <004701cfc193$a6c9ccb0$f45d6610$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAADJdw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI90v+n+DDS4/47I4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLuzZ/D
	WPCDp2LSzWVsDYyPuLoYOTgkBEwkWrfndjFyApliEhfurWfrYuTiEBJYxijx9mYjC0TCROLe
	tD5GiMR0Rollfx5AVf1mlFh/eiIzSBWbgJrEly+H2UFsEQEFic29z1hBbGaBXInfM1cygthC
	ArYSlxeuZQKxOQXsJGZ/mA5WLyzgL/HqdCfYHBYBVYn1L34xgVzHC1T/848jSJhXQFDix+R7
	LBAjtSTW7zzOBGHLS2xe85YZ4hl1iUd/dSEuMJKY9/8gI0SJiMS+F+/A7pcQOMcucWbCCkaI
	VQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KL
	TPSKE3OLS/PS9ZLzczcxQmJywg7GewesDzEKcDAq8fB+WPAnWIg1say4MvcQoynQRROZpUST
	84GRn1cSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbu
	oEn3dzP768WFbN8XkZy41TFV+6pQQ6CiqtimvyLefHMtM1qfq7XP7M5cyvNFd/r8fn3vhqUl
	F1jtTpgaWF/f4T5PynHJ9J3/Vk/6pHDQ72l6YE546QLt3eYtjR8fRnAv5nv4sIXdmKFN/OXq
	a0Ji27/cPGGYPb/w6/qg0jtbFi613e4ylU2JpTgj0VCLuag4EQAFrraNxAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd0v+n+DDRZPZ7c4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgz7s2fw1jwg6di0s1lbA2Mj7i6GDk5JARMJO5N62OEsMUkLtxb
	z9bFyMUhJDCdUWLZnwdQzm9GifWnJzKDVLEJqEl8+XKYHcQWEVCQ2Nz7jBXEZhbIlfg9cyXY
	JCEBW4nLC9cygdicAnYSsz9MB6sXFvCXeHW6E2wOi4CqxPoXv4BqODh4gep//nEECfMKCEr8
	mHyPBWKklsT6nceZIGx5ic1r3jKDlEsIqEs8+qsLcYGRxLz/BxkhSkQk9r14xziBUWgWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/wz6R2MqxosDjEKcDAq
	8fB+WPAnWIg1say4MvcQowQHs5IIb7LC32Ah3pTEyqrUovz4otKc1OJDjKZAf05klhJNzgem
	o7ySeENjEzMjSyMzCyMTc3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYxNO3riyo7vsZL+
	MH3XR5Oemv691somJc/ClpzK+575SF4/Rrh2ve+crnNV23w2zMzeE80SeUxIryTnRHPMrNl9
	e7+5hu/LndyU4vbq37wCkWV31p3a7PHLNFtP+GhX+OSCoy+WKr9d+KWee5auB+sqvaUT2p/k
	vO8VMzF/d3BNUeqG59+y3c8psRRnJBpqMRcVJwIAjxVqqQ8DAAA=
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
 drivers/video/backlight/adp8870_bl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 251af4d38d86..037e43083343 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -144,6 +144,7 @@ static int adp8870_read(struct i2c_client *client, int reg, uint8_t *val)
 static int adp8870_write(struct i2c_client *client, u8 reg, u8 val)
 {
 	int ret = i2c_smbus_write_byte_data(client, reg, val);
+
 	if (ret)
 		dev_err(&client->dev, "failed to write\n");
 
@@ -195,6 +196,7 @@ static int adp8870_clr_bits(struct i2c_client *client, int reg, uint8_t bit_mask
 static void adp8870_led_work(struct work_struct *work)
 {
 	struct adp8870_led *led = container_of(work, struct adp8870_led, work);
+
 	adp8870_write(led->client, ADP8870_ISC1 + led->id - 1,
 			 led->new_brightness >> 1);
 }
@@ -399,6 +401,7 @@ static int adp8870_bl_set(struct backlight_device *bl, int brightness)
 static int adp8870_bl_update_status(struct backlight_device *bl)
 {
 	int brightness = bl->props.brightness;
+
 	if (bl->props.power != FB_BLANK_UNBLANK)
 		brightness = 0;
 
@@ -649,6 +652,7 @@ static ssize_t adp8870_bl_l1_daylight_max_store(struct device *dev,
 {
 	struct adp8870_bl *data = dev_get_drvdata(dev);
 	int ret = kstrtoul(buf, 10, &data->cached_daylight_max);
+
 	if (ret)
 		return ret;
 
-- 
2.0.0


