Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaCKKW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:22:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48784 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaCKKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:22:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/3] ARM: STi: stih416-b2020: Explicitly include STiH416 Pinctrl bindings
Date: Tue, 11 Mar 2014 10:22:03 +0000
Message-Id: <1394533324-20299-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
References: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment we're relying on inheriting them from DTSI files which
we're including Ideally we should be specifying these for ourselves.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416-b2020-revE.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
index bcb9d00..4168b019 100644
--- a/arch/arm/boot/dts/stih416-b2020-revE.dts
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -8,6 +8,7 @@
  */
 /dts-v1/;
 #include "stih416.dtsi"
+#include "stih416-pinctrl.dtsi"
 #include "stih41x-b2020.dtsi"
 / {
         model = "STih416 B2020 REV. E";
-- 
1.8.3.2

