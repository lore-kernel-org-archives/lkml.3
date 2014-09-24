Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaIXTZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:25:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36071 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbaIXTZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:25:08 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 0/4] powerpc/perf: Miscellaneous fixes
Date: Wed, 24 Sep 2014 12:24:37 -0700
Message-Id: <1411586681-21262-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092419-0320-0000-0000-0000009460D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaenous fixes for perf and 24x7 counters in powerpc.

Patches 1,3,4 were submitted earlier as a part of the parametrized
events for 24x7 counters. But they are not directly related to the
parametrized events.

Patch 2 simplifies and fixes a bug in catalog_read() which causes the
catalog file to not read first page.

Changelog[v2]
	Rebase to perf/core tree.

Cody P Schafer (3):
  powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack
    allocations
  perf Documentation: sysfs events/ interfaces
  perf Documentation: remove duplicated docs for powerpc cpu specific
    events

Sukadev Bhattiprolu (1):
  Simplify catalog_read()

 .../testing/sysfs-bus-event_source-devices-events  | 611 ++-------------------
 arch/powerpc/perf/hv-24x7.c                        | 144 ++---
 2 files changed, 96 insertions(+), 659 deletions(-)

-- 
1.8.3.1

