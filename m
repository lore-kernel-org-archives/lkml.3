Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaAMQw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:52:59 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34360 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753580AbaAMQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:13 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Marek Vasut <marex@denx.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/3] iio: mxs-lradc: remove useless scale_available files
Date: Mon, 13 Jan 2014 17:02:03 +0100
Message-Id: <1389628923-8689-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in_voltage8_scale_available and in_voltage9_scale_available are exposed to
userspace but useless as in_voltage8_raw and in_voltage9_raw are not available.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 2289dc1bd928..cfd95d825702 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -1035,8 +1035,6 @@ SHOW_SCALE_AVAILABLE_ATTR(4);
 SHOW_SCALE_AVAILABLE_ATTR(5);
 SHOW_SCALE_AVAILABLE_ATTR(6);
 SHOW_SCALE_AVAILABLE_ATTR(7);
-SHOW_SCALE_AVAILABLE_ATTR(8);
-SHOW_SCALE_AVAILABLE_ATTR(9);
 SHOW_SCALE_AVAILABLE_ATTR(10);
 SHOW_SCALE_AVAILABLE_ATTR(11);
 SHOW_SCALE_AVAILABLE_ATTR(12);
@@ -1053,8 +1051,6 @@ static struct attribute *mxs_lradc_attributes[] = {
 	&iio_dev_attr_in_voltage5_scale_available.dev_attr.attr,
 	&iio_dev_attr_in_voltage6_scale_available.dev_attr.attr,
 	&iio_dev_attr_in_voltage7_scale_available.dev_attr.attr,
-	&iio_dev_attr_in_voltage8_scale_available.dev_attr.attr,
-	&iio_dev_attr_in_voltage9_scale_available.dev_attr.attr,
 	&iio_dev_attr_in_voltage10_scale_available.dev_attr.attr,
 	&iio_dev_attr_in_voltage11_scale_available.dev_attr.attr,
 	&iio_dev_attr_in_voltage12_scale_available.dev_attr.attr,
-- 
1.8.3.2

