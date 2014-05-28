Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaE1VGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:06:32 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47313 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbaE1VG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:06:28 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com, linux-input@vger.kernel.org,
        jkosina@suse.cz
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH 1/3] IIO: Add iio magn_north ABI documentation
Date: Wed, 28 May 2014 16:06:13 -0500
Message-Id: <1401311175-12784-2-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation for HID compass true/magnetic north sensor.

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 76 +++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 6e02c50..0341b2f 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -165,6 +165,10 @@ Description:
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_raw
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_raw
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_tilt_comp_raw
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_tilt_comp_raw
 KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -249,6 +253,10 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_tilt_comp_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_tilt_comp_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
 KernelVersion:	2.6.35
@@ -436,6 +444,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_falling_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_thresh_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_thresh_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_thresh_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_rising_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_thresh_rising_en
@@ -481,6 +497,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_roc_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_y_roc_falling_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_roc_rising_en
 What:		/sys/.../iio:deviceX/events/in_magn_z_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_roc_falling_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_roc_rising_en
+What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_roc_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_rising_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_falling_en
 What:		/sys/.../iio:deviceX/events/in_voltageY_roc_rising_en
@@ -527,6 +551,14 @@ What:		/sys/.../events/in_magn_y_raw_thresh_rising_value
 What:		/sys/.../events/in_magn_y_raw_thresh_falling_value
 What:		/sys/.../events/in_magn_z_raw_thresh_rising_value
 What:		/sys/.../events/in_magn_z_raw_thresh_falling_value
+What:		/sys/.../events/in_magn_north_raw_thresh_rising_value
+What:		/sys/.../events/in_magn_north_raw_thresh_falling_value
+What:		/sys/.../events/in_magn_north_true_raw_thresh_rising_value
+What:		/sys/.../events/in_magn_north_true_raw_thresh_falling_value
+What:		/sys/.../events/in_magn_north_tilt_comp_raw_thresh_rising_value
+What:		/sys/.../events/in_magn_north_tilt_comp_raw_thresh_falling_value
+What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_thresh_rising_value
+What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_thresh_falling_value
 What:		/sys/.../events/in_voltageY_supply_raw_thresh_rising_value
 What:		/sys/.../events/in_voltageY_supply_raw_thresh_falling_value
 What:		/sys/.../events/in_voltageY_raw_thresh_rising_value
@@ -577,6 +609,18 @@ What:		/sys/.../events/in_magn_y_thresh_either_hysteresis
 What:		/sys/.../events/in_magn_z_thresh_rising_hysteresis
 What:		/sys/.../events/in_magn_z_thresh_falling_hysteresis
 What:		/sys/.../events/in_magn_z_thresh_either_hysteresis
+What:		/sys/.../events/in_magn_north_thresh_rising_hysteresis
+What:		/sys/.../events/in_magn_north_thresh_falling_hysteresis
+What:		/sys/.../events/in_magn_north_thresh_either_hysteresis
+What:		/sys/.../events/in_magn_north_true_thresh_rising_hysteresis
+What:		/sys/.../events/in_magn_north_true_thresh_falling_hysteresis
+What:		/sys/.../events/in_magn_north_true_thresh_either_hysteresis
+What:		/sys/.../events/in_magn_north_tilt_comp_thresh_rising_hysteresis
+What:		/sys/.../events/in_magn_north_tilt_comp_thresh_falling_hysteresis
+What:		/sys/.../events/in_magn_north_tilt_comp_thresh_either_hysteresis
+What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_rising_hysteresis
+What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_falling_hysteresis
+What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_either_hysteresis
 What:		/sys/.../events/in_voltageY_thresh_rising_hysteresis
 What:		/sys/.../events/in_voltageY_thresh_falling_hysteresis
 What:		/sys/.../events/in_voltageY_thresh_either_hysteresis
@@ -624,6 +668,14 @@ What:		/sys/.../events/in_magn_y_raw_roc_rising_value
 What:		/sys/.../events/in_magn_y_raw_roc_falling_value
 What:		/sys/.../events/in_magn_z_raw_roc_rising_value
 What:		/sys/.../events/in_magn_z_raw_roc_falling_value
+What:		/sys/.../events/in_magn_north_raw_roc_rising_value
+What:		/sys/.../events/in_magn_north_raw_roc_falling_value
+What:		/sys/.../events/in_magn_north_true_raw_roc_rising_value
+What:		/sys/.../events/in_magn_north_true_raw_roc_falling_value
+What:		/sys/.../events/in_magn_north_tilt_comp_raw_roc_rising_value
+What:		/sys/.../events/in_magn_north_tilt_comp_raw_roc_falling_value
+What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_roc_rising_value
+What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_roc_falling_value
 What:		/sys/.../events/in_voltageY_supply_raw_roc_rising_value
 What:		/sys/.../events/in_voltageY_supply_raw_roc_falling_value
 What:		/sys/.../events/in_voltageY_raw_roc_rising_value
@@ -679,6 +731,22 @@ What:		/sys/.../events/in_magn_z_thresh_rising_period
 What:		/sys/.../events/in_magn_z_thresh_falling_period
 What:		/sys/.../events/in_magn_z_roc_rising_period
 What:		/sys/.../events/in_magn_z_roc_falling_period
+What:		/sys/.../events/in_magn_north_thresh_rising_period
+What:		/sys/.../events/in_magn_north_thresh_falling_period
+What:		/sys/.../events/in_magn_north_roc_rising_period
+What:		/sys/.../events/in_magn_north_roc_falling_period
+What:		/sys/.../events/in_magn_north_true_thresh_rising_period
+What:		/sys/.../events/in_magn_north_true_thresh_falling_period
+What:		/sys/.../events/in_magn_north_true_roc_rising_period
+What:		/sys/.../events/in_magn_north_true_roc_falling_period
+What:		/sys/.../events/in_magn_north_tilt_comp_thresh_rising_period
+What:		/sys/.../events/in_magn_north_tilt_comp_thresh_falling_period
+What:		/sys/.../events/in_magn_north_tilt_comp_roc_rising_period
+What:		/sys/.../events/in_magn_north_tilt_comp_roc_falling_period
+What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_rising_period
+What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_falling_period
+What:		/sys/.../events/in_magn_north_true_tilt_comp_roc_rising_period
+What:		/sys/.../events/in_magn_north_true_tilt_comp_roc_falling_period
 What:		/sys/.../events/in_voltageY_supply_thresh_rising_period
 What:		/sys/.../events/in_voltageY_supply_thresh_falling_period
 What:		/sys/.../events/in_voltageY_supply_roc_rising_period
@@ -776,6 +844,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_en
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_en
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_en
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_en
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_en
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_en
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_tilt_comp_en
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_tilt_comp_en
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_en
 What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_en
 What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_en
@@ -840,6 +912,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_index
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_index
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_index
 What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_index
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_index
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_index
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_tilt_comp_index
+What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_tilt_comp_index
 What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_index
 What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
 What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index
-- 
1.9.3

