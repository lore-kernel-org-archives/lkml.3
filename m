Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaJUJrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:47:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50635 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaJUJrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:47:22 -0400
Date: Tue, 21 Oct 2014 11:47:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
Message-ID: <20141021094714.GR23531@worktop.programming.kicks-ass.net>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 02:54:59PM +0400, Andrey Ryabinin wrote:
> 
> UBSan uses compile-time instrumentation to catch undefined behavior (UB).
> Compiler inserts code that perform certain kinds of
> checks before operations that could cause UB.
> If check fails (i.e. UB detected) __ubsan_handle_* function called.
> to print error message.
> 
> So the most of the work is done by compiler.
> This patch just implements ubsan handlers printing errors.
> 
> GCC supports this since 4.9, however upcoming GCC 5.0 has
> more checkers implemented.

It might be useful if you've got a link to the relevant GCC
documentation of this new shiny stuf.
