Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaG1I1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:27:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaG1I1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:27:31 -0400
Date: Mon, 28 Jul 2014 01:26:47 -0700
From: tip-bot for Sukadev Bhattiprolu <tipbot@zytor.com>
Message-ID: <tip-c94b93cbca59435dfc0f2a838fea55bd632145d3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, michaele@au1.ibm.com, andi@firstfloor.org,
        jolsa@redhat.com, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, michaele@au1.ibm.com,
        jolsa@redhat.com, sukadev@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20140724074718.GB18829@us.ibm.com>
References: <20140724074718.GB18829@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf powerpc: Include util/
 util.h and remove stringify macros
Git-Commit-ID: c94b93cbca59435dfc0f2a838fea55bd632145d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c94b93cbca59435dfc0f2a838fea55bd632145d3
Gitweb:     http://git.kernel.org/tip/c94b93cbca59435dfc0f2a838fea55bd632145d3
Author:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
AuthorDate: Thu, 24 Jul 2014 00:47:18 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jul 2014 11:00:39 -0300

perf powerpc: Include util/util.h and remove stringify macros

The stringify macros are defined in tools/perf/util/util.h and don't
need to be redfined specfiically for powerpc.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Link: http://lkml.kernel.org/r/20140724074718.GB18829@us.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/powerpc/util/header.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 2f7073d..6c1b8a7 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -5,9 +5,7 @@
 #include <string.h>
 
 #include "../../util/header.h"
-
-#define __stringify_1(x)        #x
-#define __stringify(x)          __stringify_1(x)
+#include "../../util/util.h"
 
 #define mfspr(rn)       ({unsigned long rval; \
 			 asm volatile("mfspr %0," __stringify(rn) \
