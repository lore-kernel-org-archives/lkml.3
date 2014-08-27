Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbaH0BM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:12:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33284 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaH0BMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:12:55 -0400
X-AuditID: cbfee690-f79ce6d00000115a-aa-53fd3096df5c
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 11/18] backlight: lp855x: add blank line after declarations
Date: Wed, 27 Aug 2014 10:12:53 +0900
Message-id: <004f01cfc194$076b5930$16420b90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAAJTIA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI91pBn+DDX6ekLA4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDKWr3jP
	XHCdveLz04wGxo1sXYwcHBICJhLb+4FMTiBTTOLCvfVANheHkMAyRomtd78xQSRMJCZOO8sM
	kVjEKPH86mV2COc3o0TbxyesIFVsAmoSX74cZgexRQQUJDb3PgOLMwvkSvyeuZIRxBYSsJW4
	vHAt2FROATuJ2R+mg9ULC/hJXJm6nQnkIhYBVYkPs0tAwrxA5S8Wt7FD2IISPybfY4EYqSWx
	fudxJghbXmLzmrfMEM+oSzz6qwtxgZHEwRUbocpFJPa9eMcI8csxdolbTW4gNouAgMS3yYdY
	IFplJTYdYIYokQRqvcEygVFiFpLFs5AsnoVk8SwkGxYwsqxiFE0tSC4oTkovMtErTswtLs1L
	10vOz93ECInHCTsY7x2wPsQowMGoxMP7YcGfYCHWxLLiytxDjKZAF01klhJNzgdGfV5JvKGx
	mZGFqYmpsZG5pZmSOO9rqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhjJ7w/NuHUi85d
	ykLHfD6pvGTUfqtQ3Nufcpz5yu/iaJUOj6RDSaul6g6oqIgbuB9Zlrj2Zj/P00/XGji+1pr1
	G62uXFbc9LJi53u3VUv3PZx4QupZHMvZVxJu6x/9zZgr+E7hwWILI0vPmy7F//ds2aRv//EL
	C98qdvEtk5n+valr2SPEteynEktxRqKhFnNRcSIAxntB7MICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAd1pBn+DDXZOFLU4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzlq94z1xwnb3i89OMBsaNbF2MnBwSAiYSE6edZYawxSQu3FsP
	FOfiEBJYxCjx/OpldgjnN6NE28cnrCBVbAJqEl++HGYHsUUEFCQ29z4DizML5Er8nrmSEcQW
	ErCVuLxwLROIzSlgJzH7w3SwemEBP4krU7cDxTk4WARUJT7MLgEJ8wKVv1jcxg5hC0r8mHyP
	BWKklsT6nceZIGx5ic1r3jKDtEoIqEs8+qsLcYGRxMEVG6HKRST2vXjHOIFRaBaSSbOQTJqF
	ZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRH/DPpHYyrGiwOMQpwMCrx8H5Y
	8CdYiDWxrLgy9xCjBAezkghvssLfYCHelMTKqtSi/Pii0pzU4kOMpkB/TmSWEk3OByajvJJ4
	Q2MTMyNLIzMLIxNzcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjMkLWVlFmv0kF1hLFv1s
	/r57n8rXNxJr3A1cL4bWVqz0yGKtlL5r8tv9fKSiN5dv553bTuc+B7Cv/3YwWjJg2WpzF182
	1WflWr8On9Rmn3Az7s/vZ8tt34UIXfv46P/EbQyn3zFH30rwl3hcusHCdgYzw/f47cK7bJy8
	RGe8D197+mHshgdqxUosxRmJhlrMRcWJAHQ5uxgOAwAA
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
 drivers/video/backlight/lp855x_bl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index dcdd5443efcf..25fb8e3d75b1 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -268,6 +268,7 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
 
 	} else if (lp->mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
+
 		lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	}
 
@@ -308,6 +309,7 @@ static ssize_t lp855x_get_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
+
 	return scnprintf(buf, PAGE_SIZE, "%s\n", lp->chipname);
 }
 
-- 
2.0.0


