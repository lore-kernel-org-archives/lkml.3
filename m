Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaJXJpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:45:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJXJpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:45:01 -0400
Date: Fri, 24 Oct 2014 11:44:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: oleg@redhat.com, cl@linux.com, tkhai@yandex.ru, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, vdavydov@parallels.com
Subject: Re: introduce probe_slab_address?
Message-ID: <20141024094456.GE12706@worktop.programming.kicks-ass.net>
References: <20141022161450.GA27607@redhat.com>
 <20141022163743.GI21513@worktop.programming.kicks-ass.net>
 <20141022181412.GA8159@redhat.com>
 <20141022.145950.1585224138048242923.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022.145950.1585224138048242923.davem@davemloft.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:59:50PM -0400, David Miller wrote:
> It's when you store at vaddr X then read at vaddr Y and expect to see
> what you wrote at X that you have problems.

OK, so there are no known archs that have problems with this? I didn't
expect problems, but was somewhat uncomfortable with it.

> That is very much not what is happening here.

Agreed.
