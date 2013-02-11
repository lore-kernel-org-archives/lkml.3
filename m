Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3BKLSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:18:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34198 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab3BKLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:18:48 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 0/4] x86, cpu: Expand ->x86_capability flags with bugs bitvector
Date: Mon, 11 Feb 2013 12:18:37 +0100
Message-Id: <1360581521-4712-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

so this is a rough first version to collect some initial comments. It is
lightly tested in kvm.

Thanks.

Borislav Petkov (4):
  x86, cpu: Expand cpufeature facility to include cpu bugs
  x86, cpu: Convert F00F bug detection
  x86, cpu: Convert FDIV bug detection
  x86, cpu: Convert Cyrix coma bug detection

 arch/x86/include/asm/cpufeature.h | 38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h  |  6 +-----
 arch/x86/kernel/alternative.c     |  2 +-
 arch/x86/kernel/cpu/bugs.c        |  5 +++--
 arch/x86/kernel/cpu/common.c      |  4 ++++
 arch/x86/kernel/cpu/cyrix.c       |  5 +++--
 arch/x86/kernel/cpu/intel.c       |  4 ++--
 arch/x86/kernel/cpu/proc.c        |  6 +++---
 arch/x86/mm/fault.c               |  2 +-
 9 files changed, 56 insertions(+), 16 deletions(-)

-- 
1.8.1.3.535.ga923c31

