Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaHEBsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:48:25 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:39245 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaHEBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:48:22 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH v2 7/8] staging: iio: accel: lis3l02dq_ring.c: Add blank line between declarations and code
Date: Mon,  4 Aug 2014 22:47:02 -0300
Message-Id: <1407203223-9700-8-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1.204.gae8bc8d
In-Reply-To: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
References: <1407203223-9700-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank line between declarations and code,
satisfying checkpatch.pl.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/lis3l02dq_ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index bf33fde..1d934ee 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -19,6 +19,7 @@ static inline u16 combine_8_to_16(u8 lower, u8 upper)
 {
 	u16 _lower = lower;
 	u16 _upper = upper;
+
 	return _lower | (_upper << 8);
 }
 
-- 
2.1.0.rc1.204.gae8bc8d

