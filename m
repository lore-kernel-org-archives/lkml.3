Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaBINsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:48:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47103 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaBINse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:48:34 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 0/3] MSR cleanups
Date: Sun,  9 Feb 2014 14:48:26 +0100
Message-Id: <1391953709-15400-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi guys,

this is just a preview of what I think we talked about. I'm sending it
out now to gather some feedback before I go and test it more thoroughly
(it boots in a guest though :)).

Thanks.

Borislav Petkov (3):
  x86: Add another set of MSR accessor functions
  x86, AMD: Convert to the new MSR accessors
  x86, intel: Convert to the new MSR accessors

 arch/x86/include/asm/msr.h            |   2 +
 arch/x86/include/uapi/asm/msr-index.h |   6 +-
 arch/x86/kernel/cpu/amd.c             |  46 ++++-----------
 arch/x86/kernel/cpu/intel.c           |  29 +++------
 arch/x86/lib/msr.c                    | 107 +++++++++++++++++++++++++++++++++-
 5 files changed, 131 insertions(+), 59 deletions(-)

-- 
1.8.5.2.192.g7794a68

