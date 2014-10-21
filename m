Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbaJUKmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:42:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaJUKmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:42:36 -0400
Date: Tue, 21 Oct 2014 12:42:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tglx@linutronix.de,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-mm@kvack.org, "hillf.zj" <hillf.zj@alibaba-inc.com>
Subject: Re: [RFC][PATCH 5/6] mm: Provide speculative fault infrastructure
Message-ID: <20141021104225.GB12706@worktop.programming.kicks-ass.net>
References: <CAJd=RBAF3BS9GvPW+fNB9DNzyHrBZk4qNfU6QKUhNNKTMYkmNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAF3BS9GvPW+fNB9DNzyHrBZk4qNfU6QKUhNNKTMYkmNQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:07:56PM +0800, Hillf Danton wrote:

> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> btw, and more important, still correct for me to
> address you Redhater, Sir?

Clue in the above line ;-)
