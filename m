Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaHHAP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:15:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:17562 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaHHAPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:15:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,821,1400050800"; 
   d="scan'208";a="581712064"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org
Subject: Update new perf PEBS tables patchkit
Date: Thu,  7 Aug 2014 17:15:37 -0700
Message-Id: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit revamps the PEBS tables on most Intel CPUs,
both simplifying and fixing a couple of problems on Haswell:
- All PEBS events are supported
- The address and data source is now always correctly reported.
It also fixes one regression added earlier.

I added the fix from Stephane to correctly initialize the
data source default for other events. No open issues in
this version, should be good to merge.

-Andi

