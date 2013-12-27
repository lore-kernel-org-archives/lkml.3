Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab3L0KGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:06:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42406 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3L0KFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:05:52 -0500
X-IronPort-AV: E=Sophos;i="4.95,559,1384272000"; 
   d="scan'208";a="9336937"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/8] Enhancement for perf list.
Date: Fri, 27 Dec 2013 18:03:26 -0500
Message-Id: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:52,
	Serialize complete at 2013/12/27 18:04:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,
	This patchset is an enhancement for perf list command.
	
	The patch [6/8] is from work of Ramkumar and David at
	52A8D2DA.7050409@gmail.com, so I add signed-off by them.

Dongsheng Yang (8):
  perf tools: Fix bug in 'perf list event_glob'.
  perf tools: Make the all print_xxx_event functions to return unsigned
    int.
  perf tools: Make the print_pmu_events funtion to return unsigned int.
  perf tools: Improve the message of perf list for unexpected input.
  perf tools: Add support of name_only for print_events_type() function.
  perf tools: Make --raw-dump work as a proper option for perf list.
  perf tools: Fix bug when --raw-dump is not the first arguement for
    perf list.
  perf tools: Enhancement for perf list with --raw-dump.

 tools/perf/builtin-list.c      | 32 +++++++++------
 tools/perf/util/parse-events.c | 91 ++++++++++++++++++++++++------------------
 tools/perf/util/parse-events.h |  8 ++--
 tools/perf/util/pmu.c          | 20 +++++-----
 tools/perf/util/pmu.h          |  2 +-
 5 files changed, 88 insertions(+), 65 deletions(-)

-- 
1.8.2.1

