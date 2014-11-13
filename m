Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaKMHY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:24:56 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44594 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaKMHYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:24:55 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark yao <mark.yao@rock-chips.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] clk: rockchip: add clock ID for usbphy480m_src
Date: Thu, 13 Nov 2014 15:22:36 +0800
Message-Id: <1415863357-15680-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 different parent clock from different usbphy,
all of them are fixed 480MHz, it is not able to auto select
by clock core to the 2nd and the 3rd parent.
For different use case for different board, we may need to
select different usbphy clock out as parent manually.

Add the clock ID for it so that we can use in dts.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 include/dt-bindings/clock/rk3288-cru.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 100a08c..3dcc906 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -71,6 +71,7 @@
 #define SCLK_HDMI_CEC		110
 #define SCLK_HEVC_CABAC		111
 #define SCLK_HEVC_CORE		112
+#define SCLK_USBPHY480M_SRC	113
 
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
-- 
1.9.1

