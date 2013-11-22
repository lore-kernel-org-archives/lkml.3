Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3KVAkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:40:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3KVAkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:40:00 -0500
Date: Fri, 22 Nov 2013 01:39:04 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Luis Lozano <llozano@google.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Henderson <rth@twiddle.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        Han Shen <shenhan@chromium.org>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
Message-ID: <20131122003904.GT892@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <52803E5D.3050109@mentor.com>
 <52851395.3010306@mentor.com>
 <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
 <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
 <CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>
 <528E2E8E.8080004@ahsoftware.de>
 <CA+55aFyNZun07BLoD2KQFT7cN1xsiQ2gE6hYwRvOGa3tCap4CQ@mail.gmail.com>
 <528E94E2.3080102@ahsoftware.de>
 <CANxoKds1iLpXK0yb1qW_Z4tLSRccrf69nYUV7mLSJBMwSrjwmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANxoKds1iLpXK0yb1qW_Z4tLSRccrf69nYUV7mLSJBMwSrjwmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:45:35PM -0800, Luis Lozano wrote:
> I think we need a reproducer. Without this we may all be going on the
> wrong path. This whole conversation started on an *assumption* that
> some accesses were being reordered.
> 
> evidence of the reorder or reproducer please?

Yeah, if a compiler bug is suspected, can anybody please open
a bugreport in http://gcc.gnu.org/bugzilla/ with the preprocessed source,
compiler version, flags and how it was configured and some hint in which
function to look for what exactly?  We don't necessarily need a runtime
small reproducer, but if it can be shown in the assembly what has been
reordered and why you think it shouldn't, with the above mentioned input
that ought to be sufficient.  Thanks.

	Jakub
