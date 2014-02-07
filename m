Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaBGVdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:33:17 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:46232 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbaBGVdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:33:13 -0500
Subject: [PATCH v4 3/7] ARM: sunxi: clk: export clk_sunxi_mmc_phase_control
To: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?utf-8?b?TMOzcGV6?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
Date: Fri, 07 Feb 2014 22:33:04 +0100
Message-ID: <20140207213303.24624.48878.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20140207212709.24624.58619.stgit@dizzy-6.o2s.ch>
References: <20140207212709.24624.58619.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 include/linux/clk/sunxi.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 include/linux/clk/sunxi.h

diff --git a/include/linux/clk/sunxi.h b/include/linux/clk/sunxi.h
new file mode 100644
index 0000000..1ef5c89
--- /dev/null
+++ b/include/linux/clk/sunxi.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright 2013 - Hans de Goede <hdegoede@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_CLK_SUNXI_H_
+#define __LINUX_CLK_SUNXI_H_
+
+#include <linux/clk.h>
+
+void clk_sunxi_mmc_phase_control(struct clk_hw *hw, u8 sample, u8 output);
+
+#endif

