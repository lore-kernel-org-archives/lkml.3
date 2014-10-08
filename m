Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaJHPLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:11:05 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:65474 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbaJHPLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:11:01 -0400
Date: Wed, 8 Oct 2014 11:10:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup changes for v3.18-rc1
Message-ID: <20141008151058.GC8184@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing too interesting.  Just a handful of cleanup patches.  The pull
of for-3.17-fixes was to put follow-up cleanups on top of a fix patch.

Thanks.

The following changes since commit aa32362f011c6e863132b16c1761487166a4bad2:

  cgroup: check cgroup liveliness before unbreaking kernfs (2014-09-05 01:36:19 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.18

for you to fetch changes up to e756c7b698604f11a979f2781d06eb7b80aba363:

  Revert "cgroup: remove redundant variable in cgroup_mount()" (2014-09-26 00:16:23 -0400)

----------------------------------------------------------------
Dongsheng Yang (1):
      cgroup: fix a typo in comment.

Li Zefan (3):
      cgroup: remove some useless forward declarations
      cgroup: remove redundant code in cgroup_rmdir()
      cgroup: remove bogus comments

Tejun Heo (1):
      Merge branch 'for-3.17-fixes' of ra.kernel.org:/.../tj/cgroup into for-3.18

Zefan Li (9):
      cgroup: use a per-cgroup work for release agent
      cgroup: simplify proc_cgroup_show()
      cpuset: simplify proc_cpuset_show()
      cgroup: remove redundant check in cgroup_ino()
      perf/cgroup: Remove perf_put_cgroup()
      cgroup: remove CGRP_RELEASABLE flag
      cgroup: fix missing unlock in cgroup_release_agent()
      cgroup: remove redundant variable in cgroup_mount()
      Revert "cgroup: remove redundant variable in cgroup_mount()"

 fs/proc/base.c         |  39 ++---------
 include/linux/cgroup.h |  26 ++-----
 include/linux/cpuset.h |   3 +-
 kernel/cgroup.c        | 184 ++++++++++++++-----------------------------------
 kernel/cpuset.c        |  15 +---
 kernel/events/core.c   |   7 +-
 mm/memory-failure.c    |   2 +-
 7 files changed, 71 insertions(+), 205 deletions(-)

-- 
tejun
