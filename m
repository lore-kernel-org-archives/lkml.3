Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3KKPcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:32:20 -0500
Received: from imap.thunk.org ([74.207.234.97]:56707 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab3KKPcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:32:16 -0500
Date: Mon, 11 Nov 2013 10:32:06 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ingo Molnar <mingo@kernel.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
Message-ID: <20131111153206.GA22113@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ingo Molnar <mingo@kernel.org>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1383871600-3831-1-git-send-email-felipe.contreras@gmail.com>
 <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
 <20131111113218.GF15810@gmail.com>
 <CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
 <20131111124953.GA6765@gmail.com>
 <CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
 <20131111132812.GB7258@gmail.com>
 <CAMP44s2NYKfrYngTEN5+mPPHOJZLNmSVd3n8k5QNv_=Lpvncsw@mail.gmail.com>
 <20131111135216.GB8781@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111135216.GB8781@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:52:16PM +0100, Ingo Molnar wrote:
> > That's exactly what I did. Addressing feedback constructively doesn't 
> > mean do exactly what you say without arguing.
> 
> Your reply to my routine feedback was obtuse, argumentative and needlessly 
> confrontative - that's not 'constructive'.

Felipe, remember when on the Git list Junio said he would stop trying
to respond to any patches that had problems because you couldn't
respond constructively to feedback, and you claimed that you had no
problems working with other folks, including on the Linux Kernel
mailing list?

You might want to take this feedback and consider whether the problem
may be with *you*, and your user interface, and not with other folks
like Ingo and Junio.  You clearly want to contribute to both projects,
and we can always use more skilled hackers.  But part of being a good
hacker is being able to play well with others.

Best regards,

					- Ted
