Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaDYPLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:11:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaDYPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:11:18 -0400
Date: Fri, 25 Apr 2014 17:11:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tkhai@yandex.ru" <tkhai@yandex.ru>
Subject: Re: Real-time scheduling policies and hyper-threading
Message-ID: <20140425151116.GJ11096@twins.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru>
 <20140424185858.GB26782@laptop.programming.kicks-ass.net>
 <17051398423889@webcorp2e.yandex-team.ru>
 <20140425131620.GB11096@twins.programming.kicks-ass.net>
 <34791398438136@webcorp2g.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34791398438136@webcorp2g.yandex-team.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 07:02:16PM +0400, Roman Gushchin wrote:
> Hm. What I really want (and try to implement), is 
> "work as if ht is disabled if there are free physical cores, start using ht siblings otherwise".

At which point I have to ask, what about the rest of the topology?

Also, how is a task to know if its the 16th or 17th and thus should
expect worse latency?

> It's a 32-thread processor with 16 physical cores.

No NUMA? I'm not aware of single node systems with 16 cores.
