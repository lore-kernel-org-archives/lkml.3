Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3GDGYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:24:43 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:1918
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab3GDGYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:24:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bh8275dhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <mikey@neuling.org>,
        <benh@kernel.crashing.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <agraf@suse.de>
CC: Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 0/2] powerpc: allow kvm to use kerel debug framework
Date: Thu, 4 Jul 2013 11:45:44 +0530
Message-ID: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharat Bhushan <bharat.bhushan@freescale.com>

This patchset moves the debug registers in a structure, which allows
kvm to use same structure for debug emulation.

Note: Earilier a patchset "https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-June/108132.html"
was sent which is a bunch of six patches. That patchset is divided into two parts:
	1) powerpc specific changes (These 2 patches are actually have those changes)
	2) KVM specific changes (will send separate patch on agraf repository)

Bharat Bhushan (2):
  powerpc: remove unnecessary line continuations
  powerpc: move debug registers in a structure

 arch/powerpc/include/asm/processor.h |   38 +++++----
 arch/powerpc/include/asm/reg_booke.h |    8 +-
 arch/powerpc/kernel/asm-offsets.c    |    2 +-
 arch/powerpc/kernel/process.c        |   42 +++++-----
 arch/powerpc/kernel/ptrace.c         |  154 +++++++++++++++++-----------------
 arch/powerpc/kernel/ptrace32.c       |    2 +-
 arch/powerpc/kernel/signal_32.c      |    6 +-
 arch/powerpc/kernel/traps.c          |   35 ++++----
 8 files changed, 147 insertions(+), 140 deletions(-)


