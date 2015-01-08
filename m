Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbbAHAej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:34:39 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:55709 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752389AbbAHAeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:34:37 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V3 5/7] arm64: dts: Add APM X-Gene SoC GFC GPIO controller DTS entries
Date: Wed,  7 Jan 2015 17:33:36 -0700
Message-Id: <1420677218-30743-6-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1420677218-30743-1-git-send-email-fkan@apm.com>
References: <1420677218-30743-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the flash controller muxed gpio dts node for APM X-Gene SoC platform.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm/apm-storm.dtsi |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
index a58f9a2..adea254 100644
--- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
@@ -540,6 +540,13 @@
 			};
 		};
 
+		gfcgpio: gpio0@1701c000 {
+			compatible = "apm,xgene-gpio";
+			reg = <0x0 0x1701c000 0x0 0x40>;
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
 		phy1: phy@1f21a000 {
 			compatible = "apm,xgene-phy";
 			reg = <0x0 0x1f21a000 0x0 0x100>;
-- 
1.7.1

