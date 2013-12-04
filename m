Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3LDJ6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:58:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755140Ab3LDJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:58:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9189159"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: dsahern@gmail.com, jolsa@redhat.com, acme@ghostprotocols.net,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/5] perf tools: some update for perf tool.
Date: Wed, 4 Dec 2013 17:56:38 -0500
Message-Id: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:20,
	Serialize complete at 2013/12/04 17:58:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	When I read the code and document of perf tool as a newbie, 
I feel confused in some places. Then I made some patches here to make
them more clear.
	Please help to review them.

Note: The last 3 commits are all about perf-kvm.txt. I splite them
to make the logic more clear. If you think it is not necessary, I am
ok to squash them into one commit.

Thanx

Yang


Dongsheng Yang (5):
  perf tools: Remove condition in machine__get_kernel_start_addr.
  perf tools: Move the checking of which map function to call into
    function.
  perf tools: Update the Document for perf kvm record for new behavior.
  perf tools: Add more detail about buildid-list in Document of
    perf-kvm.
  perf tool: Fix a type of '=' in Document of perf-kvm.

 tools/perf/Documentation/perf-kvm.txt | 27 ++++++++++++++++++---------
 tools/perf/util/evlist.c              |  8 +-------
 tools/perf/util/machine.c             | 14 +++++---------
 tools/perf/util/target.h              | 13 +++++++++++++
 4 files changed, 37 insertions(+), 25 deletions(-)

-- 
1.8.2.1

