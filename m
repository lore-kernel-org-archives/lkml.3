Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaHVUOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:14:52 -0400
Received: from mail3.unitn.it ([193.205.206.24]:57674 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaHVUOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:14:50 -0400
Date: Fri, 22 Aug 2014 22:14:36 +0200
From: Luca Abeni <luca.abeni@unitn.it>
To: Ingo Molnar <mingo@kernel.org>
Cc: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org,
        rdunlap@infradead.org, mingo@redhat.com, henrik@austad.us,
        raistlin@linux.it, juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] Documentation/scheduler/sched-deadline.txt:
 improve and clarify AC bits
Message-ID: <20140822221436.56383b80@luca-1225C>
In-Reply-To: <20140822083110.GB8771@gmail.com>
References: <1408611700-9420-1-git-send-email-juri.lelli@arm.com>
	<1408611700-9420-4-git-send-email-juri.lelli@arm.com>
	<20140821133836.GA29495@gmail.com>
	<20140821164758.334a1cf7@luca-1225C>
	<20140822083110.GB8771@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 22 Aug 2014 10:31:11 +0200
Ingo Molnar <mingo@kernel.org> wrote:
[...]
> > > > + execution time is guaranteed for non real-time tasks, which
> > > > risk to be
> > > > + starved by real-time tasks.
> > > 
> > > The last part doesn't really parse as correct English for me - 
> > > maybe also split this overly long sentence into two or three 
> > > sentences, to make it easier to understand?
> > Sorry about this; after re-reading the sentence, I agree it looks
> > confusing. What about:
> 
> Looks good to me, with a few details:
[...]
Thanks for the suggestions, and sorry about my bad English; I will send
a new patch to Juri in few days.


			Thanks,
				Luca
