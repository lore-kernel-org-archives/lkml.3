Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbaGSAwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:52:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:26954 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbaGSAw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:52:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,689,1400050800"; 
   d="scan'208";a="572113996"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org
Subject: Updated PEBS patchkit for IVB-Haswell
Date: Fri, 18 Jul 2014 17:52:09 -0700
Message-Id: <1405731132-6259-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This addresses all earlier comments. Especially perf mem report
for mem-stores now works correctly again.

The Haswell PEBS list unfortunately isn't simple anymore to report
all the mem_op flags correctly, but at least it's more correct
than before. Also fixed a bug.

Hopefully should be ready for merge now.

-Andi

