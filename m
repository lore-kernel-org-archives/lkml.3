Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaE0N1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:27:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52048 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaE0N1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:27:19 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 0/3] RAS: Correctable Errors Collector thing
Date: Tue, 27 May 2014 15:27:12 +0200
Message-Id: <1401197235-13440-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

this is something Tony and I have been working on behind the curtains
recently. Here it is in a RFC form, it passes quick testing in kvm. Let
me send it out before I start hammering on it on a real machine.

More indepth info about what it is and what it does is in patch 1/3.

As always, comments and suggestions are most welcome.

Thanks.

Borislav Petkov (3):
  MCE, CE: Corrected errors collecting thing
  MCE, CE: Wire in the CE collector
  MCE, CE: Add debugging glue

 arch/x86/include/asm/mce.h          |   4 +
 arch/x86/kernel/cpu/mcheck/Makefile |   2 +-
 arch/x86/kernel/cpu/mcheck/ce.c     | 305 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c    |  93 ++++++++++-
 4 files changed, 395 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/ce.c

-- 
1.9.0

