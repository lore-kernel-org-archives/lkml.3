Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3C2UfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:35:05 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63551 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab3C2UfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:35:04 -0400
Message-ID: <1364589301.1345.87.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix comment typo "CONFIG_CPUIDLE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 21:35:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 20:35:01.0811 (UTC) FILETIME=[E33B4830:01CE2CBC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. I'm far from sure what the comment tries to say, even after
applying this patch. At least it now uses an actual Kconfig macro! But
perhaps just dropping the CONFIG_ prefix makes more sense.

 arch/arm/mach-omap2/pm44xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index ea62e75..152a10c 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -126,8 +126,8 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *unused)
  * omap_default_idle - OMAP4 default ilde routine.'
  *
  * Implements OMAP4 memory, IO ordering requirements which can't be addressed
- * with default cpu_do_idle() hook. Used by all CPUs with !CONFIG_CPUIDLE and
- * by secondary CPU with CONFIG_CPUIDLE.
+ * with default cpu_do_idle() hook. Used by all CPUs with !CONFIG_CPU_IDLE and
+ * by secondary CPU with CONFIG_CPU_IDLE.
  */
 static void omap_default_idle(void)
 {
-- 
1.7.11.7

