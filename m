Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030258Ab3FUJ4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:56:32 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39046 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab3FUJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:56:31 -0400
Date: Fri, 21 Jun 2013 10:56:28 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI urgent fix
Message-ID: <20130621095628.GD5386@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f8b8404337de4e2466e2e1139ea68b1f8295974f:

  Modify UEFI anti-bricking code (2013-06-10 21:59:37 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to b8cb62f82103083a6e8fa5470bfe634a2c06514d:

  x86/efi: Fix dummy variable buffer allocation (2013-06-21 10:52:49 +0100)

----------------------------------------------------------------
 * Don't leak random kernel memory to EFI variable NVRAM when attempting
   to initiate garbage collection. Also, free the kernel memory when
   we're done with it instead of leaking - Ben Hutchings

----------------------------------------------------------------
Ben Hutchings (1):
      x86/efi: Fix dummy variable buffer allocation

 arch/x86/platform/efi/efi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
Matt Fleming, Intel Open Source Technology Center
