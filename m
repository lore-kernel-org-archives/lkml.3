Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbaHZM6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:58:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32124 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbaHZM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:58:38 -0400
X-AuditID: cbfee68f-f797f6d000001173-e9-53fc847ce552
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
In-reply-to: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
Subject: [PATCH 05/18] backlight: corgi_lcd: add blank line after declarations
Date: Tue, 26 Aug 2014 21:58:36 +0900
Message-id: <00af01cfc12d$72f80660$58e81320$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/BLSgE1uQ+HizQTQC0PRMOtHkloQAAD8xw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zfd2alj/BBrenKVgc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmrTi5n
	LtjCWnFi7x2WBsbtLF2MHBwSAiYSG2aLdDFyApliEhfurWfrYuTiEBJYxihxa/UWdoiEicTN
	9umMEInpjBLt/64yQTi/GSU2zvzMDFLFJqAm8eXLYbAOEQEFic29z1hBbGaBXInfM1cygthC
	ArYS87etAItzCthJLD18DqxeWMBPYu2pJ2A2i4CqxKo928DqeYHqF37ewgxhC0r8mHyPBWKm
	lsT6nceZIGx5ic1r3jJDfKMu8eivLsQJRhILljayQ5SISOx78Q7sAQmBU+wSpxuPsUHsEpD4
	NvkQNCRkJTYdYIZ4WFLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJjveLE
	3OLSvHS95PzcTYyQqOzfwXj3gPUhRgEORiUe3pvxv4OFWBPLiitzDzGaAl00kVlKNDkfGPt5
	JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgXF/BXff4
	StlX/h8RdfpFUS6frmx4xMRwXfGd4PqdgpHr/gd94V7y/tHaCbr2R+cuPy8jkSr/7fakjR48
	mr6l3KWvJLhVRe/8mGxx7yzHqgXzr2z5HlrWe5Lhstr+qslJviXuK76bnVezVj20LjFzwUbz
	+ptlR6ZsSLm375r3cReJS9XfjgcJCSuxFGckGmoxFxUnAgDpnu6lxQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd2alj/BBqf3yVgc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZq04uZy7YwlpxYu8dlgbG7SxdjJwcEgImEjfbpzNC2GISF+6t
	Z+ti5OIQEpjOKNH+7yoThPObUWLjzM/MIFVsAmoSX74cZgexRQQUJDb3PmMFsZkFciV+z1wJ
	NklIwFZi/rYVYHFOATuJpYfPgdULC/hJrD31BMxmEVCVWLVnG1g9L1D9ws9bmCFsQYkfk++x
	QMzUkli/8zgThC0vsXnNW6AaDqBL1SUe/dWFOMFIYsHSRnaIEhGJfS/eMU5gFJqFZNIsJJNm
	IZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBUf9MagfjygaLQ4wCHIxKPLw3
	4n8HC7EmlhVX5h5ilOBgVhLh/ZH0J1iINyWxsiq1KD++qDQntfgQoynQoxOZpUST84EJKa8k
	3tDYxMzI0sjMwsjE3FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUA6PRe70DKepTl5UkivlZ
	RZzY8u1RpUDCu/7nJ66xHV/rZLHkYNX2NXfk5mwKXel4L1nqiMb2j9UV937vKtKO6jv2ecty
	+TWdCQszV3G2uO42VTh7//4Kl7Ubp3FLTDpnKCqb5DtVvl/q8tvASwxcN7M3cwecPLrU1XvK
	2+jYqhurdzDkTS2fNuWPEktxRqKhFnNRcSIAaJwFtRADAAA=
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
 drivers/video/backlight/corgi_lcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 51d18d637e2b..d7c37a8ccd1f 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -143,6 +143,7 @@ static void lcdtg_i2c_send_byte(struct corgi_lcd *lcd,
 				uint8_t base, uint8_t data)
 {
 	int i;
+
 	for (i = 0; i < 8; i++) {
 		if (data & 0x80)
 			lcdtg_i2c_send_bit(lcd, base | POWER0_COM_DOUT);
-- 
2.0.0


