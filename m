Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3ISMmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:42:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56293 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914Ab3ISMmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:42:13 -0400
Date: Thu, 19 Sep 2013 13:41:59 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI urgent fix
Message-ID: <20130919124159.GA4785@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 700870119f49084da004ab588ea2b799689efaf7:

  x86, efi: Don't map Boot Services on i386 (2013-09-18 14:42:33 +0100)

----------------------------------------------------------------
 * Fix WARNING on i386 by only enabling a workaround for x86-64 since
   we've never encountered the bug on i386 - Josh Boyer

----------------------------------------------------------------
Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

 arch/x86/platform/efi/efi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
