Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaBFISC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:18:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56535 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbaBFISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:18:00 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-89-52f345379a5e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Mike Frysinger'" <vapier@gentoo.org>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 03/12] backlight: adp8870: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:17:59 +0900
Message-id: <000401cf2313$f2297df0$d67c79d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAF/OQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zY11z189BBi/vylrMWb+GzeLywkus
	Fpd3zWGzmHB4M7vFzQk/mB1YPV5ddfS4/P0Ns8eJGb9ZPPq2rGL0+LxJLoA1issmJTUnsyy1
	SN8ugSvj6o2rTAXP2Sp+nqxqYLzG2sXIySEhYCKxoW8vG4QtJnHh3nowW0hgGaPEtdvhXYwc
	YDXfTkR3MXIBhRcxSvw9cJENwvnFKHFzUi8LSAObgJrEly+H2UEaRAT0JdpaNEBqmEEaOrbe
	YoEYaiux+/RJsMWcAnYS2z61MoHYwgJeEj8a1oItZhFQlXi44jYjiM0LVN+64iQLhC0o8WPy
	PTCbWUBLYv3O40wQtrzE5jVvmSEOVZd49FcXJCwiYCQx6dseZogSEYl9L94xgtwjIXCLXeLr
	geWMELsEJL5NPsQC0SsrsekAMyQcJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUgu
	KE5KLzLUK07MLS7NS9dLzs/dxAiJ0d4djLcPWB9iTAZaP5FZSjQ5HxjjeSXxhsZmRhamJqbG
	RuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKGwkE3v95JbvukLvj5x7
	vHhmticzr/6JxiXBvCIFJ6OW9F3RSPH5VbHpugyTespN0b8fLhRsuNbZu+Lqt70u65m6re10
	JOcnrdst0b/r3EPjTX7qC/svzNriatD6uFH5GNvhxjsVm/+pKRg+2nNPt7TqvfOvpfMneZhu
	L50YnfTIzenyR4kLEkosxRmJhlrMRcWJAF3XFjDnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAV1z189BBtt7pCzmrF/DZnF54SVW
	i8u75rBZTDi8md3i5oQfzA6sHq+uOnpc/v6G2ePEjN8sHn1bVjF6fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcfXGVaaC52wVP09WNTBeY+1i5OCQEDCR+HYi
	uouRE8gUk7hwbz1bFyMXh5DAIkaJvwcuQjm/GCVuTuplAaliE1CT+PLlMDtIs4iAvkRbiwZI
	DTNIQ8fWW2A1QgK2ErtPn2QFsTkF7CS2fWplArGFBbwkfjSsZQOxWQRUJR6uuM0IYvMC1beu
	OMkCYQtK/Jh8D8xmFtCSWL/zOBOELS+xec1bZoij1SUe/dUFCYsIGElM+raHGaJERGLfi3eM
	ExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAKeCa9g3FV
	g8UhRgEORiUe3g3rPwUJsSaWFVfmHmKU4GBWEuHdav45SIg3JbGyKrUoP76oNCe1+BBjMtCj
	E5mlRJPzgekpryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoY
	V++KOZDIUR2zPHSGk44w09aFCz9tvsJqkBp8Y8oT1oifauH1HE2341k6TNXPFt/92vA1g8fP
	pMP8WKHm9DLd1pWf7h4Q0Lqnreb3V5jV5ch6LbXzZqYsVyfslhbZPOP31tigL4ft+cS8Cy9N
	/qM4588axuoagZJvbmbBc9z/JE+ckZq9/thrJZbijERDLeai4kQAvtEcEEUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8870_bl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 6370720..251af4d 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -246,10 +246,8 @@ static int adp8870_led_probe(struct i2c_client *client)
 
 	led = devm_kzalloc(&client->dev, pdata->num_leds * sizeof(*led),
 				GFP_KERNEL);
-	if (led == NULL) {
-		dev_err(&client->dev, "failed to alloc memory\n");
+	if (led == NULL)
 		return -ENOMEM;
-	}
 
 	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
 	if (ret)
-- 
1.7.10.4


