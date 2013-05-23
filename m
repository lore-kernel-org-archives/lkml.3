Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3EWBRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:17:14 -0400
Received: from [216.32.181.186] ([216.32.181.186]:42044 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757006Ab3EWBQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:16:53 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1155h)
X-WSS-ID: 0MN88U2-01-HUC-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 0/2] x86/microcode: early microcode patch loading support on AMD
Date: Wed, 22 May 2013 20:15:32 -0500
Message-ID: <1369271734-3231-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset adds early microcode patch loading support on
AMD systems, on top of the framework introduced by:
  https://lkml.org/lkml/2012/12/21/193

Jacob Shin (2):
  x86/microcode: vendor abstract out save_microcode_in_initrd()
  x86/microcode: early microcode patch loading support on AMD

 arch/x86/Kconfig                        |   14 +-
 arch/x86/include/asm/microcode_amd.h    |   14 ++
 arch/x86/include/asm/microcode_intel.h  |    2 +
 arch/x86/kernel/microcode_amd.c         |  335 +++++++++++++++++++++++++++----
 arch/x86/kernel/microcode_core_early.c  |   17 ++
 arch/x86/kernel/microcode_intel_early.c |    2 +-
 6 files changed, 337 insertions(+), 47 deletions(-)
 create mode 100644 arch/x86/include/asm/microcode_amd.h

-- 
1.7.9.5


