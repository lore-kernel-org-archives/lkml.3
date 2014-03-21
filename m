Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773AbaCUNfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:35:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682AbaCUNf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:35:26 -0400
Message-ID: <1395408925.9455.3.camel@linux-fkkt.site>
Subject: Re: Bug 71331 - mlock yields processor to lower priority process
From: Oliver Neukum <oneukum@suse.de>
To: jimmie.davis@l-3com.com
Cc: umgwanakikbuti@gmail.com, artem_fetishev@epam.com, peterz@infradead.org,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 14:35:25 +0100
In-Reply-To: <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 12:18 +0000, jimmie.davis@l-3com.com wrote:
>  
> >How is that different from any other time a task has to yield the CPU
> >for a bit?  While your high priority task is blocked for whatever
> >reason, a lower priority task gets to use the CPU.
> 
>  
> As the submitter of the bug, let me give you my perspective.  SCHED_FIFO means run my task until it blocks or a higher priority task pre-empts it.  Period.
> 
> mlock() doesn't block.  check the man page.

It guarantees that all pages be in RAM. That means it has to read them
in if they aren't. How could it do that without blocking?

	Regards
		Oliver


