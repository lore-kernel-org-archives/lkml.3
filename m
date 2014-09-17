Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaIQSeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:34:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60285 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbaIQSeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:34:22 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/4] powerpc/perf: Miscellaneous fixes
Date: Wed, 17 Sep 2014 11:33:03 -0700
Message-Id: <1410978787-7375-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091718-7182-0000-0000-0000007A25D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaenous fixes for perf and 24x7 counters in powerpc.

Patches 1,3,4 were submitted earlier as a part of the parametrized
events for 24x7 counters. But they are not directly related to the
parametrized events.

Patch 2 simplifies and fixes a bug in catalog_read() which causes the
catalog file to not read first page.

Cody P Schafer (3):
  powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack
    allocations
  perf Documentation: sysfs events/ interfaces
  perf Documentation: remove duplicated docs for powerpc cpu specific
    events

Sukadev Bhattiprolu (1):
  Simplify catalog_read()

 .../testing/sysfs-bus-event_source-devices-events  |  611 ++------------------
 arch/powerpc/perf/hv-24x7.c                        |  144 ++---
 2 files changed, 96 insertions(+), 659 deletions(-)

-- 
1.7.9.5

