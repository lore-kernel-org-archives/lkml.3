Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaF3C7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 22:59:35 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36537 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaF3C6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 22:58:53 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH v4 2/4] iio: types: Added support for rotation from north usage attributes
Date: Sun, 29 Jun 2014 21:58:37 -0500
Message-Id: <1404097119-19922-3-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404097119-19922-1-git-send-email-reyad.attiyat@gmail.com>
References: <1404097119-19922-1-git-send-email-reyad.attiyat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the rotation from north usage attributes to the iio modifier enum and to the iio modifier names array.

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/iio/industrialio-core.c | 4 ++++
 include/linux/iio/types.h       | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 4b1f375..af3e76d 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -87,6 +87,10 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_QUATERNION] = "quaternion",
 	[IIO_MOD_TEMP_AMBIENT] = "ambient",
 	[IIO_MOD_TEMP_OBJECT] = "object",
+	[IIO_MOD_NORTH_MAGN] = "from_north_magnetic",
+	[IIO_MOD_NORTH_TRUE] = "from_north_true",
+	[IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
+	[IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
 };
 
 /* relies on pairs of these shared then separate */
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index d480631..d09c40d 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -56,6 +56,10 @@ enum iio_modifier {
 	IIO_MOD_QUATERNION,
 	IIO_MOD_TEMP_AMBIENT,
 	IIO_MOD_TEMP_OBJECT,
+	IIO_MOD_NORTH_MAGN,
+	IIO_MOD_NORTH_TRUE,
+	IIO_MOD_NORTH_MAGN_TILT_COMP,
+	IIO_MOD_NORTH_TRUE_TILT_COMP
 };
 
 enum iio_event_type {
-- 
1.9.3

