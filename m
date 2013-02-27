Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab3B0DyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:54:11 -0500
Received: from intranet.asianux.com ([58.214.24.6]:48171 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3B0DyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:54:09 -0500
X-Spam-Score: -100.8
Message-ID: <512D834E.4000703@asianux.com>
Date: Wed, 27 Feb 2013 11:53:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: tglx@linutronix.de, "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        x86@kernel.org, "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        jarkko.sakkinen@intel.com,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/x86/kernel: beautify code, delete unused local variable
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  local variable c is not used, so deleted.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/x86/kernel/smpboot.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a6ceaed..7bc998a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1367,7 +1367,6 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_subcstate = 0;
 	int i;
 	void *mwait_ptr;
-	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
-- 
1.7.7.6
