Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaEWWX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:23:58 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38538 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbaEWWX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:23:56 -0400
Date: Fri, 23 May 2014 23:23:52 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [GIT PULL] EFI changes for arm64
Message-ID: <20140523222352.GB23963@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin reports that the arm64 EFI changes in tip/arm64/efi are causing
boot issues when trying to run on a non-EFI machine. The below fix from
Leif skips the EFI code on such machines.

The following changes since commit 345c736edd07b657a8c48190baed2719b85d0938:

  efi/arm64: ignore dtb= when UEFI SecureBoot is enabled (2014-04-30 19:57:06 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git arm64-efi

for you to fetch changes up to 74bcc2499291d38b6253f9dbd6af33a195222208:

  arm64: efi: only attempt efi map setup if booting via EFI (2014-05-23 15:29:43 +0100)

----------------------------------------------------------------
Leif Lindholm (1):
      arm64: efi: only attempt efi map setup if booting via EFI

 arch/arm64/kernel/efi.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
Matt Fleming, Intel Open Source Technology Center
