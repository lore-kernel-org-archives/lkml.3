Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaHYWnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:43:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:65151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbaHYWnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,400,1406617200"; 
   d="scan'208";a="563318682"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com
Subject: Broadwell perf support
Date: Mon, 25 Aug 2014 15:43:26 -0700
Message-Id: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated version of the perf Broadwell patchkit. This also has some fixes
for Haswell.

This addresses all earlier feedback. Too low user specified periods
on INST_RETIRED.ALL are now rejected with an error. The Haswell
models are documented. The event matches use the perf macros.

-Andi

