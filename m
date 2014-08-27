Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbaH0VEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:04:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:50492 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965198AbaH0VEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,413,1406617200"; 
   d="scan'208";a="473310996"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de
Subject: perf, x86: Updated Broadwell patchkit 
Date: Wed, 27 Aug 2014 14:03:52 -0700
Message-Id: <1409173437-3041-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only minor changes to the last version. The Broadwell model number
patch now has a more expansive change log and does not 
reorder case statements anymore.

Some minor updates to commit logs.

