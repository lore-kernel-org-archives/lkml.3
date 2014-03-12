Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaCLQGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:06:15 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:50760 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaCLQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140312155754.GG27965@twins.programming.kicks-ass.net>
References: <20140310154236.038181843@infradead.org>
	<20140312023153.GW13647@dastard>
	<20140311231159.25a0d8dc@gandalf.local.home>
	<20140312042616.GX13647@dastard>
	<20140312060730.435122f0@gandalf.local.home>
	<20140312155754.GG27965@twins.programming.kicks-ass.net>
Date: Wed, 12 Mar 2014 09:06:11 -0700
X-Google-Sender-Auth: L4VU6c_mfgv_JkxMq8GezRL-G1s
Message-ID: <CA+55aFwXEL8nd+QL1CuMZRi6dnKkj92-UH0hfsPCR6Qaj+rVNQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dave Chinner <david@fromorbit.com>,
        Waiman Long <waiman.long@hp.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 8:57 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> I've not managed to reproduce the hang as reported by Dave, but then I
> doubt building kernels has anywhere near the lock contention he
> generated.

Building kernels has basically no lock contention at all.

                Linus
