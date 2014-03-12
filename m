Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaCLEQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:16:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaCLEQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:16:51 -0400
X-AuditID: cbfee68f-b7f156d00000276c-ac-531fdfb087b8
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 2/4] drivers: clk: use CONFIG_COMMON_CLK_SAMSUNG for Samsung
 clock support
Date: Wed, 12 Mar 2014 13:32:59 +0900
Message-id: <1394598781-3848-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zQ90N9+WDDf5v57XY9Pgaq8XlXXPY
	LGac38dksWjrF3YHFo/NS+o9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Pm2tWMBW85K86+
	XcHSwLiRo4uRk0NCwERi14vpzBC2mMSFe+vZuhi5OIQEljFKzFt4igWmqPv1TnYQW0hgOqPE
	pauJEEVtTBL/5razgSTYBHQlnryfCzZJRCBb4tKsW2DNzALaEpP3toA1CwvESyx5doYJxGYR
	UJW433oTLM4r4C7R1D4DyOYAWqYgMWeSDUiYU8BDYufPU4wQe90ldh2CuEFC4DObxOK3RhBj
	BCS+TT7EAtEqK7HpANQvkhIHV9xgmcAovICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZG
	SLj272C8e8D6EGMy0LiJzFKiyfnAcM8riTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYziGb9D5xfuSjERfz+1tO5+44d9lf8vl6+XvZAotb1xiuKJ
	tV/5jWS2Hb5yruaVk5BgwR2p+wVTn0RLZtwten1iY5BSxTKju6dXfq7p3fCQ1/rTxkIPlz1T
	Z7NXupxlmylzl+uQY2q48r1FksE+itwl3Dt4osSWntvF8fb+t1brdWenvD6wZcZlJZbijERD
	Leai4kQAT1RVBm0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd0N9+WDDf585bTY9Pgaq8XlXXPY
	LGac38dksWjrF3YHFo/NS+o9+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj5trVjAVvOSvOvl3B0sC4kaOLkZNDQsBEovv1TnYIW0ziwr31bCC2kMB0
	RolLVxO7GLmA7DYmiX9z28ESbAK6Ek/ez2UGsUUEsiUuzbrFAmIzC2hLTN7bAjZIWCBeYsmz
	M0wgNouAqsT91ptgcV4Bd4mm9hlANgfQMgWJOZNsQMKcAh4SO3+eYoTY6y6x69BO9gmMvAsY
	GVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfDM+kdjKsaLA4xCnAwKvHwLtSUDxZiTSwr
	rsw9xCjBwawkwvsRJMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wFjNK4k3NDYxM7I0MrMw
	MjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGl6/e3hHXwpXuuPOEPVLr/fK5wupA
	/qnYuQeffJCImXvdI9TwaMBcHweO1qPlLzUt3Hqqp7y+PrvkedOe+OulOqm+ts3efROOxaTc
	z27bbL9A8HAJ/78s9eTwbRcyhARNj9U5OcT5vpy0fvfaVKtHr0T3/agTjWFyXHd0Xn3hvgf+
	zAUrPK4qsRRnJBpqMRcVJwIAxhtydssCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes Samsung clock Kconfig file, and replaces PLAT_SAMSUNG
with COMMON_CLK_SAMSUNG for Samsung common clock support.
Any Samsung SoC want to use Samsung common clock infrastructure can simply
select COMMON_CLK_SAMSUNG.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/Kconfig  |    2 ++
 drivers/clk/Makefile |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 7641965..f2b6179 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -112,3 +112,5 @@ source "drivers/clk/qcom/Kconfig"
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
+
+source "drivers/clk/samsung/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index a367a98..f1da6ee 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_PLAT_ORION)		+= mvebu/
 obj-$(CONFIG_ARCH_MXS)			+= mxs/
 obj-$(CONFIG_COMMON_CLK_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
-obj-$(CONFIG_PLAT_SAMSUNG)		+= samsung/
+obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
 obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= shmobile/
 obj-$(CONFIG_ARCH_SIRF)			+= sirf/
 obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
-- 
1.7.9.5

