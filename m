Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaFBREm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:04:42 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37538 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaFBREl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:04:41 -0400
Message-ID: <538CAEBD.5040501@gmail.com>
Date: Mon, 02 Jun 2014 19:05:01 +0200
From: Federico Di Pierro <nierro92@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: jic23@kernel.org, jic23@kernel.org, gregkh@linuxfoundation.org,
        jg1.han@samsung.com, sachin.kamat@linaro.org
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix some coding style problem in drivers/staging/iio/frequency/ad9832.c
Content-Type: multipart/mixed;
 boundary="------------020707000505080700040902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020707000505080700040902
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi!
This is my latest task of the eudyptula challenge.
Just a very small patch! It fixes 3 little coding style problems.
I'm using linux-next.

--------------020707000505080700040902
Content-Type: text/plain; charset=UTF-8;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch"

--- linux/drivers/staging/iio/frequency/ad9832.c.orig	2014-06-02 17:26:12.929978122 +0200
+++ linux/drivers/staging/iio/frequency/ad9832.c	2014-06-02 17:28:10.389970947 +0200
@@ -57,7 +57,7 @@ static int ad9832_write_frequency(struct
 }
 
 static int ad9832_write_phase(struct ad9832_state *st,
-				  unsigned long addr, unsigned long phase)
+			      unsigned long addr, unsigned long phase)
 {
 	if (phase > (1 << AD9832_PHASE_BITS))
 		return -EINVAL;
@@ -73,7 +73,7 @@ static int ad9832_write_phase(struct ad9
 }
 
 static ssize_t ad9832_write(struct device *dev,
-		struct device_attribute *attr,
+			    struct device_attribute *attr,
 		const char *buf,
 		size_t len)
 {
@@ -109,11 +109,11 @@ static ssize_t ad9832_write(struct devic
 		ret = spi_sync(st->spi, &st->msg);
 		break;
 	case AD9832_FREQ_SYM:
-		if (val == 1)
+		if (val == 1) {
 			st->ctrl_fp |= AD9832_FREQ;
-		else if (val == 0)
+		} else if (val == 0) {
 			st->ctrl_fp &= ~AD9832_FREQ;
-		else {
+		} else {
 			ret = -EINVAL;
 			break;
 		}


Signed-off-by: Federico Di Pierro <nierro92@gmail.org>
--------------020707000505080700040902--
