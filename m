Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761064Ab3D2Tpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:45:35 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:50163 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761048Ab3D2Tpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:45:32 -0400
Date: Mon, 29 Apr 2013 15:49:28 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf: fix typo in perf_event_intel_uncore.c
Message-ID: <alpine.DEB.2.02.1304291546590.15827@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sandy Bridge was misspelled.  Either that or the Intel marketing names
are getting even more obscure.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

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
