Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaDAD0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:26:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:59766 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbaDAD0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:26:33 -0400
Date: Mon, 31 Mar 2014 23:26:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
Message-ID: <20140331232631.0021ba8c@gandalf.local.home>
In-Reply-To: <1396321814.5324.27.camel@marge.simpson.net>
References: <1396164244.28950.15.camel@marge.simpson.net>
	<CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	<1396239636.5361.57.camel@marge.simpson.net>
	<20140331160003.GD19658@home.goodmis.org>
	<1396321814.5324.27.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014 05:10:14 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> Maybe it should just die as more potential trouble than it's worth.  It
> has saved a pile of fastpath cycles, losing those again would be a
> shame.  Accounting doesn't need to be perfect (is the enemy of good),
> but it does need to be a guaranteed good.

I don't think we should get rid of it. But better comments in the
scheduler would be nice.

-- Steve
