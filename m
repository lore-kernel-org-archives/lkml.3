Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaCKKWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:22:21 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45739 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaCKKWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:22:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/3] ARM: STi: stih41x: Provide a proper header for this DTSI file
Date: Tue, 11 Mar 2014 10:22:04 +0000
Message-Id: <1394533324-20299-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
References: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also explicitly include STiH416 Clk bindings instead of relying on
inheriting them from other DTSI files which we happen to include.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih41x.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/stih41x.dtsi b/arch/arm/boot/dts/stih41x.dtsi
index f5b9898..32730e5 100644
--- a/arch/arm/boot/dts/stih41x.dtsi
+++ b/arch/arm/boot/dts/stih41x.dtsi
@@ -1,3 +1,11 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih416-clock.dtsi"
 / {
 	#address-cells = <1>;
 	#size-cells = <1>;
-- 
1.8.3.2

