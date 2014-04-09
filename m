Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaDIAyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:54:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:55839 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717AbaDIAxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:53:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,821,1389772800"; 
   d="scan'208";a="489591601"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [Patch v3 6/6] iio: Added ABI description for quaternion
Date: Tue,  8 Apr 2014 17:56:28 -0700
Message-Id: <1397004988-31550-6-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added documentation for reading quaternion components for 3D rotations.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 6e02c50..d1cad9a 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -891,3 +891,12 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		This attribute is used to get/set the integration time in
 		seconds.
+
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_quaternion_raw
+KernelVersion:	3.15
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Raw value of quaternion components using a format
+		x y z w. Here x, y, and z component represents the axis about
+		which a rotation will occur and w component represents the
+		amount of rotation.
-- 
1.7.11.7

