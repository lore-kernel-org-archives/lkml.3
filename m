Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3H1Kwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:52:30 -0400
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:40932 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3H1Kw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:52:28 -0400
From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@globallogic.com
Cc: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: [PATCH v5 1/2] staging: iio: Documentation sysfs-bus-iio add power_mode
Date: Wed, 28 Aug 2013 13:51:48 +0300
Message-Id: <1377687110-5632-1-git-send-email-o.v.kravchenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description about in_accelX_power_mode and
in_accel_power_mode_available.

Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
---
 Documentation/ABI/testing/sysfs-bus-iio |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index dda81ff..1a333f3 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -792,3 +792,13 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		This attribute is used to read the amount of quadrature error
 		present in the device at a given time.
+
+What:		/sys/.../iio:deviceX/in_accelX_power_mode
+KernelVersion:	3.11
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Specifies the chip power mode.
+		low_noise: reduce noise level from ADC,
+		low_power: enable low current consumption.
+		For a list of available output power modes read
+		in_accel_power_mode_available.
-- 
1.7.9.5

