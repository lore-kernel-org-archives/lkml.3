Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaH0BNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:13:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43194 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaH0BNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:13:34 -0400
X-AuditID: cbfee68e-f79536d000000fd1-58-53fd30ba6da2
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 13/18] backlight: s6e63m0: remove 'else' after a return
Date: Wed, 27 Aug 2014 10:13:30 +0900
Message-id: <005101cfc194$1d42ee80$57c8cb80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAKjXQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zY91dBn+DDR4+tbA4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDL6vj5n
	KmjmrJi1+i9jA+NW9i5GTg4JAROJQ3seMkLYYhIX7q1n62Lk4hASWMYosXliEwtM0avVR1gg
	EosYJXb8PwPl/GaUmDq3FayKTUBN4suXw2BjRQQUJDb3PmMFsZkFciV+z1wJtkJIwFbi8sK1
	TCA2p4CdxOwP08HqhQW8JM6fWAxWzyKgKjFx1xs2EJsXqP7o6vssELagxI/J91ggZmpJrN95
	nAnClpfYvOYtcxcjB9Cl6hKP/upCnGAk0Tp3FhtEiYjEvhfvGEFulhA4xS6xf9k0qF0CEt8m
	H2KB6JWV2HSAGeJhSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z0ihNz
	i0vz0vWS83M3MULism8H480D1ocYBTgYlXh4Pyz4EyzEmlhWXJl7iNEU6KKJzFKiyfnA6M8r
	iTc0NjOyMDUxNTYytzRTEudNkPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFR4YboSVe1
	yVbbNuZx/Vvfw3jz/t73r9z/57vv12XMniwnPOv2qgORyS/8dEsmM/msOHQz3LxizdcVV2x1
	yvVfJn5iWzrVhTVTQvjvpVdbLWUvv5EJWmx0+/e+wL3c7dZq4bHWXwWf2tzgSDze17YiaZL3
	9fOiHAtXT9u2qJL5q+ciT5aKdGVbJZbijERDLeai4kQA/7na9MYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd1dBn+DDc7uM7U4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgz+r4+Zypo5qyYtfovYwPjVvYuRk4OCQETiVerj7BA2GISF+6t
	Z+ti5OIQEljEKLHj/xkWCOc3o8TUua1gVWwCahJfvhwG6xYRUJDY3PuMFcRmFsiV+D1zJSOI
	LSRgK3F54VomEJtTwE5i9ofpYPXCAl4S508sBqtnEVCVmLjrDRuIzQtUf3T1fRYIW1Dix+R7
	LBAztSTW7zzOBGHLS2xe85a5i5ED6FJ1iUd/dSFOMJJonTuLDaJERGLfi3eMExiFZiGZNAvJ
	pFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDUP5PewbiqweIQowAHoxIP
	74cFf4KFWBPLiitzDzFKcDArifAmK/wNFuJNSaysSi3Kjy8qzUktPsRoCvToRGYp0eR8YELK
	K4k3NDYxM7I0MrMwMjE3VxLnPdhqHSgkkJ5YkpqdmlqQWgTTx8TBKdXAKD45n3mpmrIFu/qP
	FbdueaTtes/vsfDZpitTmo7p8T7bz19QtkXsGlPE/n9xmQtjTd6Gvt7aLqr4S3PFbuftc9sj
	VpucM5p98pF0+EbO+5Y893lUjpo9v/Bu++uV87/EpbUvib1ZJ+ob9Tr02TRBXWfGoInmXyZn
	mwkfb/H8HW3Co25bty7srxJLcUaioRZzUXEiAAYDT2UQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: else is not generally useful after a break or return

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
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


