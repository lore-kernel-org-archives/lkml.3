Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887Ab3DHLPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:15:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38763 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895Ab3DHLPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:15:30 -0400
Message-ID: <5162A6D0.6060107@console-pimps.org>
Date: Mon, 08 Apr 2013 12:15:28 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EFI changes for v3.9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

There's a couple of minor changes sitting in the 'next' branch that I've been
holding off sending until v3.9, just because this release cycle has been kinda
busy with bug fixes. Please consider pulling.

The following changes since commit 6b59e366e074d3962e04f01efb8acc10a33c0e1e:

  x86, efi: remove duplicate code in setup_arch() by using, efi_is_native() (2013-02-14 10:36:18 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next

for you to fetch changes up to 15b9c359f288b09003cb70f7ed204affc0c6614d:

  x86, efi: Make efi_memblock_x86_reserve_range more readable (2013-03-04 15:23:56 +0000)

----------------------------------------------------------------
Borislav Petkov (1):
      x86, efi: Make efi_memblock_x86_reserve_range more readable

Wei Yongjun (1):
      efivarfs: convert to use simple_open()

 arch/x86/platform/efi/efi.c |   19 ++++++++++---------
 drivers/firmware/efivars.c  |    8 +-------
 2 files changed, 11 insertions(+), 16 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
