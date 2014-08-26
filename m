Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbaHZM6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:58:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20419 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbaHZM56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:57:58 -0400
X-AuditID: cbfee68f-f797f6d000001173-e3-53fc8455fc50
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 03/18] backlight: adp8870: add blank line after declarations
Date: Tue, 26 Aug 2014 21:57:57 +0900
Message-id: <00ad01cfc12d$5b9e16d0$12da4470$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAACfxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfd3Qlj/BBpMviFkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnb171h
	KjjDU3Fr1gOWBsbdXF2MHBwSAiYSn55mdzFyApliEhfurWfrYuTiEBJYxigx9/c5RoiEicTy
	nYdZIBLTGSWeP/oPVfWbUWLdjD5WkCo2ATWJL18Os4PYIgIKEpt7n4HFmQVyJX7PXAk2SUjA
	VmL+thVgcU4BO4mlh8+xg1whLOAj8fOkH4jJIqAq8ekUWAUvUHXjz03sELagxI/J91ggJmpJ
	rN95nAnClpfYvOYtM8Qv6hKP/uqCmCICRhJvnphBVIhI7HvxDuqTU+wSjzvAOlkEBCS+TT7E
	AtEpK7HpADNEiaTEwRU3WCYwSsxCsncWkr2zkOydhWTDAkaWVYyiqQXJBcVJ6UXGesWJucWl
	eel6yfm5mxgh0di/g/HuAetDjAIcjEo8vDfjfwcLsSaWFVfmHmI0BbpoIrOUaHI+MObzSuIN
	jc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAyHtx7uavC07s
	EzURENsad81VyT6Z0eX5bUvrgol91nxeJ6XOX2Qzq+75Pc9+5XmT84I+u/by1aa5v7k74XRw
	+ZXq78FrxP6pdQobFlSH8/ksPhy19Oh70zeaE643dMjOULI/wTKtYOOc/4til9RbRuh7899V
	2v/Y5uPVd0f3Lfjobn+mdALDMyWW4oxEQy3mouJEAALgnXTBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd3Qlj/BBqcvCVkc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ29e9YSo4w1Nxa9YDlgbG3VxdjJwcEgImEst3HmaBsMUkLtxb
	z9bFyMUhJDCdUeL5o/9Qzm9GiXUz+lhBqtgE1CS+fDnMDmKLCChIbO59BhZnFsiV+D1zJSOI
	LSRgKzF/2wqwOKeAncTSw+eA6jk4hAV8JH6e9AMxWQRUJT6dAqvgBapu/LmJHcIWlPgx+R4L
	xEQtifU7jzNB2PISm9e8ZQZplRBQl3j0VxfEFBEwknjzxAyiQkRi34t3jBMYhWYhGTQLyaBZ
	SAbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwvD+T2sG4ssHiEKMAB6MSD++N
	+N/BQqyJZcWVuYcYJTiYlUR4fyT9CRbiTUmsrEotyo8vKs1JLT7EaAr05kRmKdHkfGAqyiuJ
	NzQ2MTOyNDKzMDIxN1cS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwFjx28w3sHp7CevpotXT
	y+b2r/5xtpGx3ObKDIPcoto3rvdmTC5OmRLEOn/uXK5q1amnw2vXSGT/fzJB5f1kl/ZtD+ov
	r88O/S4vZx4y65i9VX//ZSnm7BX/or8cy7zKFlMYY8oT4HjFMGTCl1e/vv/y27JO7ozrK+uL
	ZZeer3XuDjc+trr44FclluKMREMt5qLiRAAECUQcDQMAAA==
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


