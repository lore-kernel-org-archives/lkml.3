Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaILISw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:18:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:38217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaILISt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:18:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,511,1406617200"; 
   d="scan'208";a="572189637"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Part2 v1 0/2] Refine the way to initialize IRQ for apb timer
Date: Fri, 12 Sep 2014 16:20:37 +0800
Message-Id: <1410510039-12759-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David and Andy,
	Could you please help to test these two patches on Intel MID
platforms? It's based on Thomas patch to refine the way to initialize
IRQ for apb timers. It should apply to the mainstream kernel.

Jiang Liu (2):
  intel_mid: Kill unused function apbt_quick_calibrate()
  intel_mid: Refine the way to initialize IRQ for apb timer

 arch/x86/include/asm/apb_timer.h        |    2 -
 arch/x86/kernel/apb_timer.c             |   79 +++++--------------------------
 arch/x86/platform/intel-mid/intel-mid.c |   18 +++----
 arch/x86/platform/intel-mid/sfi.c       |   20 ++++----
 4 files changed, 30 insertions(+), 89 deletions(-)

-- 
1.7.10.4

