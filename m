Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbaBAOwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 09:52:51 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:61072 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbaBAOwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 09:52:50 -0500
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Cc: Johannes Thumshirn <morbidrsa@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: viperboard: Drop platform_set_drvdata call
Date: Sat,  1 Feb 2014 15:52:44 +0100
Message-Id: <1391266364-14383-1-git-send-email-morbidrsa@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop call to platform_set_drvdata as driver data is not used anywhere in the
driver

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/iio/adc/viperboard_adc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/iio/adc/viperboard_adc.c b/drivers/iio/adc/viperboard_adc.c
index d0add8f..9acf6b6 100644
--- a/drivers/iio/adc/viperboard_adc.c
+++ b/drivers/iio/adc/viperboard_adc.c
@@ -139,8 +139,6 @@ static int vprbrd_adc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	platform_set_drvdata(pdev, indio_dev);
-
 	return 0;
 }
 
-- 
1.8.5.3

