Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbaCRRvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141AbaCRRvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:51:12 -0400
Date: Tue, 18 Mar 2014 18:50:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com,
        Linus Torvalds <torvalds@linux-foundation.org>, tj@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [v3.13][v3.14][Regression] kthread: make kthread_create()
	killable
Message-ID: <20140318175024.GB11866@redhat.com>
References: <53236AA2.7030105@canonical.com> <20140317130241.7e4fde86d75d417628da6f1a@linux-foundation.org> <20140317231814.3249e6d2@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317231814.3249e6d2@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17, One Thousand Gnomes wrote:
>
> > and b) permits userspace to produce surprising results in the kernel,
> > which I suspect is what we're seeing here.
>
> There is enough information for kernel side code to decide whether a
> signal came from kernel or userspace.

Not really. SIGKILL can come without siginfo. Other signals too, but
SIGKILL especially.

> Then again - it's not clear that it
> should ever have to.

Yes, agreed.

Oleg.

