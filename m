Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaL2JoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:44:05 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:47179 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaL2JoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:44:03 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: roger.chen@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: roger.chen@rock-chips.com
X-UNIQUE-TAG: <e16c26ddf3aec4440dcd721d1ea46365>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Roger Chen <roger.chen@rock-chips.com>
To: heiko@sntech.de
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, eddie.cai@rock-chips.com,
        roger.chen@rock-chips.com
Subject: [PATCH v3 2/6] GMAC: define clock ID used for GMAC
Date: Mon, 29 Dec 2014 17:43:55 +0800
Message-Id: <1419846235-14603-1-git-send-email-roger.chen@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419846152-14531-1-git-send-email-roger.chen@rock-chips.com>
References: <1419846152-14531-1-git-send-email-roger.chen@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes since v2:
1. remove SCLK_MAC_PLL

Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
---
 include/dt-bindings/clock/rk3288-cru.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 100a08c..81eb35b 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -72,6 +72,9 @@
 #define SCLK_HEVC_CABAC		111
 #define SCLK_HEVC_CORE		112
 
+#define SCLK_MAC		151
+#define SCLK_MACREF_OUT		152
+
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
 
-- 
1.7.9.5


