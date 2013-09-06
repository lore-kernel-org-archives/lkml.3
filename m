Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3IFTdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:26624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab3IFTda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,856,1371106800"; 
   d="scan'208";a="392152997"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 0/2] perf kvm: fix sample_type manipulation
Date: Fri,  6 Sep 2013 22:40:10 +0300
Message-Id: <1378496412-2424-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is the sample identifier fix (version 2).


Changes in V2:
	perf tools: fix id pos in perf_evlist__open()
		New patch
	perf kvm: fix sample_type manipulation
		Remove setting of id_pos


Adrian Hunter (2):
      perf tools: fix id pos in perf_evlist__open()
      perf kvm: fix sample_type manipulation

 tools/perf/builtin-kvm.c | 18 +++++++++---------
 tools/perf/util/evlist.c | 12 ++++++++++++
 2 files changed, 21 insertions(+), 9 deletions(-)


Regards
Adrian

