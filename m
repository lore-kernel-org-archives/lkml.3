Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbaITTDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 15:03:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaITTDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 15:03:49 -0400
Date: Sat, 20 Sep 2014 21:03:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH 2/7] sched: Fix picking a task switching on other cpu
 (__ARCH_WANT_UNLOCKED_CTXSW)
Message-ID: <20140920190347.GF3037@worktop.localdomain>
References: <20140920165116.16299.1381.stgit@localhost>
 <20140920165122.16299.31150.stgit@localhost>
 <20140920183326.GT2832@worktop.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920183326.GT2832@worktop.localdomain>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 08:33:26PM +0200, Peter Zijlstra wrote:
> On Sat, Sep 20, 2014 at 08:51:22PM +0400, Kirill Tkhai wrote:
> > From: Kirill Tkhai <ktkhai@parallels.com>
> > 
> > We may pick a task which is in context_switch() on other cpu at the moment.
> > Parallel using of a single stack by two processes is not a good idea.
> 
> Please elaborate on who exactly that might happen. Its best to have
> comprehensive changelogs for issues that fix races.

typing hard, ugh. s/who/how/
