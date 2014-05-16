Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbaEPIl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:41:29 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58114 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaEPIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:41:26 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 1/4] tools: perf: consolidate types.h for ARM and ARM64
Date: Fri, 16 May 2014 10:41:09 +0200
Message-Id: <1400229672-16104-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <CAFrcx1mkE-N+DYUe0ZK06_BL1tsZvmyMHpAynnFkgZBqjghE5Q@mail.gmail.com>
References: <CAFrcx1mkE-N+DYUe0ZK06_BL1tsZvmyMHpAynnFkgZBqjghE5Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevents a build breakage since commit d944c4eebcf4c0d5e5d9728fec110cbf0047ad7f
'tools: Consolidate types.h'

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/arch/arm/include/perf_regs.h   | 2 +-
 tools/perf/arch/arm64/include/perf_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
index 2a1cfde..bcca511 100644
--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -2,7 +2,7 @@
 #define ARCH_PERF_REGS_H
 
 #include <stdlib.h>
-#include "../../util/types.h"
+#include <linux/types.h>
 #include <asm/perf_regs.h>
 
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
diff --git a/tools/perf/arch/arm64/include/perf_regs.h b/tools/perf/arch/arm64/include/perf_regs.h
index 2359546..e9441b9 100644
--- a/tools/perf/arch/arm64/include/perf_regs.h
+++ b/tools/perf/arch/arm64/include/perf_regs.h
@@ -2,7 +2,7 @@
 #define ARCH_PERF_REGS_H
 
 #include <stdlib.h>
-#include "../../util/types.h"
+#include <linux/types.h>
 #include <asm/perf_regs.h>
 
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM64_MAX) - 1)
-- 
1.7.11.7

