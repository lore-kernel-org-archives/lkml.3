Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab3CSXd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:33:27 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:62937 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756759Ab3CSXd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:33:26 -0400
Message-ID: <1363736001.1390.53.camel@x61.thuisdomein>
Subject: [PATCH] blackfin: bf60x: fix typo "CONFIG_PM_BFIN_WAKE_PA15_POL"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 00:33:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 23:33:21.0471 (UTC) FILETIME=[249854F0:01CE24FA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Obvious, isn't it? Introduced in v3.5, through commit
0fbd88ca20a68a633b565e1f5ba18ca64afb0c78 ("blackfin: bf60x: add wakeup
source select"). Untested.

 arch/blackfin/mach-bf609/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/blackfin/mach-bf609/pm.c b/arch/blackfin/mach-bf609/pm.c
index ad505d9..0cdd695 100644
--- a/arch/blackfin/mach-bf609/pm.c
+++ b/arch/blackfin/mach-bf609/pm.c
@@ -210,7 +210,7 @@ void bf609_cpu_pm_enter(suspend_state_t state)
 
 #ifdef CONFIG_PM_BFIN_WAKE_PB15
 	wakeup |= PB15WE;
-# if CONFIG_PM_BFIN_WAKE_PA15_POL
+# if CONFIG_PM_BFIN_WAKE_PB15_POL
 	wakeup_pol |= PB15WE;
 # endif
 #endif
-- 
1.7.11.7

