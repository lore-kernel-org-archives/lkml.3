Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3GDEzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:55:12 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50005 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GDEzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:55:10 -0400
Message-ID: <51D50024.10902@linux.vnet.ibm.com>
Date: Thu, 04 Jul 2013 12:55:00 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v3 0/2] sched: smart wake-affine
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070404-8878-0000-0000-000007CFB426
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v2:
	Add patch [PATCH 2/2] sched: reduce the overhead of obtain factor
	for optimization. (Thanks to PeterZ)

This patch-set will implement a smart wake-affine, in order to regain the
lost performance of the workload like pgbench, meanwhile reserve the gained
benefit of the workload like hackbench.

Michael Wang (1):
	[PATCH v3 1/2] sched: smart wake-affine foundation

Peter Zijlstra (1):
	[PATCH v3 2/2] sched: reduce the overhead of obtain factor

---
 b/include/linux/sched.h |    3 +++
 b/kernel/sched/core.c   |    7 ++++++-
 b/kernel/sched/fair.c   |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 b/kernel/sched/sched.h  |    1 +
 kernel/sched/fair.c     |    2 +-
 5 files changed, 58 insertions(+), 2 deletions(-)

