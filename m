Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3EVI1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:27:46 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48267 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3EVI1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:27:41 -0400
X-AuditID: 9c93017e-b7c8fae000000f00-08-519c817aab79
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 0/5] perf report: Add support for callchains on GTK browser
Date: Wed, 22 May 2013 17:27:33 +0900
Message-Id: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements callchain support in GTK report browser as
Pekka requested.  I put callchain overhead on its own column because
it looks more natural to me.  Please take a look and give me comments.

You can get it from 'perf/callchain-gtk-v1' branch on my tree at

 git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks!
Namhyung


Namhyung Kim (5):
  perf gtk/hists: Use GtkTreeStore instead of GtkListStore
  perf gtk/hists: Add support for callchains
  perf gtk/hists: Display callchain overhead also
  perf gtk/hists: Add a double-click handler for callchains
  perf gtk/hists: Make column headers resizable

 tools/perf/ui/gtk/hists.c | 123 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 118 insertions(+), 5 deletions(-)

-- 
1.7.11.7

