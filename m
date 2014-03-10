Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaCJR1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:27:15 -0400
Received: from ring0.de ([5.45.105.125]:40664 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbaCJR0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:26:30 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv3 8/9] iio: documentation: Add ABI documentation for *_mean_raw
Date: Mon, 10 Mar 2014 18:25:28 +0100
Message-Id: <1394472329-15485-9-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394472329-15485-1-git-send-email-sre@debian.org>
References: <1394472329-15485-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ABI documentation for in_*_mean_raw files, which are
already supported and used in the kernel for some time.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 Documentation/ABI/testing/sysfs-bus-iio | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 6e02c50..58ba333 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -210,6 +210,14 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		Scaled humidity measurement in milli percent.
 
+What:		/sys/bus/iio/devices/iio:deviceX/in_X_mean_raw
+KernelVersion:	3.5
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Averaged raw measurement from channel X. The number of values
+		used for averaging is device specific. The converting rules for
+		normal raw values also applies to the averaged raw values.
+
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_x_offset
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
-- 
1.9.0

