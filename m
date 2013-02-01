Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3BAL6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:58:25 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31914 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab3BAL6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:58:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/6] metag: misc & priv patches
Date: Fri, 1 Feb 2013 11:49:04 +0000
Message-ID: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_01_11_58_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some additional metag patches I intend to add on top of the
existing v4 arch/metag patchset.

James Hogan (6):
  metag: add __init to metag_cache_probe()
  metag: add boot time LNKGET/LNKSET check
  perf: Enable building perf tools for Meta
  metag: kernel/setup.c: sort includes
  metag: make TXPRIVEXT bits explicit
  metag: protect more non-MMU memory regions

 arch/metag/include/asm/metag_regs.h |    4 +
 arch/metag/include/asm/processor.h  |    2 +-
 arch/metag/kernel/setup.c           |  125 +++++++++++++++++++++++++----------
 arch/metag/kernel/smp.c             |    2 +-
 arch/metag/mm/cache.c               |   81 ++++++++++++++++++++++-
 tools/perf/perf.h                   |    6 ++
 6 files changed, 182 insertions(+), 38 deletions(-)

-- 
1.7.7.6


