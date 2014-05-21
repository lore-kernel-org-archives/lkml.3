Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaEUFza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:55:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaEUFzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:55:24 -0400
Date: Tue, 20 May 2014 22:55:13 -0700
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-21a8b756b84ecaa0b7f29199669c151e2ce5e723@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, jean.pihet@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, jean.pihet@linaro.org, tglx@linutronix.de
In-Reply-To: <1400229672-16104-1-git-send-email-jean.pihet@linaro.org>
References: <1400229672-16104-1-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Consolidate types.h for ARM and ARM64
Git-Commit-ID: 21a8b756b84ecaa0b7f29199669c151e2ce5e723
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21a8b756b84ecaa0b7f29199669c151e2ce5e723
Gitweb:     http://git.kernel.org/tip/21a8b756b84ecaa0b7f29199669c151e2ce5e723
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Fri, 16 May 2014 10:41:09 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 16 May 2014 11:38:57 +0200

perf tools: Consolidate types.h for ARM and ARM64

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
