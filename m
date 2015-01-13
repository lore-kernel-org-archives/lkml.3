Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbbAMOM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:12:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbbAMOM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:12:58 -0500
Date: Tue, 13 Jan 2015 15:12:55 +0100
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 cleanups for 3.20
Message-ID: <20150113141255.GB5784@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

here just a bunch of minor cleanups for 3.20.

Please pull,
thanks.

---
The following changes since commit b1940cd21c0f4abdce101253e860feff547291b0:

  Linux 3.19-rc3 (2015-01-05 17:05:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/x86_queue

for you to fetch changes up to b34630014dad0ba69aadd8deb231ddc6d2efcf53:

  x86, early_serial_console: Remove unnecessary check (2015-01-13 12:14:44 +0100)

----------------------------------------------------------------
Minor cleanups.

----------------------------------------------------------------
Alexander Kuleshov (3):
      x86, setup: Rename BOOT_ISDIGIT_H to BOOT_CTYPE_H
      x86, early_serial_console: Remove unused macro XMTRDY
      x86, early_serial_console: Remove unnecessary check

Steven Honeyman (1):
      x86, CPU: Fix trivial printk formatting issues with dmesg

 arch/x86/boot/ctype.h                |  5 ++---
 arch/x86/boot/early_serial_console.c |  6 ++----
 arch/x86/kernel/cpu/common.c         | 13 +++++++------
 arch/x86/kernel/cpu/intel.c          |  6 ++----
 4 files changed, 13 insertions(+), 17 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
