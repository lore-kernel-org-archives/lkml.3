Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaBLXI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:08:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31146 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaBLXI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:08:56 -0500
Message-ID: <52FBFEE8.3010708@oracle.com>
Date: Wed, 12 Feb 2014 18:08:24 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org >> LKML" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL v2] liblockdep fixes for v3.14
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 65370bdf881e20907e7a53abab9b8c0bc5f60a6b:

   Merge branch 'linus' into core/locking (2014-02-02 09:43:20 +0100)

are available in the git repository at:


   https://github.com/sashalevin/liblockdep.git liblockdep-fixes

for you to fetch changes up to 8a29727f2a02e3c2592ebb71c3b0216d0db8f141:

   tools/liblockdep: Use realpath for srctree and objtree (2014-02-12 16:38:02 -0500)

----------------------------------------------------------------
Ira W. Snyder (3):
       tools/liblockdep: Fix initialization code path
       tools/liblockdep: Fix include of asm/hash.h
       tools/liblockdep: Add include directory to allow tests to compile

Sasha Levin (2):
       tools/liblockdep: Mark runtests.sh as executable
       tools/liblockdep: Add a stub for new rcu_is_watching

Wang Nan (1):
       tools/liblockdep: Use realpath for srctree and objtree

  tools/lib/lockdep/Makefile             | 6 +++---
  tools/lib/lockdep/preload.c            | 2 +-
  tools/lib/lockdep/run_tests.sh         | 0
  tools/lib/lockdep/uinclude/asm/hash.h  | 6 ++++++
  tools/lib/lockdep/uinclude/linux/rcu.h | 5 +++++
  5 files changed, 15 insertions(+), 4 deletions(-)
  mode change 100644 => 100755 tools/lib/lockdep/run_tests.sh
  create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h
