Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab3CDUUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:20:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51820 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab3CDUUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:20:36 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/2] x86: Make Linux guest support optional
Date: Mon,  4 Mar 2013 21:20:19 +0100
Message-Id: <1362428421-9244-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

two patches which make hypervisor glue for Linux running as a guest
ontop optional. Same patches from before but rebased ontop of v3.9-rc1.

Thanks.

Borislav Petkov (2):
  x86, Kconfig: Move PARAVIRT_DEBUG into the paravirt menu
  x86: Make Linux guest support optional

 arch/x86/Kconfig                  | 89 ++++++++++++++++++++-------------------
 arch/x86/include/asm/hypervisor.h | 16 ++++---
 arch/x86/kernel/cpu/Makefile      |  3 +-
 arch/x86/lguest/Kconfig           |  3 +-
 arch/x86/xen/Kconfig              |  2 +-
 drivers/hv/Kconfig                |  2 +-
 drivers/misc/Kconfig              |  2 +-
 7 files changed, 62 insertions(+), 55 deletions(-)

-- 
1.8.1.3.535.ga923c31

