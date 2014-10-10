Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaJJV02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:26:28 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45980 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJJV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:26:25 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/6] ARM: dts: rockchip: use the same pmu node name as before
Date: Fri, 10 Oct 2014 14:26:06 -0700
Message-Id: <1412976370-14468-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com>
References: <1412976370-14468-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the "rockchip,rk3066-pmu" for rk3288 instead of creat
a new one.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v3:
- add this patch in version 3

Changes in v2: None

 arch/arm/boot/dts/rk3288.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 874e66d..06f39be 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -440,7 +440,7 @@
 	};
 
 	pmu: power-management@ff730000 {
-		compatible = "rockchip,rk3288-pmu", "syscon";
+		compatible = "rockchip,rk3066-pmu", "syscon";
 		reg = <0xff730000 0x100>;
 	};
 
-- 
1.9.1

