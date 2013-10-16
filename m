Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab3JPCHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:07:23 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49230 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143Ab3JPCHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:17 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 07/10][v6] powerpc/perf: Add Power8 event PM_MRK_GRP_CMPL to sysfs.
Date: Tue, 15 Oct 2013 19:06:39 -0700
Message-Id: <1381889202-16826-8-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-7164-0000-0000-000002794C55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf event PM_MRK_GRP_CMPL is useful in analyzing memory hierarchy
of applications.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Changelog[v6]:
	- [Michael Ellerman]: Drop redundant PME_ prefix from event name.

 arch/powerpc/perf/power8-events-list.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/perf/power8-events-list.h b/arch/powerpc/perf/power8-events-list.h
index 1368547..b39e117 100644
--- a/arch/powerpc/perf/power8-events-list.h
+++ b/arch/powerpc/perf/power8-events-list.h
@@ -18,3 +18,4 @@ EVENT(PM_CMPLU_STALL,			0x4000a)
 EVENT(PM_INST_CMPL,			0x00002)
 EVENT(PM_BRU_FIN,			0x10068)
 EVENT(PM_BR_MPRED_CMPL,			0x400f6)
+EVENT(PM_MRK_GRP_CMPL,			0x40130)
-- 
1.7.9.5

