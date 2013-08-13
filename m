Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3HMBRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:17:41 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32791 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab3HMBRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:17:40 -0400
Message-ID: <5209892D.8070502@huawei.com>
Date: Tue, 13 Aug 2013 09:17:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cpuset: remove an unncessary forward declaration
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index bf69717..9d8d637 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -68,9 +68,6 @@
  */
 int number_of_cpusets __read_mostly;
 
-/* Forward declare cgroup structures */
-struct cgroup_subsys cpuset_subsys;
-
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
-- 
1.8.0.2

