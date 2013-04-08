Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935059Ab3DHQTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:19:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:13273 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934422Ab3DHQTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:19:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="314809853"
Subject: Re: Load balancing behavior for sched autogroup
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Paul Turner <pjt@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>,
        Changlong Xie <changlongx.xie@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <CAPM31RKDt+Xuo4MkmmE+R-AXSjZHGAhOT83vk4d6GrDVZtWUmA@mail.gmail.com>
References: <1364599219.27102.56.camel@schen9-DESK>
	 <CAPM31RKDt+Xuo4MkmmE+R-AXSjZHGAhOT83vk4d6GrDVZtWUmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Apr 2013 09:19:21 -0700
Message-ID: <1365437961.27102.60.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 16:35 -0700, Paul Turner wrote:
> I'm surprised that patch would have much effect in either direction;
> it changes the amortization of accounting, but not the actual numbers
> -- especially for a persistent load.  We'll take a look.
> 

Hi Paul,

Wonder if you have a chance to take a look at the load imbalance with
sched autogroup?

Thanks.

Tim

