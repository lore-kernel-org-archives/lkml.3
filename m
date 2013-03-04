Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3CDUQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:16:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55838 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab3CDUQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:16:36 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/5] x86: Misc fixlets
Date: Mon,  4 Mar 2013 21:16:15 +0100
Message-Id: <1362428180-8865-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi guys,

below a couple of minor fixlets and cleanups which have accumulated in
the last months.

Thanks.

Borislav Petkov (5):
  x86, smpboot: Remove unused variable
  x86: Drop KERNEL_IMAGE_START
  x86-64, docs, mm: Add vsyscall range to virtual address space layout
  x86, msr: Unify variable names
  x86, quirks: Shut-up a long-standing gcc warning

 Documentation/x86/x86_64/mm.txt      |  4 +++-
 arch/x86/include/asm/msr.h           | 14 +++++++-------
 arch/x86/include/asm/page_64_types.h |  1 -
 arch/x86/kernel/head64.c             |  6 +++---
 arch/x86/kernel/quirks.c             | 18 +++++++++++-------
 arch/x86/kernel/smpboot.c            |  3 +--
 6 files changed, 25 insertions(+), 21 deletions(-)

-- 
1.8.1.3.535.ga923c31

