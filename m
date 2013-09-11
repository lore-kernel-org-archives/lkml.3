Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3IKXCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:02:18 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49806 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3IKXCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130911185944.GA1798@laptop.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
	<20130910135152.GD7537@gmail.com>
	<20130910135636.GA8268@gmail.com>
	<CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
	<20130910164519.GL31370@twins.programming.kicks-ass.net>
	<CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
	<20130910212509.GA18147@laptop.programming.kicks-ass.net>
	<CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
	<20130911131323.GQ31370@twins.programming.kicks-ass.net>
	<CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
	<20130911185944.GA1798@laptop.programming.kicks-ass.net>
Date: Wed, 11 Sep 2013 16:02:14 -0700
X-Google-Sender-Auth: UBNjW78nWIRMa3DvHIReijU4yKc
Message-ID: <CA+55aFxDbqeFumkVApf-L2pi+FQn06GQqQf4rWkzOC4LF=fn=A@mail.gmail.com>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> OK, stripped it down further, I couldn't quite see how to collapse the
> unary and binary operator variants though :/

Ok, this looks pretty good. I assume it works too? ;)

                 Linus
