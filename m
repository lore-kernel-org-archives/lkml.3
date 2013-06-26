Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3FZMXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:23:37 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38750 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab3FZMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:23:34 -0400
Date: Wed, 26 Jun 2013 13:23:31 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI changes for v3.11
Message-ID: <20130626122331.GK22026@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d3768d885c6ccbf8a137276843177d76c49033a7:

  x86, efi: retry ExitBootServices() on failure (2013-06-11 07:51:54 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 5d32cf1e590bcdc879f8f862e836c542f6ba7ecb:

  [IA64] sim: Add casts to avoid assignment warnings (2013-06-21 11:22:21 +0100)

----------------------------------------------------------------
 * Add casts to avoid compiler warnings about assignments making
   pointers from integers of different types. The warnings were
   introduced with Borislav's patch to move the EFI runtime service
   pointers to void * - Tony Luck

----------------------------------------------------------------
Tony Luck (1):
      [IA64] sim: Add casts to avoid assignment warnings

 arch/ia64/hp/sim/boot/fw-emu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
