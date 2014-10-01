Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaJAGDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:03:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44863 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaJAGDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:03:51 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 0/5] powerpc/perf: Miscellaneous fixes
Date: Tue, 30 Sep 2014 23:03:16 -0700
Message-Id: <1412143402-26061-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100106-5806-0000-0000-000000A29777
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaenous fixes for perf and 24x7 counters in powerpc.

Patches 1,3,4 were submitted earlier as a part of the parametrized
events for 24x7 counters. But they are not directly related to the
parametrized events.

Patch 2 simplifies and fixes a bug in catalog_read() which causes the
catalog file to not read first page.

Changelog[v3]
	[Michael Ellerman] Cleanup patches 1 and 2 and fix a bug
	Add patch 5/5 to update contact info for 24x7 and GPCI counters

Changelog[v2]
	Rebase to perf/core tree.

Cody P Schafer (3):
  powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack
    allocations
  perf Documentation: sysfs events/ interfaces
  perf Documentation: remove duplicated docs for powerpc cpu specific
    events

Sukadev Bhattiprolu (2):
  Simplify catalog_read()
  powerpc: Update contact info in Documentation files

 .../testing/sysfs-bus-event_source-devices-events  | 611 ++-------------------
 .../testing/sysfs-bus-event_source-devices-hv_24x7 |   6 +-
 .../testing/sysfs-bus-event_source-devices-hv_gpci |  12 +-
 arch/powerpc/perf/hv-24x7.c                        | 156 ++----
 4 files changed, 109 insertions(+), 676 deletions(-)

-- 
1.8.3.1

