Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbaFBXPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:15:12 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:54513 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaFBXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:15:08 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com, linux-input@vger.kernel.org,
        jkosina@suse.cz
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCHv2 2/3] IIO: Add iio_chan modifier for True/Magnetic North HID usages
Date: Mon,  2 Jun 2014 18:14:49 -0500
Message-Id: <1401750890-31854-3-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com>
References: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated iio modifier enum for compass north usages,
including magnetic/true north with tilt compensation.

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/iio/industrialio-core.c | 4 ++++
 include/linux/iio/types.h       | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index ede16aec..2f523b5 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -84,6 +84,10 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_LIGHT_RED] = "red",
 	[IIO_MOD_LIGHT_GREEN] = "green",
 	[IIO_MOD_LIGHT_BLUE] = "blue",
+	[IIO_MOD_NORTH_MAGN] = "north_magnetic",
+	[IIO_MOD_NORTH_TRUE] = "north_true",
+	[IIO_MOD_NORTH_MAGN_TILT_COMP] = "north_magnetic_tilt_comp",
+	[IIO_MOD_NORTH_TRUE_TILT_COMP] = "north_true_tilt_comp",
 };
 
 /* relies on pairs of these shared then separate */
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 084d882..5bf8847 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -53,6 +53,10 @@ enum iio_modifier {
 	IIO_MOD_LIGHT_RED,
 	IIO_MOD_LIGHT_GREEN,
 	IIO_MOD_LIGHT_BLUE,
+	IIO_MOD_NORTH_MAGN,
+	IIO_MOD_NORTH_TRUE,
+	IIO_MOD_NORTH_MAGN_TILT_COMP,
+	IIO_MOD_NORTH_TRUE_TILT_COMP
 };
 
 enum iio_event_type {
-- 
1.9.3

