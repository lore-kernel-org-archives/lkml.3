Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935529Ab3BTOwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:52:17 -0500
Received: from multi.imgtec.com ([194.200.65.239]:49911 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182Ab3BTOwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:52:15 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <vgupta@synopsys.com>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/2] metag: copy flattened devicetree to non-init memory
Date: Wed, 20 Feb 2013 14:52:07 +0000
Message-ID: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_20_14_52_13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple more fixes for arch/metag which I'll try and get in
during the merge window. The first patch fixes a bug, where the fdt
isn't copied out of init memory so all the fdt strings will get poisoned
after init. The second patch is a trivial one.

James Hogan (2):
  metag: copy devicetree to non-init memory
  metag: prom.h: remove declaration of metag_dt_memblock_reserve()

 arch/metag/include/asm/prom.h |  2 +-
 arch/metag/kernel/devtree.c   | 17 +++++++++++++++++
 arch/metag/kernel/setup.c     |  2 ++
 3 files changed, 20 insertions(+), 1 deletion(-)

-- 
1.8.1.2


