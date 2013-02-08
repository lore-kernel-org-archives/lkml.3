Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824Ab3BHKqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:46:51 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:48179 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964783Ab3BHKqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:46:50 -0500
From: Vijay Kumar Mishra <vijay.kumar@st.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <spear-devel@codex.cro.st.com>, <viresh.kumar@linaro.org>,
        Vijay Kumar Mishra <vijay.kumar@st.com>
Subject: [PATCH 2/3] ARM:dts:SPEAr1310:Correct the clcd pin group name
Date: Fri, 8 Feb 2013 16:16:30 +0530
Message-ID: <4854ebf7198ff341d699372cf569210a6f0b363b.1360317993.git.vijay.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1360317993.git.vijay.kumar@st.com>
References: <cover.1360317993.git.vijay.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to correct clcd pin group name "clcd_high_res" to
"clcd_high_res_grp" to avoid kernel boot hang as with following error message.

spear1310-pinmux e0700000.pinmux: invalid group "clcd_high_res" for function
"clcd".
---
 arch/arm/boot/dts/spear1310-evb.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear1310-evb.dts b/arch/arm/boot/dts/spear1310-evb.dts
index b56a801..6fd4c36 100644
--- a/arch/arm/boot/dts/spear1310-evb.dts
+++ b/arch/arm/boot/dts/spear1310-evb.dts
@@ -47,7 +47,7 @@
 					st,function = "arm_gpio";
 				};
 				clcd {
-					st,pins = "clcd_grp" , "clcd_high_res";
+					st,pins = "clcd_grp", "clcd_high_res_grp";
 					st,function = "clcd";
 				};
 				eth {
-- 
1.7.9.5

