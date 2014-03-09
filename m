Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaCIRFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:05:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33379 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaCIRFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:05:30 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/3] MSR cleanups, v2
Date: Sun,  9 Mar 2014 18:05:22 +0100
Message-Id: <1394384725-10796-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Here's v2, all feedback from last time should be addressed. Patches boot
fine on an Intel and AMD box.

I've also got them in a nice pullable form, if that is preferred:

--
The following changes since commit b01d4e68933ec23e43b1046fa35d593cefcf37d1:

  x86: fix compile error due to X86_TRAP_NMI use in asm files (2014-03-07 18:58:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/msrs

for you to fetch changes up to b685c3e2f627f7c800aa4a34bd6f8438eaed8b3b:

  x86, Intel: Convert to the new MSR accessors (2014-03-09 12:06:50 +0100)

----------------------------------------------------------------
Aggregation of MSR toggling bits functionality into common functions.

----------------------------------------------------------------
Borislav Petkov (3):
      x86: Add another set of MSR accessor functions
      x86, AMD: Convert to the new MSR accessors
      x86, Intel: Convert to the new MSR accessors

 arch/x86/include/asm/msr.h            |  2 +
 arch/x86/include/uapi/asm/msr-index.h |  9 ++--
 arch/x86/kernel/cpu/amd.c             | 48 +++++--------------
 arch/x86/kernel/cpu/intel.c           | 30 +++---------
 arch/x86/lib/msr.c                    | 89 ++++++++++++++++++++++++++++++++++-
 5 files changed, 115 insertions(+), 63 deletions(-)



Changelog:
---------

v1:

Hi guys,

this is just a preview of what I think we talked about. I'm sending it
out now to gather some feedback before I go and test it more thoroughly
(it boots in a guest though :)).

Thanks.

-- 
1.9.0

