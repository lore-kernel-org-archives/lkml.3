Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaAaPie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:38:34 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53218 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaAaPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:38:32 -0500
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: matt.porter@linaro.org, koen@dominion.thruhere.net,
        pantelis.antoniou@gmail.com, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH 1/2] iio: add IIO_DISTANCE type
Date: Fri, 31 Jan 2014 07:38:22 -0800
Message-Id: <1391182703-2201-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 drivers/iio/industrialio-core.c | 1 +
 include/linux/iio/types.h       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index acc911a..ac999ab 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -70,6 +70,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_CCT] = "cct",
 	[IIO_PRESSURE] = "pressure",
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
+	[IIO_DISTANCE] = "distance",
 };
 
 static const char * const iio_modifier_names[] = {
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 084d882..675c2d8 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -30,6 +30,7 @@ enum iio_chan_type {
 	IIO_CCT,
 	IIO_PRESSURE,
 	IIO_HUMIDITYRELATIVE,
+	IIO_DISTANCE,
 };
 
 enum iio_modifier {
-- 
1.8.3.2

