Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3HLP5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:57:34 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:56156 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3HLP5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:57:32 -0400
Date: Mon, 12 Aug 2013 17:57:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
Message-ID: <20130812155720.GA14922@gmail.com>
References: <20130807164934.149920591@goodmis.org>
 <20130807165114.147890467@goodmis.org>
 <20130807172044.GC18272@pd.tnic>
 <20130812143116.GJ27162@twins.programming.kicks-ass.net>
 <5208F1E8.4050902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5208F1E8.4050902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/12/2013 07:31 AM, Peter Zijlstra wrote:
> > On Wed, Aug 07, 2013 at 07:20:44PM +0200, Borislav Petkov wrote:
> >> Besides, BUG can be disabled in CONFIG_EXPERT.
> > 
> > There was some email on this subject a while ago; disabling BUG() is 
> > very risky and can cause all kinds of horrid. IIRC the consensus back 
> > then was to remove this 'feature' and have BUG always at least lock up 
> > the machine hard.
> 
> Yes, always trap but leave the metadata as optional.

I think those patches are going forward, so we can just regard BUG() as 
always existing from a program flow POV.

Thanks,

	Ingo
