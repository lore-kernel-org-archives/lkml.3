Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaCTEjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:39:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30356 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaCTEi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:38:56 -0400
X-AuditID: cbfee68e-b7f566d000002344-b4-532a70de4c5d
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 3/4] ARM: S3C24XX: move S3C24XX clock Kconfig options to
 Samsung clock Kconfig file
Date: Thu, 20 Mar 2014 13:55:24 +0900
Message-id: <1395291325-4043-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
 <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42I5/e+Zke69Aq1gg1dvlCwmrTvAZNG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktnk64yGaxaOsXdov1M16zOHB6tDT3sHn8XfWC2ePOtT1s
	HpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxvlTu9gKZgtVnJ2/ib2B8RdfFyMnh4SA
	icTDg5MYIWwxiQv31rN1MXJxCAksY5Q4+PE4C0zR5ZfNrBCJRYwSz590QFW1MUm8/3uXFaSK
	TUBX4sn7ucwgtohAtsSlWbdYQIqYBZ4ySixdvxCsSFggQ2L+1D6wfSwCqhLbXh4Ha+AVcJc4
	93oqkM0BtE5BYs4kG5Awp4CHxJ3591kglrUySiz7sJwZxJEQ2MQu0T5pBdQgAYlvkw+xQDTL
	Smw6wAxxtqTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERIFfTsYbx6w
	PsSYDDRuIrOUaHI+MIrySuINjc2MLExNTI2NzC3NSBNWEudd9DApSEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVAMj37wg7qUP5wtvW5V6IV15l+Misal//ldaxoXf4Gdv7fk5o/z8xT9KKqI/
	OFdFfxSdm50xeXf8kfqmt5UPNy2POB8RcDyv+kq50+51/1iWxa1auKbzYoCJTWnfKfX0zZfb
	BH3874UI203e6pnY/vvhmzPL8+69XjE56lDEPY9tHwL2zl0Re47LWImlOCPRUIu5qDgRAJRu
	k7iYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jAd17BVrBBjO3y1lMWneAyaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaPJ1wkc1i0dYv7BbrZ7xmceD0aGnuYfP4u+oFs8eda3vY
	PDYvqffo27KK0ePzJrkAtqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnn
	T+1iK5gtVHF2/ib2BsZffF2MnBwSAiYSl182s0LYYhIX7q1n62Lk4hASWMQo8fxJB5TTxiTx
	/u9dsCo2AV2JJ+/nMoPYIgLZEpdm3WIBKWIWeMoosXT9QrAiYYEMiflT+xhBbBYBVYltL4+D
	NfAKuEucez0VyOYAWqcgMWeSDUiYU8BD4s78+ywQy1oZJZZ9WM48gZF3ASPDKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgGHsmtYNxZYPFIUYBDkYlHt4VezSDhVgTy4orcw8xSnAwK4nw
	WrtrBQvxpiRWVqUW5ccXleakFh9iTAa6aiKzlGhyPjD+80riDY1NzIwsjcwsjEzMzUkTVhLn
	PdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcdVLr/bTb370/ViyJmdH066//cLPTE8+XrbrzMtH
	dzn/ChpckQzd/lvlWD53auicE04bj6wNNe7UU78p7JiXszVuWV7hn4fNnev31AZXsM8LDA34
	n/Rv87SLiZrmU/leT43pYAiQ098r5XNKVtmsJapzh8jOggVdv3k2TmbtiBXO7du+VLEjRIml
	OCPRUIu5qDgRANKHlhj1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves S3C24XX specific clock Kconfig options into
"clk/samsung/Kconfig" and also removes COMMON_CLK selection from
"mach-s3c24xx/Kconfig" as S3C24XX_COMMON_CLK is selecting it's dependency.

CC: Ben Dooks <ben-linux@fluff.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Mike Turquette <mturquette@linaro.org>
CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-s3c24xx/Kconfig |   14 --------------
 drivers/clk/samsung/Kconfig   |    9 +++++++++
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 80373da..2d1232e 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -39,7 +39,6 @@ config CPU_S3C2410
 
 config CPU_S3C2412
 	bool "SAMSUNG S3C2412"
-	select COMMON_CLK
 	select CPU_ARM926T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2412_COMMON_CLK
@@ -50,7 +49,6 @@ config CPU_S3C2412
 
 config CPU_S3C2416
 	bool "SAMSUNG S3C2416/S3C2450"
-	select COMMON_CLK
 	select CPU_ARM926T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2416_PM if PM
@@ -88,7 +86,6 @@ config CPU_S3C244X
 
 config CPU_S3C2443
 	bool "SAMSUNG S3C2443"
-	select COMMON_CLK
 	select CPU_ARM920T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2443_COMMON_CLK
@@ -364,11 +361,6 @@ config S3C2412_PM_SLEEP
 
 if CPU_S3C2412
 
-config S3C2412_COMMON_CLK
-	bool
-	help
-	  Build the s3c2412 clock driver based on the common clock framework.
-
 config CPU_S3C2412_ONLY
 	bool
 	depends on !CPU_S3C2410 && !CPU_S3C2416 && !CPU_S3C2440 && \
@@ -651,12 +643,6 @@ endif	# CPU_S3C2442
 
 if CPU_S3C2443 || CPU_S3C2416
 
-config S3C2443_COMMON_CLK
-	bool
-	help
-	  Temporary symbol to build the clock driver based on the common clock
-	  framework.
-
 config S3C2443_DMA
 	bool
 	help
diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
index fc8696b..baf28cb 100644
--- a/drivers/clk/samsung/Kconfig
+++ b/drivers/clk/samsung/Kconfig
@@ -1,3 +1,12 @@
 config COMMON_CLK_SAMSUNG
 	bool
 	select COMMON_CLK
+
+config S3C2412_COMMON_CLK
+	bool
+	select COMMON_CLK_SAMSUNG
+
+config S3C2443_COMMON_CLK
+	bool
+	select COMMON_CLK_SAMSUNG
+
-- 
1.7.10.4

