Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3BRFGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:06:22 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48586 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3BRFGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:06:20 -0500
Message-ID: <5121B6C9.70001@kernel.org>
Date: Mon, 18 Feb 2013 00:06:17 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benson Leung <bleung@chromium.org>
CC: colin.king@canonical.com, linux-kernel@vger.kernel.org, vapier@gentoo.org
Subject: Re: [PATCH v3 1/1] tools/power x86_energy_perf_policy: fix cpuid
 for i686
References: <1360870558-11711-1-git-send-email-bleung@chromium.org> <1360870558-11711-2-git-send-email-bleung@chromium.org>
In-Reply-To: <1360870558-11711-2-git-send-email-bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

checkpatch.pl doesn't love this syntax:

ERROR: spaces required around that ':' (ctx:ExV)
#113: FILE: tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c:142:
+		      :"+a" (_eax), "=S" (_ebx), "=c" (_ecx), "=d" (_edx)
 		      ^

ERROR: spaces required around that ':' (ctx:ExV)
#115: FILE: tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c:144:
+		      :"edi" /* clobbers: we hit edi directly */);
 		      ^

ERROR: trailing statements should be on next line
#116: FILE: tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c:145:
+	if (eax) *eax = _eax;

ERROR: trailing statements should be on next line
#117: FILE: tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c:146:
+	if (ebx) *ebx = _ebx;

ERROR: trailing statements should be on next line
#118: FILE: tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c:147:
+	if (ecx) *ecx = _ecx;

ERROR: trailing statements should be on next line
#119: FILE: tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c:148:
+	if (edx) *edx = _edx;

total: 6 errors, 2 warnings, 57 lines checked

/home/lenb/Documents/epp.eml has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
Commit Body is:
--------------------------
tools/power x86_energy_perf_policy: fix cpuid for i686

