Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaAORbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:31:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaAORbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:31:42 -0500
Date: Wed, 15 Jan 2014 18:31:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: [PATCH 0/1] timers: internal_add_timer() should update
	->next_timer if ->active_timers == 0
Message-ID: <20140115173117.GA14473@redhat.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com> <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com> <1389763248-31297-4-git-send-email-paulmck@linux.vnet.ibm.com> <20140115172409.GD11499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115172409.GD11499@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Oleg Nesterov wrote:
>
> This is funny, but I already have the same change for ->next_timer,
> if we add this optimization perhaps that trivial patch makes sense
> too.

Please see 1/1, it should not conflict with your changes.

Oleg.

