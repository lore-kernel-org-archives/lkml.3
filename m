Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbaAIJWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:22:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10753 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaAIJWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:22:11 -0500
X-IronPort-AV: E=Sophos;i="4.95,630,1384272000"; 
   d="scan'208";a="9395604"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, acme@redhat.com
Cc: dsahern@gmail.com, artagnon@gmail.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/7 V3] Enhancement for perf list.
Date: Thu, 9 Jan 2014 17:19:50 -0500
Message-Id: <cover.1389305623.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 17:21:03,
	Serialize complete at 2014/01/09 17:21:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,
    This patchset is for enhancement of perf list v3.

changelog:
        -v1
             * remove the patch for event_glob
                 * add a patch [3/8] to add a missing free in print_pmu_events() fucntion.
        -v2
	     * squash [2/8] into [1/8].
	     * update the error message when perf list with invalid argument.
	     * update the commit message of [2/7]

Dongsheng Yang (7):
  perf tools: Make the all print_xxx_event functions to return unsigned
    int.
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

