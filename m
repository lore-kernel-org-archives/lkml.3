Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbaESMbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbaESMbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:31:11 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5/8] perf tools: Consolidate types.h for ARM and ARM64
Date: Mon, 19 May 2014 14:30:53 +0200
Message-Id: <1400502656-20751-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
References: <1400502656-20751-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@linaro.org>

Prevents a build breakage since commit d944c4eebcf4c0d5e5d9728fec110cbf0047ad7f
'tools: Consolidate types.h'

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Link: http://lkml.kernel.org/r/1400229672-16104-1-git-send-email-jean.pihet@linaro.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
1.8.3.1

