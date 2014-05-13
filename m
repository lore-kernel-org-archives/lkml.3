Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaEMP17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:27:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:42147 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaEMP1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:27:21 -0400
Date: Tue, 13 May 2014 17:27:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [SCHED_DEADLINE man pages 0/2] Summary
Message-ID: <20140513152719.GF2485@laptop.programming.kicks-ass.net>
References: <53723235.40101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53723235.40101@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 04:54:45PM +0200, Michael Kerrisk (man-pages) wrote:
> Peter, at al.
> 
> The follow ups to this mail contain the changes to man-pages for
> the new sched_setattr() and sched_getattr() system calls, as well
> as the changes to the sched(7) man page to document the 
> SCHED_DEADLINE policy, all new changes in kernel 3.14.
> 
> I used the text you submitted, but _heavily_ edited it, and added
> a _lot_ of further details. Therefore, could you (and Juri, and 
> Dario?) please carefully review the text.
> 
> The follow-up mails are:
> 
> [1/2] The sched_setattr.2 page that documents sched_setattr(2) 
>       and sched_getattr(2).
> 
> [2/2] The revisions to the sched(7) page.
> 
> In each case, I've posted the formatted output for easy reading,
> and attached the page source to the message.

I've read (as careful as one still can after seeing too much of this)
both texts and they appear to be good.

Thanks for polishing, they are indeed clearer than what I provided.
