Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3L3CfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 21:35:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab3L3CfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 21:35:04 -0500
X-IronPort-AV: E=Sophos;i="4.95,571,1384272000"; 
   d="scan'208";a="9348174"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: mingo@kernel.org, dsahern@gmail.com, artagnon@gmail.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/8 V2] Enhancement for perf list.
Date: Mon, 30 Dec 2013 10:26:35 -0500
Message-Id: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:27:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/30 10:27:58,
	Serialize complete at 2013/12/30 10:27:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,
	This patchset is for enhancement of perf list version 2.

Ramkumar and David,
	The patch [6/8] is from your work 52A8D2DA.7050409@gmail.com, and
I make --raw-dump works as a option for other argument here. Do you mind
I add signed-off-by Ramkumar and signed-off-by David in this patch?

changelog:
	-v1
	 * remove the patch for event_glob
	 * add a patch [3/8] to add a missing free in print_pmu_events() fucntion.

Dongsheng Yang (8):
  perf tools: Make the all print_xxx_event functions to return unsigned
    int.
  perf tools: Make the print_pmu_events funtion to return unsigned int.
  perf tools: free aliases[j] in pmu.c if name_only is true.
  perf tools: Improve the message of perf list for unexpected input.
  perf tools: Add support of name_only for print_events_type() function.
  perf tools: Make --raw-dump work as a proper option for perf list.
  perf tools: Fix bug when --raw-dump is not the first arguement for
    perf list.
  perf tools: Enhancement for perf list with --raw-dump.

 tools/perf/builtin-list.c      | 32 +++++++++------
 tools/perf/util/parse-events.c | 88 ++++++++++++++++++++++++------------------
 tools/perf/util/parse-events.h |  8 ++--
 tools/perf/util/pmu.c          | 15 ++++---
 tools/perf/util/pmu.h          |  2 +-
 5 files changed, 85 insertions(+), 60 deletions(-)

-- 
1.8.2.1

