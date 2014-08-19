Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaHSDlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:41:13 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:35842 "EHLO
	script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaHSDjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:39:46 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2014 23:39:37 EDT
X-DKIM: Courier DKIM Filter v0.50+pk-2014-03-23 mail.cs.helsinki.fi Tue, 19 Aug 2014 06:34:12 +0300
From: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, Vince Hsu <vinceh@nvidia.com>,
        devicetree@vger.kernel.org, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 15/15] ARM: tegra: Add CPU regulator to the Jetson TK1 device tree
Date: Tue, 19 Aug 2014 06:33:25 +0300
Message-Id: <1408419205-10048-16-git-send-email-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

Add the CPU voltage regulator for the cpufreq driver.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
v3: New patch
---
 arch/arm/boot/dts/tegra124-jetson-tk1.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
index 0c30450..4be7c82 100644
--- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
+++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
@@ -1858,3 +1858,7 @@
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
+
+&cpu0 {
+	vdd-cpu-supply = <&vdd_cpu>;
+};
-- 
1.8.1.5

