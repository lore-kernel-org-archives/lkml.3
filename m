Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaACWcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:32:00 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:49943 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbaACWb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:31:59 -0500
Date: Fri, 3 Jan 2014 22:31:41 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI kexec fixes
Message-ID: <20140103223141.GB18441@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, please pull these fixes for the EFI kexec patches sitting in
tip/x86/efi-kexec - the kbuild bot reported some build breakage.

The following changes since commit 518548abd61808ea1e31614ccbdae34d3c32dfa4:

  x86/efi: Delete superfluous global variables (2013-12-29 13:09:08 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git kexec

for you to fetch changes up to 5c12af0c41e3417e1939095325920463b5f8e726:

  x86/efi: parse_efi_setup() build fix (2014-01-03 14:38:18 +0000)

----------------------------------------------------------------
Dave Young (2):
      x86: ksysfs.c build fix
      x86/efi: parse_efi_setup() build fix

 arch/x86/include/asm/efi.h | 5 ++---
 arch/x86/kernel/ksysfs.c   | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
