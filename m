Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab3G0D5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:57:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13836 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab3G0D5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:57:12 -0400
Message-ID: <51F34501.1090608@huawei.com>
Date: Sat, 27 Jul 2013 11:56:49 +0800
From: Zhao Hongjiang <zhaohongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: <tj@kernel.org>, <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] cpuset: get rid of the useless forward declaration of
 cpuset
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get rid of the useless forward declaration of the struct cpuset cause the 
below define it.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 kernel/cpuset.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e565778..2ddd9b9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -70,7 +70,6 @@ int number_of_cpusets __read_mostly;
 
 /* Forward declare cgroup structures */
 struct cgroup_subsys cpuset_subsys;
-struct cpuset;
 
 /* See "Frequency meter" comments, below. */
 
-- 
1.8.2.2

