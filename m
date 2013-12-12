Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3LLTDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:03:37 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:33209 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3LLTDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:03:36 -0500
MIME-Version: 1.0
In-Reply-To: <20131212190054.GC5408@redhat.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<20131210213431.GA6342@redhat.com>
	<20131210214143.GG27373@redhat.com>
	<CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
	<20131212190054.GC5408@redhat.com>
Date: Thu, 12 Dec 2013 11:03:35 -0800
X-Google-Sender-Auth: RDK21AzBaZyIVcIP3KEC36l4G1c
Message-ID: <CA+55aFzGGx3xoaZTw7m4Q6sJ3hCujw2UERtqrUXMNPsHXFat3A@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 11:00 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
>
> However it wasn't me introducing the bug, my code when patched in
> early 2011 would work fine. The bug was introduced half a year later
> in commit 9ea71503a8ed9184d2d0b8ccc4d269d05f7940ae .

I'd argue that half a year later the bug was *fixed*, but it was only
fixed for the regular pages. Leaving largepages buggy.

            Linus
