Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261Ab3BNT2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:28:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58754 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644Ab3BNT2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:28:41 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/2] x86: Make Linux guest support optional
Date: Thu, 14 Feb 2013 20:28:28 +0100
Message-Id: <1360870110-4778-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi all,

two patches which make hypervisor glue for Linux running as a guest
ontop optional.

@hpa: this is against tip/master of today which also includes
tip:x86/hyperv.

Thanks.

Borislav Petkov (2):
  x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu
  x86: Make Linux guest support optional

 arch/x86/Kconfig                  | 89 ++++++++++++++++++++-------------------
 arch/x86/include/asm/hypervisor.h | 16 ++++---
 arch/x86/kernel/cpu/Makefile      |  3 +-
 arch/x86/lguest/Kconfig           |  3 +-
 arch/x86/xen/Kconfig              |  2 +-
 drivers/hv/Kconfig                |  2 +-
 drivers/misc/Kconfig              |  2 +-
 7 files changed, 62 insertions(+), 55 deletions(-)

-- 
1.8.1.3.535.ga923c31

