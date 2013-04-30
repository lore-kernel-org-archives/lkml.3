Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084Ab3D3QrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:47:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58351 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760898Ab3D3QrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:47:20 -0400
Date: Tue, 30 Apr 2013 09:46:41 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-80e217e9ca98a99d6ee95c8f4473b7ebf6d1b8ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1304291546590.15827@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1304291546590.15827@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Fix typo in perf_event_intel_uncore.c
Git-Commit-ID: 80e217e9ca98a99d6ee95c8f4473b7ebf6d1b8ca
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

Commit-ID:  80e217e9ca98a99d6ee95c8f4473b7ebf6d1b8ca
Gitweb:     http://git.kernel.org/tip/80e217e9ca98a99d6ee95c8f4473b7ebf6d1b8ca
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Mon, 29 Apr 2013 15:49:28 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 10:56:44 +0200

perf/x86/intel: Fix typo in perf_event_intel_uncore.c

Sandy Bridge was misspelled.  Either that or the Intel marketing
names are getting even more obscure.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1304291546590.15827@vincent-weaver-1.um.maine.edu
[ Haha ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b43200d..0d5ec6d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2857,7 +2857,7 @@ static int __init uncore_cpu_init(void)
 			snb_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snb_msr_uncores;
 		break;
-	case 45: /* Sandy Birdge-EP */
+	case 45: /* Sandy Bridge-EP */
 		if (snbep_uncore_cbox.num_boxes > max_cores)
 			snbep_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = snbep_msr_uncores;
