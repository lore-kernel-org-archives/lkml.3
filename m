Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3GaITN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:19:13 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:27771 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759103Ab3GaISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:18:47 -0400
Message-ID: <51F8C7C5.9040608@huawei.com>
Date: Wed, 31 Jul 2013 16:16:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 0/7] some pending cgroup patches
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first one is a small bug fix, and the rest are pure cleanups.

Li Zefan (7):
      cgroup: fix a leak when percpu_ref_init() fails
      cgroup: remove sparse tags from offline_css()
      cgroup: restructure the failure path in cgroup_write_event_control()
      cgroup: rename cgroup_pidlist->mutex
      cgroup: remove struct cgroup_seqfile_state
      cgroup: rename current_css_set_cg_links
      cgroup: more naming cleanups
--
 include/linux/cgroup.h |   6 +--
 kernel/cgroup.c        | 138 ++++++++++++++++++++++++++++-----------------------------------
 kernel/cpuset.c        |  16 ++++----
 3 files changed, 72 insertions(+), 88 deletions(-)
