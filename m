Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaAXNmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:42:17 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:49521 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaAXNmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:42:15 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ARC updates for 3.14 rc1
Thread-Topic: [GIT PULL] ARC updates for 3.14 rc1
Thread-Index: Ac8ZChN+hI/RG0sySqCTHXYkLMCSHQ==
Date: Fri, 24 Jan 2014 13:42:09 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307517963F@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.120]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull ARC changes for 3.14

Thx,
-Vineet

--------------->
The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-v3.14-rc1

for you to fetch changes up to e57d339a6264355df8c98948f05a46ff2bc5d504:

  ARC: [cmdline] support External Device Trees from u-boot (2014-01-16 18:53:16 +0530)

----------------------------------------------------------------
ARC changes for 3.14
* IPI optimization and cleanups
* Support for bootloader provided external Device Tree blobs

----------------------------------------------------------------
Vineet Gupta (7):
      ARC: [SMP] cpumask not needed in IPI send path
      ARC: [SMP] IPI ACK interface doesn't need "self" cpu-id
      ARC: [SMP] cpu halt interface doesn't need "self" cpu-id
      ARC: [SMP] simplify IPI code
      ARC: [SMP] optimize IPI send and receive
      ARC: [cmdline] uboot cmdline handling rework
      ARC: [cmdline] support External Device Trees from u-boot

 arch/arc/Kconfig            |  11 ----
 arch/arc/include/asm/smp.h  |   8 +--
 arch/arc/kernel/head.S      |  26 +++-------
 arch/arc/kernel/setup.c     |  48 ++++++++++++-----
 arch/arc/kernel/smp.c       | 124 +++++++++++++++++++++++++-------------------
 arch/arc/plat-arcfpga/smp.c |  12 ++---
 6 files changed, 121 insertions(+), 108 deletions(-)
