Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaA1PcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:32:13 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39381 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1PcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:32:11 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHSET cgroup/for-3.14-fixes] cgroup: four misc fixes
Date: Tue, 28 Jan 2014 10:32:01 -0500
Message-Id: <1390923125-4369-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following four fixes found during
conversion to kernfs.  0001-0003 are marked with -stable.

 0001-cgroup-fix-error-return-value-in-cgroup_mount.patch
 0002-cgroup-fix-error-return-from-cgroup_create.patch
 0003-cgroup-fix-locking-in-cgroup_cfts_commit.patch
 0004-cgroup-move-the-one-off-opts-sanity-check-in-cgroup_.patch

The patches are also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-3.14-fixes

diffstat follows.

 kernel/cgroup.c |   46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

Thanks.

--
tejun
