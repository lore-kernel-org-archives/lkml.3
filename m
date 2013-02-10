Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3BJF7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:59:55 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:35329 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3BJF6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:51 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 14/16] unicore32 idle: delete stray pm_idle comment
Date: Sun, 10 Feb 2013 00:58:21 -0500
Message-Id: <bfaf706ccad77c19b119b243b349bfc5cd1f7f38.1360475150.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360475903-30007-1-git-send-email-lenb@kernel.org>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

as pm_idle() has already been deleted from this code,
the comment was a stray.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/kernel/process.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 62bad9f..872d7e2 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -45,11 +45,6 @@ static const char * const processor_modes[] = {
 	"UK18", "UK19", "UK1A", "EXTN", "UK1C", "UK1D", "UK1E", "SUSR"
 };
 
-/*
- * The idle thread, has rather strange semantics for calling pm_idle,
- * but this is what x86 does and we need to do the same, so that
- * things like cpuidle get called in the same way.
- */
 void cpu_idle(void)
 {
 	/* endless idle loop with no priority at all */
-- 
1.8.1.3.535.ga923c31

