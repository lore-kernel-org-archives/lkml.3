Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab3E1Ry5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:54:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7888 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964905Ab3E1Ry4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:54:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,759,1363132800"; 
   d="scan'208";a="26477156"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <mingo@redhat.com>, <peterz@infradead.org>
Subject: [PATCH v4 2/4] kernel: missing include in cputime.c
Date: Tue, 28 May 2013 18:54:30 +0100
Message-ID: <1369763672-12919-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305281835080.4799@kaball.uk.xensource.com>
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
index cc2dc3ee..a5d1a9b 100644
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

