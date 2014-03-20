Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaCTEjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:39:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56433 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTEiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:38:51 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-dd-532a70dbb815
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 1/4] clk: samsung: add new Kconfig for Samsung common clock
 option
Date: Thu, 20 Mar 2014 13:55:22 +0900
Message-id: <1395291325-4043-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t8zI93bBVrBBnubuC02Pb7GanF51xw2
	ixnn9zFZPJ1wkc1i0dYv7BbrZ7xmcWDzuHNtD5vH5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJWxf+ozpoKP7BX9Cw+zNDBeYOti5OSQEDCRmLv1ASOELSZx4d56oDgXh5DAMkaJLaub
	WLsYOcCK/i2uhIgvYpQ4MO0bM4TTxiTx4ewyZpBuNgFdiSfv54LZIgLZEpdm3WIBsZkFyiWu
	HXvHDmILC4RL/HnZAWazCKhKHFq/GczmFXCXaG/7BbVMQWLOJBuQMKeAh8Sd+fdZIHa1Mkos
	+7AcbLGEQDe7xK6FX1kgBglIfJt8iAWiWVZi0wFmiG8kJQ6uuMEygVF4ASPDKkbR1ILkguKk
	9CJDveLE3OLSvHS95PzcTYyQgO7dwXj7gPUhxmSgcROZpUST84ERkVcSb2hsZmRhamJqbGRu
	aUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNv+iP+PN1V0O7vZ0PCE1945
	URL3LSY8meK2Y11fbP585sVfivWl1rZLn+tlryjeq9J3ov32lqxNa+dXMp9ZsqDW86Xtnq8H
	307yyvK8VvjBS9/icoBJmp6+UeE6xT2etvMmBrPt9Mjc/mD9IW2LlINL3Sd5y4mEbuN7qZnw
	ZdG97TnMQbxTFJVYijMSDbWYi4oTAYJUn2N+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jAd3bBVrBBlensVtsenyN1eLyrjls
	FjPO72OyeDrhIpvFoq1f2C3Wz3jN4sDmcefaHjaPzUvqPfq2rGL0+LxJLoAlqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY//UZ0wFH9kr+hceZmlgvMDWxcjBISFgIvFv
	cWUXIyeQKSZx4d56oDAXh5DAIkaJA9O+MUM4bUwSH84uYwapYhPQlXjyfi6YLSKQLXFp1i0W
	EJtZoFzi2rF37CC2sEC4xJ+XHWA2i4CqxKH1m8FsXgF3ifa2X6wQixUk5kyyAQlzCnhI3Jl/
	nwViVyujxLIPy5knMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcL8+kdjCubLA4
	xCjAwajEw7tij2awEGtiWXFl7iFGCQ5mJRFea3etYCHelMTKqtSi/Pii0pzU4kOMyUBXTWSW
	Ek3OB8ZyXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwdic8
	/uj8M0FxZeMzlR3HN6k96dst8yx/zQ+F2K2nE5fk/ty+bM4HY65ql7bp9lszY+9mWZfxTez7
	yKNjVMSx88Zhl7t8KQE7r2q0mYdeusO1Zj7Ldm9H06hEuReH+D+u0vWZ9mLy29x3u70vly6u
	fsf76+uC/HYWD5Fj0/r/3Xsn/FOlZ82bq0osxRmJhlrMRcWJAJGgVPjbAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new Kconfig file for adding new COMMON_CLK_SAMSUNG option.
Samsung platforms can select this for using common clock infrastructure.

CC: Tomasz Figa <t.figa@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/clk/Kconfig         |    2 ++
 drivers/clk/samsung/Kconfig |    3 +++
 2 files changed, 5 insertions(+)
 create mode 100644 drivers/clk/samsung/Kconfig

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 7641965..f2b6179 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -112,3 +112,5 @@ source "drivers/clk/qcom/Kconfig"
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
+
+source "drivers/clk/samsung/Kconfig"
diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
new file mode 100644
index 0000000..fc8696b
--- /dev/null
+++ b/drivers/clk/samsung/Kconfig
@@ -0,0 +1,3 @@
+config COMMON_CLK_SAMSUNG
+	bool
+	select COMMON_CLK
-- 
1.7.10.4

