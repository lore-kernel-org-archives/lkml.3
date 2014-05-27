Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaE0NN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:13:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:37654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaE0NN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:13:27 -0400
Date: Tue, 27 May 2014 15:13:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Libo Chen <libo.chen@huawei.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, tglx@linutronix.de,
        mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: balance storm
Message-ID: <20140527131325.GF5444@laptop.programming.kicks-ass.net>
References: <5382AF2E.1040407@huawei.com>
 <1401090987.5339.79.camel@marge.simpson.net>
 <53832A36.5020205@huawei.com>
 <20140527094802.GN30445@twins.programming.kicks-ass.net>
 <53848B38.5090408@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53848B38.5090408@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 08:55:20PM +0800, Libo Chen wrote:
> On 2014/5/27 17:48, Peter Zijlstra wrote:

> > In any case, I'm not sure what the 'regression' report is against, as
> > there's only a single kernel version mentioned: 3.4, and that's almost a

> upstream has the same problem, I have mentioned before.

Not on anything that landed in my inbox I think, but that's not the
point. For a regression report you need _2_ kernel versions, one with
and one without the 'problem'.

Providing one (or two) that have a problem doesn't qualify.

In any case, I didn't see the original email, but I got the impression
that it was complaining about 'new' behaviour from the bits I did see as
quoted.
