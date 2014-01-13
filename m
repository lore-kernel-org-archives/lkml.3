Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaAMQaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:30:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaAMQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 134/208] arm64: Remove unused cpu_name ascii in arch/arm64/mm/proc.S
Date: Mon, 13 Jan 2014 15:59:35 +0000
Message-Id: <1389628849-1614-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit f3a1d7d53dccf51959aec16b574617cc6bfeca09 upstream.

This string has been moved to arch/arm64/kernel/cputable.c.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/mm/proc.S | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index a82ae88..f84fcf7 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -95,10 +95,6 @@ ENTRY(cpu_do_switch_mm)
 	ret
 ENDPROC(cpu_do_switch_mm)
 
-cpu_name:
-	.ascii	"AArch64 Processor"
-	.align
-
 	.section ".text.init", #alloc, #execinstr
 
 /*
-- 
1.8.3.2

