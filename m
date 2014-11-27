Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaK0PbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:31:22 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34450 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaK0PbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:31:21 -0500
Message-ID: <1417102277.3512.109.camel@maggy.simpson.net>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Nov 2014 08:31:17 -0700
In-Reply-To: <5476EC32.9030005@gmail.com>
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
	 <20140514154459.GE4570@linux.vnet.ibm.com>
	 <20140514191100.GA24155@windriver.com>
	 <1400122194.5175.18.camel@marge.simpson.net> <5476EC32.9030005@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 17:17 +0800, Wanpeng Li wrote:

> If the tick is still need to be handled if cpu is isolated w/o nohz full 
> enabled?

"No" would lead to some awkward questions.

	-Mike

