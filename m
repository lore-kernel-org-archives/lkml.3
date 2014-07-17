Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaGQJqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:46:02 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61902 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756006AbaGQJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:45:59 -0400
Message-ID: <1405590357.4808.15.camel@x220>
Subject: [PATCH] ARM: tegra: Fix comment typo 'CONFIG_SLEEP'
From: Paul Bolle <pebolle@tiscali.nl>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 11:45:57 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2014 09:45:57.0654 (UTC) FILETIME=[E8EBC360:01CFA1A3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested! Please shout if that bothers you.

This typo entered linux-next as of today (in next-20140717). Its fix
would be fine for the trivial tree, if trivial would track linux-next.
But it doesn't.

 include/linux/tegra-soc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index 197aa5bd66d2..25caa520b784 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -81,7 +81,7 @@ void tegra_pmc_restart(enum reboot_mode mode, const char *cmd);
 enum tegra_suspend_mode tegra_pmc_get_suspend_mode(void);
 void tegra_pmc_set_suspend_mode(enum tegra_suspend_mode mode);
 void tegra_pmc_enter_suspend_mode(enum tegra_suspend_mode mode);
-#endif /* CONFIG_SLEEP */
+#endif /* CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_SMP
 bool tegra_pmc_cpu_is_powered(int cpuid);
-- 
1.9.3

