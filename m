Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab3LJW2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:28:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3LJW2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:28:52 -0500
Date: Tue, 10 Dec 2013 17:27:51 -0500
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210222750.GE5050@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Darren Hart <dvhart@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
References: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <20131210220946.GA6962@home.goodmis.org>
 <20131210221621.GD5050@redhat.com>
 <20131210222150.GB6962@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210222150.GB6962@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 05:21:50PM -0500, Steven Rostedt wrote:
 
 > The trace-cmd show, shows you what's in the trace file, which was for the
 > "manual" version.
 > 
 > Sorry for the confusion.

 ah, thanks.

That shows..

version = 6
CPU 0 is empty
CPU 2 is empty
CPU 3 is empty
cpus=4
 trinity-child27-10818 [001] 89790.703544: kernel_stack:         <stack trace>
=> futex_requeue (ffffffff810df18a)
=> do_futex (ffffffff810e019e)
=> SyS_futex (ffffffff810e0de1)
=> tracesys (ffffffff81760be4)
 trinity-child27-10818 [001] 89790.703545: function:             get_user_pages_fast
 trinity-child27-10818 [001] 89790.703547: kernel_stack:         <stack trace>
=> futex_requeue (ffffffff810df18a)
=> do_futex (ffffffff810e019e)
=> SyS_futex (ffffffff810e0de1)
=> tracesys (ffffffff81760be4)
 trinity-child27-10818 [001] 89790.703547: function:             get_user_pages_fast
 trinity-child27-10818 [001] 89790.703549: kernel_stack:         <stack trace>
=> futex_requeue (ffffffff810df18a)
=> do_futex (ffffffff810e019e)
=> SyS_futex (ffffffff810e0de1)
=> tracesys (ffffffff81760be4)
 trinity-child27-10818 [001] 89790.703550: function:             get_user_pages_fast
 trinity-child27-10818 [001] 89790.703552: kernel_stack:         <stack trace>
=> futex_requeue (ffffffff810df18a)
=> do_futex (ffffffff810e019e)
=> SyS_futex (ffffffff810e0de1)
=> tracesys (ffffffff81760be4)


over and over and..

	Dave

