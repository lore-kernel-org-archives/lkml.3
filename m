Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaHZWiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:38:23 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47302 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaHZWiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:38:21 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: [PATCH] iio: adc: rockchip_saradc: remove unused variable in probe
Date: Wed, 27 Aug 2014 00:40:16 +0200
Message-ID: <2134722.Yfu4MZ4klm@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rate variable in the probe function of the saradc is a remnant
of a previous patch iteration. It is unused and thus produces a
compile time warning. Therefore remove it.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/iio/adc/rockchip_saradc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/adc/rockchip_saradc.c b/drivers/iio/adc/rockchip_saradc.c
index 1fad964..e074a0b 100644
--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -141,7 +141,6 @@ static int rockchip_saradc_probe(struct platform_device *pdev)
 	struct resource	*mem;
 	int ret;
 	int irq;
-	u32 rate;
 
 	if (!np)
 		return -ENODEV;
-- 
2.0.1


