Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaGITbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:31:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39194 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbaGITaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:30:21 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH v5 1/4] iio: Documentation: Add documentation for rotation from north sensor usage attributes
Date: Wed,  9 Jul 2014 14:30:10 -0500
Message-Id: <1404934213-2733-2-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404934213-2733-1-git-send-email-reyad.attiyat@gmail.com>
References: <1404934213-2733-1-git-send-email-reyad.attiyat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added documentation for the sysfs attributes supported by the rotation from north
sensor.

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 82 +++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index a9757dc..995642f 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -260,6 +260,10 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_magnetic_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_magnetic_tilt_comp_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_tilt_comp_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
 KernelVersion:	2.6.35
@@ -447,6 +451,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_falling_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_tilt_comp_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_tilt_comp_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_tilt_comp_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_tilt_comp_thresh_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_rising_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_thresh_rising_en
@@ -492,6 +504,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_roc_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_y_roc_falling_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_roc_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_tilt_comp_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_magnetic_tilt_comp_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_tilt_comp_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_rot_from_north_true_tilt_comp_roc_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_rising_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_roc_rising_en
@@ -538,6 +558,14 @@ What:		/sys/.../events/in_magn_y_raw_thresh_rising_value
 What:		/sys/.../events/in_magn_y_raw_thresh_falling_value
 What:		/sys/.../events/in_magn_z_raw_thresh_rising_value
 What:		/sys/.../events/in_magn_z_raw_thresh_falling_value
+What:		/sys/.../events/in_rot_from_north_magnetic_raw_thresh_rising_value
+What:		/sys/.../events/in_rot_from_north_magnetic_raw_thresh_falling_value
+What:		/sys/.../events/in_rot_from_north_true_raw_thresh_rising_value
+What:		/sys/.../events/in_rot_from_north_true_raw_thresh_falling_value
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_raw_thresh_rising_value
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_raw_thresh_falling_value
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_raw_thresh_rising_value
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_raw_thresh_falling_value
 What:		/sys/.../events/in_voltageY_supply_raw_thresh_rising_value
 What:		/sys/.../events/in_voltageY_supply_raw_thresh_falling_value
 What:		/sys/.../events/in_voltageY_raw_thresh_rising_value
@@ -588,6 +616,18 @@ What:		/sys/.../events/in_magn_y_thresh_either_hysteresis
 What:		/sys/.../events/in_magn_z_thresh_rising_hysteresis
 What:		/sys/.../events/in_magn_z_thresh_falling_hysteresis
 What:		/sys/.../events/in_magn_z_thresh_either_hysteresis
+What:		/sys/.../events/in_rot_from_north_magnetic_thresh_rising_hysteresis
+What:		/sys/.../events/in_rot_from_north_magnetic_thresh_falling_hysteresis
+What:		/sys/.../events/in_rot_from_north_magnetic_thresh_either_hysteresis
+What:		/sys/.../events/in_rot_from_north_true_thresh_rising_hysteresis
+What:		/sys/.../events/in_rot_from_north_true_thresh_falling_hysteresis
+What:		/sys/.../events/in_rot_from_north_true_thresh_either_hysteresis
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_thresh_rising_hysteresis
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_thresh_falling_hysteresis
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_thresh_either_hysteresis
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_thresh_rising_hysteresis
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_thresh_falling_hysteresis
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_thresh_either_hysteresis
 What:		/sys/.../events/in_voltageY_thresh_rising_hysteresis
 What:		/sys/.../events/in_voltageY_thresh_falling_hysteresis
 What:		/sys/.../events/in_voltageY_thresh_either_hysteresis
@@ -635,6 +675,14 @@ What:		/sys/.../events/in_magn_y_raw_roc_rising_value
 What:		/sys/.../events/in_magn_y_raw_roc_falling_value
 What:		/sys/.../events/in_magn_z_raw_roc_rising_value
 What:		/sys/.../events/in_magn_z_raw_roc_falling_value
+What:		/sys/.../events/in_rot_from_north_magnetic_raw_roc_rising_value
+What:		/sys/.../events/in_rot_from_north_magnetic_raw_roc_falling_value
+What:		/sys/.../events/in_rot_from_north_true_raw_roc_rising_value
+What:		/sys/.../events/in_rot_from_north_true_raw_roc_falling_value
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_raw_roc_rising_value
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_raw_roc_falling_value
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_raw_roc_rising_value
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_raw_roc_falling_value
 What:		/sys/.../events/in_voltageY_supply_raw_roc_rising_value
 What:		/sys/.../events/in_voltageY_supply_raw_roc_falling_value
 What:		/sys/.../events/in_voltageY_raw_roc_rising_value
@@ -690,6 +738,22 @@ What:		/sys/.../events/in_magn_z_thresh_rising_period
 What:		/sys/.../events/in_magn_z_thresh_falling_period
 What:		/sys/.../events/in_magn_z_roc_rising_period
 What:		/sys/.../events/in_magn_z_roc_falling_period
+What:		/sys/.../events/in_rot_from_north_magnetic_thresh_rising_period
+What:		/sys/.../events/in_rot_from_north_magnetic_thresh_falling_period
+What:		/sys/.../events/in_rot_from_north_magnetic_roc_rising_period
+What:		/sys/.../events/in_rot_from_north_magnetic_roc_falling_period
+What:		/sys/.../events/in_rot_from_north_true_thresh_rising_period
+What:		/sys/.../events/in_rot_from_north_true_thresh_falling_period
+What:		/sys/.../events/in_rot_from_north_true_roc_rising_period
+What:		/sys/.../events/in_rot_from_north_true_roc_falling_period
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_thresh_rising_period
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_thresh_falling_period
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_roc_rising_period
+What:		/sys/.../events/in_rot_from_north_magnetic_tilt_comp_roc_falling_period
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_thresh_rising_period
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_thresh_falling_period
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_roc_rising_period
+What:		/sys/.../events/in_rot_from_north_true_tilt_comp_roc_falling_period
 What:		/sys/.../events/in_voltageY_supply_thresh_rising_period
 What:		/sys/.../events/in_voltageY_supply_thresh_falling_period
 What:		/sys/.../events/in_voltageY_supply_roc_rising_period
@@ -787,6 +851,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_en
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_en
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_en
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_en
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_magnetic_en
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_true_en
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_magnetic_tilt_comp_en
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_true_tilt_comp_en
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_en
 What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_en
 What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_en
@@ -853,6 +921,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_index
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_index
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_index
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_index
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_magnetic_index
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_true_index
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_magnetic_tilt_comp_index
+What:		/sys/.../iio:deviceX/scan_elements/in_rot_from_north_true_tilt_comp_index
 What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_index
 What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index
@@ -933,3 +1005,13 @@ Description:
 		x y z w. Here x, y, and z component represents the axis about
 		which a rotation will occur and w component represents the
 		amount of rotation.
+
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_magnetic_tilt_comp_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_tilt_comp_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_magnetic_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_raw
+KernelVersion:	3.15
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Raw value of rotation from true/magnetic north measured with
+		or without compensation from tilt sensors.
-- 
1.9.3

