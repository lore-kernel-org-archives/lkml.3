Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaIYQdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:33:22 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:59488 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaIYQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:53 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3 12/13] ARM: shmobile: r8a7740 dtsi: Add preliminary PM domain latencies
Date: Thu, 25 Sep 2014 18:28:39 +0200
Message-Id: <1411662520-22795-13-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now use 250 µs, just like the legacy platform code does.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v3:
  - New, split off from "ARM: shmobile: r8a7740 dtsi: Add PM domain
    support".

 arch/arm/boot/dts/r8a7740.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
index 4fead480a405bebe..ed0adeb61a1ad8ec 100644
--- a/arch/arm/boot/dts/r8a7740.dtsi
+++ b/arch/arm/boot/dts/r8a7740.dtsi
@@ -563,16 +563,22 @@
 				pd_a4lc: a4lc@1 {
 					reg = <1>;
 					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
 				};
 
 				pd_a4mp: a4mp@2 {
 					reg = <2>;
 					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
 				};
 
 				pd_d4: d4@3 {
 					reg = <3>;
 					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
 				};
 
 				pd_a4r: a4r@5 {
@@ -580,10 +586,14 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
 
 					pd_a3rv: a3rv@6 {
 						reg = <6>;
 						#power-domain-cells = <0>;
+						power-on-latency = <250000>;
+						power-off-latency = <250000>;
 					};
 				};
 
@@ -592,26 +602,36 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
 
 					pd_a3sp: a3sp@11 {
 						reg = <11>;
 						#power-domain-cells = <0>;
+						power-on-latency = <250000>;
+						power-off-latency = <250000>;
 					};
 
 					pd_a3sm: a3sm@12 {
 						reg = <12>;
 						#power-domain-cells = <0>;
+						power-on-latency = <250000>;
+						power-off-latency = <250000>;
 					};
 
 					pd_a3sg: a3sg@13 {
 						reg = <13>;
 						#power-domain-cells = <0>;
+						power-on-latency = <250000>;
+						power-off-latency = <250000>;
 					};
 				};
 
 				pd_a4su: a4su@20 {
 					reg = <20>;
 					#power-domain-cells = <0>;
+					power-on-latency = <250000>;
+					power-off-latency = <250000>;
 				};
 			};
 		};
-- 
1.9.1

