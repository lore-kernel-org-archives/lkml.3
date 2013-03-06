Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab3CFP2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:28:45 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:34087 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757500Ab3CFP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:28:41 -0500
Message-ID: <1362583718.15011.89.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: [GIT PULL] EFI changes for v3.9-rc2
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Date: Wed, 06 Mar 2013 15:28:38 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

The following changes since commit feff5dc4f98330d8152b521acc2e18c16712e6c8:

  efivarfs: return accurate error code in efivarfs_fill_super() (2013-03-06 14:46:30 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-for-3.9-rc2

for you to fetch changes up to feff5dc4f98330d8152b521acc2e18c16712e6c8:

  efivarfs: return accurate error code in efivarfs_fill_super() (2013-03-06 14:46:30 +0000)

----------------------------------------------------------------
EFI changes for v3.9-rc2,

  * Make the EFI variable code more paranoid about running out of
    space in NVRAM, since this is the root cause of the recent issue
    where machines refuse to boot - from Matthew Garrett.

  * Some efivarfs patches that fix regressions introduced in v3.9-rc1.

----------------------------------------------------------------

-- 
Matt Fleming, Intel Open Source Technology Center

