Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaG3UBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:01:07 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:49549 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaG3UAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:00:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Kever Yang <kever.yang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ARM: dts: Enable USB host0 (EHCI) on rk3288-evb
Date: Wed, 30 Jul 2014 13:00:12 -0700
Message-Id: <1406750412-15592-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406750412-15592-1-git-send-email-dianders@chromium.org>
References: <1406750412-15592-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the top USB port on the evb (the one closest to the Ethernet
connector).

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---
Changes in v2: None

 arch/arm/boot/dts/rk3288-evb.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index e6c5b03..4f57209 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -90,3 +90,7 @@
 		};
 	};
 };
+
+&usb_host0_ehci {
+	status = "okay";
+};
-- 
2.0.0.526.g5318336

