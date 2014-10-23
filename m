Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaJWSXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:23:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaJWSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:23:14 -0400
Date: Thu, 23 Oct 2014 11:23:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Wise <pabs3@bonedaddy.net>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
Message-Id: <20141023112314.8d62733c202a527b4107eb11@linux-foundation.org>
In-Reply-To: <CAGXu5jL-6sGy2QSH39Qmu0-8MEg6aX5GCPvPKeWaheXcai0TDA@mail.gmail.com>
References: <20141021202137.GA20114@www.outflux.net>
	<20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
	<CAGXu5j+sW89tZDA5GQnkL4E9wHTScftyxUhyAjbWnEfxGocBjg@mail.gmail.com>
	<20141022190051.7c0d5df1.akpm@linux-foundation.org>
	<CAGXu5jL-6sGy2QSH39Qmu0-8MEg6aX5GCPvPKeWaheXcai0TDA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 09:39:09 -0700 Kees Cook <keescook@chromium.org> wrote:

> > I wonder if the chances of damage would be lower if we were to continue
> > to accept the \r, but turn it into something else ("\r"?) when it is
> > read.
> 
> I think that would complicate things more than help them.

Why.

> If there's a
> legit use of \r, I'll let Paul Wise debate how to proceed. :)

I don't know who Paul is.  Please take this seriously; we don't want to
have to revert this after breaking a bunch of people's setups.

