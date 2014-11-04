Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaKDUM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:12:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42394 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaKDUMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:12:24 -0500
Date: Tue, 4 Nov 2014 21:12:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: peterz@infradead.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de,
        len.brown@intel.com, hpa@zytor.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/wait: Remove wait_event_freezekillable()
Message-ID: <20141104201222.GB15071@amd>
References: <tip-5d4d56582467f3c08dfedd0d995ce2092f384ecc@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5d4d56582467f3c08dfedd0d995ce2092f384ecc@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 08:08:32, tip-bot for Peter Zijlstra (Intel) wrote:
> Commit-ID:  5d4d56582467f3c08dfedd0d995ce2092f384ecc
> Gitweb:     http://git.kernel.org/tip/5d4d56582467f3c08dfedd0d995ce2092f384ecc
> Author:     Peter Zijlstra (Intel) <peterz@infradead.org>
> AuthorDate: Wed, 29 Oct 2014 14:48:13 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 4 Nov 2014 07:17:46 +0100
> 
> sched/wait: Remove wait_event_freezekillable()
> 
> There is no user.. make it go away.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: oleg@redhat.com
> Cc: Rafael Wysocki <rjw@rjwysocki.net>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
