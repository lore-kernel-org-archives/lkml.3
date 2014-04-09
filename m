Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbaDIAyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:54:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:55839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbaDIAxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,821,1389772800"; 
   d="scan'208";a="489591599"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [Patch v3 4/6] IIO: core: Add quaternion modifier
Date: Tue,  8 Apr 2014 17:56:26 -0700
Message-Id: <1397004988-31550-4-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added quaternion in the list of supported modifiers.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/industrialio-core.c | 1 +
 include/linux/iio/types.h       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 3bd565c..1d907eb 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -84,6 +84,7 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_LIGHT_RED] = "red",
 	[IIO_MOD_LIGHT_GREEN] = "green",
 	[IIO_MOD_LIGHT_BLUE] = "blue",
+	[IIO_MOD_QUATERNION] = "quaternion",
 };
 
 /* relies on pairs of these shared then separate */
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index a13c224..4fdab2e 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -53,6 +53,7 @@ enum iio_modifier {
 	IIO_MOD_LIGHT_RED,
 	IIO_MOD_LIGHT_GREEN,
 	IIO_MOD_LIGHT_BLUE,
+	IIO_MOD_QUATERNION,
 };
 
 enum iio_event_type {
-- 
1.7.11.7

