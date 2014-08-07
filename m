Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaHGAXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 20:23:09 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:57342 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaHGAXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 20:23:06 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v3 2/2] staging: iio: accel: sca3000_core.c: Adjust code to fit 80-chars limit
Date: Wed,  6 Aug 2014 21:22:09 -0300
Message-Id: <1407370929-26949-3-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
In-Reply-To: <1407370929-26949-1-git-send-email-mopsfelder@gmail.com>
References: <1407370929-26949-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/sca3000_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index bc53fedb..e4e5639 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -506,7 +506,8 @@ static int sca3000_read_raw(struct iio_dev *indio_dev,
 				mutex_unlock(&st->lock);
 				return ret;
 			}
-			*val = ((st->rx[0] & 0x3F) << 3) | ((st->rx[1] & 0xE0) >> 5);
+			*val = ((st->rx[0] & 0x3F) << 3) |
+			       ((st->rx[1] & 0xE0) >> 5);
 		}
 		mutex_unlock(&st->lock);
 		return IIO_VAL_INT;
-- 
2.1.0.rc1.204.gae8bc8d

