Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaCLONM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:13:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46062 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaCLONK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:13:10 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] x86: Misc small fixes
Date: Wed, 12 Mar 2014 15:13:01 +0100
Message-Id: <1394633584-5509-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Here are a couple of minor fixlets which accumulated recently.

Borislav Petkov (3):
  x86, boot: Correct max ramdisk size name
  x86, crash: Unify ifdef
  x86, pageattr: Correct WBINVD spelling in comment

 Documentation/x86/boot.txt | 4 ++--
 arch/x86/boot/header.S     | 2 +-
 arch/x86/kernel/crash.c    | 2 --
 arch/x86/mm/pageattr.c     | 6 +++---
 4 files changed, 6 insertions(+), 8 deletions(-)

-- 
1.9.0

