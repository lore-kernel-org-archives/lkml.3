Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaF3Ocd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:32:33 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:65066 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbaF3Occ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:32:32 -0400
Message-ID: <1404138749.2978.6.camel@x41>
Subject: [PATCH] x86: remove unused variable "polling"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 16:32:29 +0200
In-Reply-To: <1402926791.16903.4.camel@x41>
References: <20140603120752.GA26873@gmail.com>
	 <1402926791.16903.4.camel@x41>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jun 2014 14:32:29.0887 (UTC) FILETIME=[1F4494F0:01CF9470]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested. "polling" is unused since commit f80c5b39b80a
("sched/idle, x86: Switch from TS_POLLING to TIF_POLLING_NRFLAG").
Apparently this trivial cleanup isn't yet queued anywhere. 

 arch/x86/kernel/apm_32.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index f3a1f04..5848744 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -841,7 +841,6 @@ static int apm_do_idle(void)
 	u32 eax;
 	u8 ret = 0;
 	int idled = 0;
-	int polling;
 	int err = 0;
 
 	if (!need_resched()) {
-- 
1.9.3

