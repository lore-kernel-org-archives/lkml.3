Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3HLObg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:31:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56903 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3HLObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:31:34 -0400
Date: Mon, 12 Aug 2013 16:31:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
Message-ID: <20130812143116.GJ27162@twins.programming.kicks-ass.net>
References: <20130807164934.149920591@goodmis.org>
 <20130807165114.147890467@goodmis.org>
 <20130807172044.GC18272@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807172044.GC18272@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 07:20:44PM +0200, Borislav Petkov wrote:
> Besides, BUG can be disabled in CONFIG_EXPERT.

There was some email on this subject a while ago; disabling BUG() is
very risky and can cause all kinds of horrid. IIRC the consensus back
then was to remove this 'feature' and have BUG always at least lock up
the machine hard.
