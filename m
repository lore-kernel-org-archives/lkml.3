Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaHTVGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:06:02 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3607 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaHTVF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:05:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Aug 2014 13:56:19 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        <devicetree@vger.kernel.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v4 15/16] ARM: tegra: Add CPU regulator to the Jetson TK1 device tree
Date: Thu, 21 Aug 2014 00:04:43 +0300
Message-ID: <1408568684-11016-16-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
References: <1408568684-11016-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the CPU voltage regulator for the cpufreq driver.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v3: New patch
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 04134da..5250be5 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1890,3 +1890,7 @@
 		};
 	};
 };
+
+&cpu0 {
+	vdd-cpu-supply = <&vdd_cpu>;
+};
-- 
1.8.1.5

