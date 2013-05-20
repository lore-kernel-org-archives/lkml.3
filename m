Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3ETWbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 18:31:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3ETWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 18:31:43 -0400
Date: Mon, 20 May 2013 15:31:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2013-05-09-15-57 uploaded
Message-Id: <20130520153135.a47e21227a4fc3a77996b482@linux-foundation.org>
In-Reply-To: <CAFTL4hwvP7GsrNTc4knQRMV1YHXnZRes=E_NpLAKSOgqTeou5g@mail.gmail.com>
References: <20130509225833.C37A55A41D4@corp2gmr1-2.hot.corp.google.com>
	<CAFTL4hwvP7GsrNTc4knQRMV1YHXnZRes=E_NpLAKSOgqTeou5g@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013 11:42:09 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Andrew,
> 
> 2013/5/10  <akpm@linux-foundation.org>:
> [...]
> > * posix_cpu_timer-consolidate-expiry-time-type.patch
> > * posix_cpu_timers-consolidate-timer-list-cleanups.patch
> > * posix_cpu_timers-consolidate-expired-timers-check.patch
> > * selftests-add-basic-posix-timers-selftests.patch
> > * posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
> > * posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
> 
> Do you have any plans concerning these patches? These seem to have
> missed this merge window.

They're in my queue of "stuff to send to tglx" when I do my next
maintainer patchbombing.

I guess I should have done that significantly before the 3.10 release,
but it's rather discouraging how few of those patches get applied by
anyone.  Maybe the solution to that is to send them more often, not
less.
