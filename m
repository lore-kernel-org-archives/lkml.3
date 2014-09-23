Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaIWMvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:51:49 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33335 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaIWMvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:51:48 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Sebastian Reichel <sre@debian.org>,
        Jonathan Cameron <jic23@kernel.org>, lars@metafoo.de,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] iio: consumer.h: Fix scale factor in function comment
Date: Tue, 23 Sep 2014 15:51:42 +0300
Message-Id: <1411476702-10004-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1 milivolt is equal to 1000000 nanovolts.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 include/linux/iio/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iio/consumer.h b/include/linux/iio/consumer.h
index 651f9a0..087af10 100644
--- a/include/linux/iio/consumer.h
+++ b/include/linux/iio/consumer.h
@@ -191,7 +191,7 @@ int iio_read_channel_scale(struct iio_channel *chan, int *val,
  * The scale factor allows to increase the precession of the returned value. For
  * a scale factor of 1 the function will return the result in the normal IIO
  * unit for the channel type. E.g. millivolt for voltage channels, if you want
- * nanovolts instead pass 1000 as the scale factor.
+ * nanovolts instead pass 1000000 as the scale factor.
  */
 int iio_convert_raw_to_processed(struct iio_channel *chan, int raw,
 	int *processed, unsigned int scale);
-- 
1.9.1

