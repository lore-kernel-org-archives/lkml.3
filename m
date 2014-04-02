Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161012AbaDBWLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:11:07 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40024 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933392AbaDBWLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:11:04 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>, cody+local@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 0/2] powerpc/perf: fixup 2 patches from the 24x7 series
Date: Wed,  2 Apr 2014 15:10:52 -0700
Message-Id: <1396476654-20623-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040222-5806-0000-0000-000024811CF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpe: these are fixups for 2 patches already in your merge tree (and in benh's next branch).

f3e622941a7cec587c00c0d17ea31514457c63c8 powerpc/perf: Add support for the hv 24x7 interface
edd354ea4a6774bf9f380b0acf30e699070f4e8a powerpc/perf: Add support for the hv gpci (get performance counter info) interface

The only change is to a pr_info() printed when the interface is not detected.

Anton: I'm hesitant to switch these to pr_debug() as they are the only way
users expecting these PMUs to exist to tell why the kernel decided they didn't
have them. As a result, I've kept them as pr_info() instead of converting to
pr_debug().


Cody P Schafer (2):
  fixup: "powerpc/perf: Add support for the hv 24x7 interface"
  fixup: "powerpc/perf: Add support for the hv gpci (get performance
    counter info) interface"

 arch/powerpc/perf/hv-24x7.c | 2 +-
 arch/powerpc/perf/hv-gpci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.9.1

