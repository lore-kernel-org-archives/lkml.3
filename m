Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaCEQDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:03:46 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:45534 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817AbaCEQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:03:44 -0500
Date: Wed, 5 Mar 2014 16:03:32 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI mixed kbuild fixes
Message-ID: <20140305160332.GE17362@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, please pull the following two changes that fix build errors
reported by Fengguang's kbuild bot.

The following changes since commit 18c46461d9e42d398536055f31f58cdcd2c6347e:

  x86/efi: Re-disable interrupts after calling firmware services (2014-03-04 21:44:00 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git mixed-mode

for you to fetch changes up to 3db4cafdfd05717dc939780134e53023a3c1f15f:

  x86/boot: Fix non-EFI build (2014-03-05 10:19:07 +0000)

----------------------------------------------------------------
Matt Fleming (2):
      x86, tools: Fix up compiler warnings
      x86/boot: Fix non-EFI build

 arch/x86/boot/compressed/head_32.S | 2 ++
 arch/x86/boot/compressed/head_64.S | 3 +++
 arch/x86/boot/tools/build.c        | 7 ++++---
 3 files changed, 9 insertions(+), 3 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
