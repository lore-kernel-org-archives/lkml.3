Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab3CRV0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:26:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab3CRV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:26:25 -0400
Date: Mon, 18 Mar 2013 14:26:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] selftests: Add basic posix timers selftests
Message-Id: <20130318142623.a6a9dd7be1ca9dcd1cd0caec@linux-foundation.org>
In-Reply-To: <1363366442-11494-5-git-send-email-fweisbec@gmail.com>
References: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
	<1363366442-11494-5-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 17:54:02 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Add some initial basic tests on a few posix timers
> interface such as setitimer() and timer_settime().
> 
> These simply check that expiration happens in a reasonable
> timeframe after expected elapsed clock time (user time,
> user + system time, real time, ...).
> 
> This is helpful for finding basic breakages while hacking
> on this subsystem.
> 
> ...
>
>  tools/testing/selftests/timers/Makefile       |    8 +

I wonder if this should be tools/testing/posix-timers/, to leave room
in the namespace for other varieties of timer.

