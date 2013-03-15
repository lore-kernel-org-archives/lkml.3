Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3COPcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:32:13 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:53337 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561Ab3COPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:32:11 -0400
Message-ID: <1363361525.1335.113.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix comment typo "CONFIG_IIO_RING_BUFFER"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 16:32:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2013 15:32:05.0957 (UTC) FILETIME=[3FCB8F50:01CE2192]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Entirely untested.

 include/linux/iio/gyro/itg3200.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iio/gyro/itg3200.h b/include/linux/iio/gyro/itg3200.h
index c53f169..2a82085 100644
--- a/include/linux/iio/gyro/itg3200.h
+++ b/include/linux/iio/gyro/itg3200.h
@@ -149,6 +149,6 @@ static inline void itg3200_buffer_unconfigure(struct iio_dev *indio_dev)
 {
 }
 
-#endif  /* CONFIG_IIO_RING_BUFFER */
+#endif  /* CONFIG_IIO_BUFFER */
 
 #endif /* ITG3200_H_ */
-- 
1.7.11.7

