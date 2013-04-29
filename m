Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab3D2SSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:18:24 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59515 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758400Ab3D2SSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:18:22 -0400
Date: Mon, 29 Apr 2013 19:18:19 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] EFI merge botch fix
Message-ID: <20130429181819.GA2254@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This commit fixes the merge botch I created when merging -rc8 into
tip/x86/efi, where I dropped the "select UCS2_STRING" string from
drivers/firmware/Kconfig. The string actually needs to be moved to
arch/ia64 because parts of the core EFI support in drivers/firmware/efi/
require the ucs2 string functions.

The following changes since commit e29c2de5f591490fd51225081e5d7579c6699247:

  Merge tag 'v3.9-rc8' into efi-for-tip (2013-04-22 12:53:22 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git efi-for-tip

for you to fetch changes up to da74caa6cead3f6c55dabcaa7b397b2fddd655e3:

  ia64, efi: select UCS2_STRING when building EFI support (2013-04-29 14:46:15 +0100)

----------------------------------------------------------------
Matt Fleming (1):
      ia64, efi: select UCS2_STRING when building EFI support

 arch/ia64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
Matt Fleming, Intel Open Source Technology Center
