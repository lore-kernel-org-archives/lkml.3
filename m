Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbaCEBvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:51:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:44726 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961AbaCEBvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:51:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,589,1389772800"; 
   d="scan'208";a="486185735"
Date: Wed, 5 Mar 2014 09:51:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [sched/idle] c365c292d05: ltp.sched_rr_get_interval02.1.TFAIL
Message-ID: <20140305015110.GJ8157@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

We noticed ltp/syscalls test regression on

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/idle

commit: c365c292d05908c6ea6f32708f331e21033fe71d ("sched: Consider pi boosting in setscheduler()")

Thanks,
Fengguang
