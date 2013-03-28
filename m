Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab3C1ELu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:11:50 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:33965 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3C1ELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:11:44 -0400
Message-ID: <5153C2D6.7050103@huawei.com>
Date: Thu, 28 Mar 2013 12:11:02 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] sched: Split cpuacct
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- This patchset splits cpuacct out of core scheduler code.
- Plus two small optimizations.

0001-sched-Split-cpuacct-code-out-of-core.c.patch
0002-sched-Split-cpuacct-out-of-sched.h.patch
0003-cpuacct-Add-cpuacct_init.patch
0004-cpuacct-Add-cpuacct_acount_field.patch
0005-cpuacct-Remove-redundant-NULL-checks-in-cpuacct_char.patch
0006-cpuacct-Remove-redundant-NULL-checks-in-cpuacct_acou.patch
0007-cpuacct-Clean-up-cpuacct.h.patch

---
 kernel/sched/Makefile  |   1 +
 kernel/sched/core.c    | 228 +----------------------------------------------
 kernel/sched/cpuacct.c | 303 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/cpuacct.h |  22 +++++
 kernel/sched/cputime.c |  18 +---
 kernel/sched/sched.h   |  49 +----------
 6 files changed, 330 insertions(+), 291 deletions(-)
