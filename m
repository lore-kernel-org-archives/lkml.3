Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab3CLGuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:50:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55607 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3CLGt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:49:58 -0400
Message-ID: <513ED010.5060906@huawei.com>
Date: Tue, 12 Mar 2013 14:49:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 0/8] cgroup: a bunch of cleanups
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

If you're busy with other stuff, just take your time to go through those
patches.

0001-cgroup-remove-cgroup_is_descentant.patch
0002-cgroup-remove-unused-variables-in-cgroup_destroy_loc.patch
0003-cgroup-hold-cgroup_mutex-before-calling-css_offline.patch
0004-cgroup-don-t-bother-to-resize-pid-array.patch
0005-cgroup-remove-useless-code-in-cgroup_write_event_con.patch
0006-cgroup-remove-unneeded-includes-from-cgroup.h.patch
0007-cgroup-fix-an-almost-harmless-off-by-one-bug.patch
0008-cgroup-consolidate-cgroup_attach_task-and-cgroup_att.patch

---
 Documentation/cgroups/cgroups.txt |   1 +
 include/linux/cgroup.h            |  10 +--
 kernel/cgroup.c                   | 239 +++++++++++-----------------------------------------
 kernel/cpuset.c                   |   2 +-
 4 files changed, 52 insertions(+), 200 deletions(-)
