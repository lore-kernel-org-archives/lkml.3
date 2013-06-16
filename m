Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3FPUGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 16:06:39 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57002 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3FPUGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 16:06:37 -0400
From: ddaney.cavm@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Cc: david.s.daney@gmail.com, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] Fix v3.10-rc6 failures in ia64 and mn10300
Date: Sun, 16 Jun 2013 13:06:27 -0700
Message-Id: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

My patch f21afc25f (smp.h: Use local_irq_{save,restore}() in !SMP
version of on_each_cpu().) seems to have broken ia64 and mn10300.

We can fix the breakage by resolving the unmet include dependencies.

David Daney (2):
  ia64: Fix include dependency in asm/irqflags.h
  mn10300: Fix include dependency in irqflags.h

 arch/ia64/include/asm/irqflags.h    | 1 +
 arch/mn10300/include/asm/irqflags.h | 3 ++-
 arch/mn10300/include/asm/smp.h      | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

-- 
1.7.11.7

