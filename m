Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3I3QJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:09:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45861 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3I3QJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:09:19 -0400
Date: Mon, 30 Sep 2013 18:09:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] sched, wait: Change timeout logic
Message-ID: <20130930160905.GE3081@twins.programming.kicks-ass.net>
References: <20130930152242.207382649@infradead.org>
 <20130930152624.809243897@infradead.org>
 <CA+55aFxDR6uSbCyg9Sp7bxoyzdUoN=TAfBLbkdPPgRqkv-TB1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxDR6uSbCyg9Sp7bxoyzdUoN=TAfBLbkdPPgRqkv-TB1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:48:09AM -0700, Linus Torvalds wrote:
> As a result, I currently strongly suggest kernel-developers do
> 
>     git config --global core.abbrev 12
> 

Done!
