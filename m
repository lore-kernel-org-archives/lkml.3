Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbaEFJf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:35:58 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53224 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526AbaEFJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:35:52 -0400
Date: Tue, 6 May 2014 11:35:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC] Deprecate BUG/BUG_ON in favour of
 BUG_AND_HALT/BUG_AND_HALT_ON
Message-ID: <20140506093548.GA27476@gmail.com>
References: <1398870207-52889-1-git-send-email-paul.gortmaker@windriver.com>
 <CAFLxGvzhd6jwGsu9eOBtXu92JcH1PnZsR9EB_h5LihYRNS-hyQ@mail.gmail.com>
 <20140506073500.GA26303@gmail.com>
 <5368987E.7040608@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5368987E.7040608@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard Weinberger <richard@nod.at> wrote:

> >> I like the idea but not the name.
> >> What about DIE() and DIE_ON()?
> > 
> > CRASH_ON() might be a suggestive name as well, as from the user's 
> > point of view we are crashing her system.
> 
> I fear such users will think "Why should I crash the kernel?". ;-)

That's exactly the impression that the naming should create in kernel 
developers why try to add CRASH_ON() in the future: only do it as an 
absolute last resort.

WARN_ON() and other non-destructive ways to deal with error conditions 
are almost always preferred.

Thanks,

	Ingo
