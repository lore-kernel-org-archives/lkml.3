Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3EHPmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:42:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56898 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab3EHPmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:42:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,635,1363132800"; 
   d="scan'208";a="24043596"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <mingo@redhat.com>, <peterz@infradead.org>
Subject: [PATCH v3 2/4] kernel: missing include in cputime.c
Date: Wed, 8 May 2013 16:41:52 +0100
Message-ID: <1368027714-14506-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: mingo@redhat.com
CC: peterz@infradead.org
---
 kernel/sched/cputime.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ed12cbb..488a5bf 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -5,6 +5,7 @@
 #include <linux/static_key.h>
 #include <linux/context_tracking.h>
 #include "sched.h"
+#include <asm/paravirt.h>
 
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-- 
1.7.2.5

