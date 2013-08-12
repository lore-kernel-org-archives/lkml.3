Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3HLOdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:33:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab3HLOdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:33:39 -0400
Message-ID: <5208F1E8.4050902@zytor.com>
Date: Mon, 12 Aug 2013 07:32:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
References: <20130807164934.149920591@goodmis.org> <20130807165114.147890467@goodmis.org> <20130807172044.GC18272@pd.tnic> <20130812143116.GJ27162@twins.programming.kicks-ass.net>
In-Reply-To: <20130812143116.GJ27162@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 07:31 AM, Peter Zijlstra wrote:
> On Wed, Aug 07, 2013 at 07:20:44PM +0200, Borislav Petkov wrote:
>> Besides, BUG can be disabled in CONFIG_EXPERT.
> 
> There was some email on this subject a while ago; disabling BUG() is
> very risky and can cause all kinds of horrid. IIRC the consensus back
> then was to remove this 'feature' and have BUG always at least lock up
> the machine hard.
> 

Yes, always trap but leave the metadata as optional.

	-hpa

