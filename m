Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaGaWg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:36:28 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42469 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaGaWgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:36:24 -0400
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 7/8] staging: iio: accel: lis3l02dq_ring.c: fix coding style
Date: Thu, 31 Jul 2014 19:34:57 -0300
Message-Id: <1406846098-19866-8-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
References: <1406846098-19866-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing blank lines after declarations.

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/iio/accel/lis3l02dq_ring.c |    1 +
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
1.7.10.4

