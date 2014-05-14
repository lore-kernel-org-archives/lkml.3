Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaENWdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:33:17 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37963 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaENWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:33:14 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [RFC PATCH 4/5] ARM: zynq: dt: Use properly rounded frequencies in OPPs
Date: Wed, 14 May 2014 15:30:54 -0700
Message-Id: <1400106655-22465-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.3.1.ga73a6ad
In-Reply-To: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some issues in regards to rounding and different frequency resolution in
the cpufreq and common clock frameworks have been resolved and allow
specifying Zynq's OPPs with properly rounded values.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

 arch/arm/boot/dts/zynq-7000.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index c1176abc34d9..06de3068ab21 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -28,8 +28,8 @@
 			operating-points = <
 				/* kHz    uV */
 				666667  1000000
-				333334  1000000
-				222223  1000000
+				333333  1000000
+				222222  1000000
 			>;
 		};
 
-- 
1.9.3.1.ga73a6ad

