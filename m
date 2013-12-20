Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3LTHy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:54:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3LTHy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:54:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9296740"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/7 V2] Add support of user space symboles for guest.
Date: Fri, 20 Dec 2013 15:52:55 -0500
Message-Id: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:23,
	Serialize complete at 2013/12/20 15:54:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:
	Please help to review this patchset.

Changelog:
	- v2:
		* splite the first commit.

Dongsheng Yang (7):
  perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in
    thread__find_addr_map().
  perf tools: Find the proc info under machine->root_dir.
  perf tools: Set event->header.misc to PERF_RECORD_MISC_GUEST_USER if
    machine is guest.
  perf tools: Use machine->pid for tgid if mahicne is guest.
  perf tools: Do not synthesize the treads of default guest.
  perf tools: Add support of user space symbols for guest in perf kvm
    top.
  perf tools: Add support of user space symbols for guest in perf kvm
    record.

 tools/perf/builtin-record.c | 10 ++++++++++
 tools/perf/builtin-top.c    | 15 ++++++++++-----
 tools/perf/util/event.c     | 44 ++++++++++++++++++++++++++++++--------------
 3 files changed, 50 insertions(+), 19 deletions(-)

-- 
1.8.2.1

