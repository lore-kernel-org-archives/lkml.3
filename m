Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3GYMxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:53:31 -0400
Received: from ozlabs.org ([203.10.76.45]:39264 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755526Ab3GYMx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:53:28 -0400
Message-ID: <1374756806.12885.14.camel@concordia>
Subject: Re: [PATCH] perf tools: Add support for pinned modifier
From: Michael Ellerman <michael@ellerman.id.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@redhat.com,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Date: Thu, 25 Jul 2013 22:53:26 +1000
In-Reply-To: <20130725110447.GS27075@twins.programming.kicks-ass.net>
References: <1374632802-15436-1-git-send-email-michael@ellerman.id.au>
	 <20130725110447.GS27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 13:04 +0200, Peter Zijlstra wrote:
> On Wed, Jul 24, 2013 at 12:26:42PM +1000, Michael Ellerman wrote:
> > 
> > I would have used "p" obviously, but that's taken. Are folks happy that
> > "P" is sufficiently different from "p"? I couldn't think of anything
> > better.
> 
> I've seen proposals where 'P' is used for the max 'p' level :/

Hmm, OK.

So 'p' is for precise, which maps onto a 2 bit field in
perf_event_attr.precise_ip.

No 'p' modifier means precise_ip = 0, so the max value of 3 would be
'ppp' right?

We don't use 'p' so I have no idea how often it's used and whether
typing 'ppp' is going to be a major pain for people.

> But yes, vexing situation. 

Quite. Nothing jumps out as an obvious alternative, including any of the
symbols.

So how about 'D'.

Because it makes a smiley face:

 $ perf stat -e cycles:D

And having perf smile at you can't be a bad thing.

cheers



