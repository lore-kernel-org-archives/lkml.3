Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaBOMHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:07:32 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:46888 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaBOMHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:07:31 -0500
X-Auth-Info: Bc62P6LTAOCPx2UPZsG6ryPK9kOyQLDim0wVl7NEueo=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
References: <20140214201841.826179349@linux.com>
	<20140214201908.082769265@linux.com>
	<1392436208.10050.22.camel@pasglop>
	<20140215094239.GF14089@laptop.programming.kicks-ass.net>
	<1392458479.10050.26.camel@pasglop>
X-Yow: I can't think about that.  It doesn't go with HEDGES in the shape of
 LITTLE LULU -- or ROBOTS making BRICKS...
Date: Sat, 15 Feb 2014 13:07:17 +0100
In-Reply-To: <1392458479.10050.26.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Sat, 15 Feb 2014 21:01:19 +1100")
Message-ID: <87lhxctw96.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Sat, 2014-02-15 at 10:42 +0100, Peter Zijlstra wrote:
>> On Sat, Feb 15, 2014 at 02:50:08PM +1100, Benjamin Herrenschmidt wrote:
>> > For some reason Im still getting these as attachments instead of inline
>> > in the email, which makes reviewing a major PITA. Christoph, I'm not
>> > sure what you are doing wrong here but you should consider fixing it :-)
>> 
>> Yeah, what the others have already said; evolution is a pile of steaming
>> crap. Get yourself a real MUA :-)
>
> I yet have to find one that isn't a steaming pile ... :-) 

Gnus.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
