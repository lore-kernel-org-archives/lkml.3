Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaBGPm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:42:59 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:49163 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbaBGPm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:42:58 -0500
Date: Fri, 7 Feb 2014 15:42:53 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Urgent fix
Message-ID: <20140207154253.GA2887@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Please pull the following which fixes an issue people are hitting on
Baytrail platforms.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 081cd62a010f97b5bc1d2b0cd123c5abc692b68a:

  x86/efi: Allow mapping BGRT on x86-32 (2014-02-05 23:39:34 +0000)

----------------------------------------------------------------
 * Avoid WARN_ON() when mapping BGRT on Baytrail (EFI 32-bit).

----------------------------------------------------------------
Matt Fleming (1):
      x86/efi: Allow mapping BGRT on x86-32

 arch/x86/platform/efi/efi-bgrt.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
