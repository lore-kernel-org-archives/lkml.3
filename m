Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaEEIFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:05:44 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46977 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752045AbaEEIFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:05:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,985,1389715200"; 
   d="scan'208";a="30073725"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <jolsa@redhat.com>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/3] perf tools: Patchset for perf sched.
Date: Mon, 5 May 2014 16:05:52 +0900
Message-ID: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,
	This patchset includes three patches for perf sched.
Please help to review. :)

Dongsheng (3):
  perf tools: add missing event for perf sched record.
  perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel
    space.
  perf tools: Clarify the output of perf sched map.

 tools/perf/builtin-sched.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

-- 
1.8.2.1

