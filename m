Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3EJOUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:50 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59189
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831Ab3EJOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:41 -0400
Date: Fri, 10 May 2013 16:19:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130510141906.GE304@dyad.programming.kicks-ass.net>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-3-git-send-email-sasha.levin@oracle.com>
 <20130510091816.GC3039@dyad.programming.kicks-ass.net>
 <20130510101131.GA31152@dyad.programming.kicks-ass.net>
 <518CF4D5.4070000@oracle.com>
 <20130510140328.GC304@dyad.programming.kicks-ass.net>
 <518CFFF5.2060807@oracle.com>
 <20130510141227.GD304@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510141227.GD304@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 04:12:27PM +0200, Peter Zijlstra wrote:
> On Fri, May 10, 2013 at 10:11:01AM -0400, Sasha Levin wrote:
> > Ah!
> > 
> > # patch --version
> > GNU patch 2.7.1
> 
> I suppose I'd better go find me a fresher patch then! :-)

*groan* all Debian based distros (with exception of Debian experimental) patch
is still 2.6.1 -- including the very latestest Ubernuts.

Means I have to go build from source on all my machines.. not happy.
