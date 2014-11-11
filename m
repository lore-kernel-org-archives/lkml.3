Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaKKSqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:46:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbaKKSqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:46:48 -0500
Date: Tue, 11 Nov 2014 19:46:42 +0100
From: Borislav Petkov <bp@suse.de>
To: x86-ml <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86: Two minor cleanups for 3.19
Message-ID: <20141111184642.GN31490@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

just two small cleanups which have been lying around for a while.

Please pull,
thanks.

---
The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/x86_queue_for_3.19

for you to fetch changes up to 6f9b63a0ae0d694e3d8e6f673e1e8e2638526b97:

  x86, CPU, AMD: Move K8 TLB flush filter workaround to K8 code (2014-11-11 17:58:20 +0100)

----------------------------------------------------------------
Two minor cleanups for the next merge window.

----------------------------------------------------------------
Borislav Petkov (2):
      x86, espfix: Remove stale ptemask
      x86, CPU, AMD: Move K8 TLB flush filter workaround to K8 code

 arch/x86/kernel/cpu/amd.c   | 23 +++++++++++------------
 arch/x86/kernel/espfix_64.c |  3 ---
 2 files changed, 11 insertions(+), 15 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
