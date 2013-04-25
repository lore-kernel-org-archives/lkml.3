Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3DYItP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:49:15 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:40115 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab3DYItN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:49:13 -0400
Message-ID: <5178EE06.8020107@console-pimps.org>
Date: Thu, 25 Apr 2013 09:49:10 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EFI urgent fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

The following changes since commit 8c58bf3eec3b8fc8162fe557e9361891c20758f2:

  x86,efi: Implement efi_no_storage_paranoia parameter (2013-04-17 15:13:38 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to f697036b93aa7345d4cbb3c854a76456c0ddac45:

  efi: Check EFI revision in setup_efi_vars (2013-04-24 16:19:01 +0100)

----------------------------------------------------------------
 * The EFI variable anti-bricking algorithm merged in -rc8 broke booting
   on some Apple machines because they implement EFI spec 1.10, which
   doesn't provide a QueryVariableInfo() runtime function and the logic
   used to check for the existence of that function was insufficient.
   Fix from Josh Boyer.

 * The anti-bricking algorithm also introduced a compiler warning on
   32-bit. Fix from Borislav Petkov.

----------------------------------------------------------------
Borislav Petkov (1):
      x86, efi: Fix a build warning

Josh Boyer (1):
      efi: Check EFI revision in setup_efi_vars

 arch/x86/boot/compressed/eboot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
