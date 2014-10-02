Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaJBSrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:47:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaJBSrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:47:47 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] NUMA balancing related fixlets v2
Date: Thu,  2 Oct 2014 19:47:40 +0100
Message-Id: <1412275662-16201-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were a few minor changes so am resending just the two patches that
are mostly likely to affect the bug Dave and Sasha saw and marked them for
stable. I'm less confident it will address Sasha's problem because while
I have not kept up to date, I believe he's also seeing memory corruption
issues in next from an unknown source. Still, it would be nice to see how
they affect trinity testing. I'll send the MPOL_MF_LAZY patch separately
because it's not urgent.

 mm/huge_memory.c | 7 +++++--
 mm/migrate.c     | 5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
1.8.4.5

