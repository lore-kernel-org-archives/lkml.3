Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaDNEYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 00:24:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:18500 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaDNEYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 00:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,854,1389772800"; 
   d="scan'208";a="492379245"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [Patch v4 6/6] iio: Added ABI description for quaternion
Date: Sun, 13 Apr 2014 21:27:27 -0700
Message-Id: <1397449647-31708-6-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1397449647-31708-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1397449647-31708-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added documentation for reading quaternion components for 3D rotations.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 6e02c50..d2c59f9 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -784,6 +784,7 @@ What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_en
 What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_en
 What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_en
 What:		/sys/.../iio:deviceX/scan_elements/in_pressure_en
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_quaternion_en
 KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -799,6 +800,7 @@ What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_type
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_type
 What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_type
 What:		/sys/.../iio:deviceX/scan_elements/in_pressure_type
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_quaternion_type
 KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -845,6 +847,7 @@ What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index
 What:		/sys/.../iio:deviceX/scan_elements/in_pressureY_index
 What:		/sys/.../iio:deviceX/scan_elements/in_pressure_index
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_quaternion_index
 KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -891,3 +894,12 @@ Contact:	linux-iio@vger.kernel.org
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
1.9.1

