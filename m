Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3G3QQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:16:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53726 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3G3QQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:16:43 -0400
Date: Tue, 30 Jul 2013 18:16:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
Message-ID: <20130730161629.GC32226@laptop.programming.kicks-ass.net>
References: <CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com>
 <20130708081919.GV23916@twins.programming.kicks-ass.net>
 <CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com>
 <20130730083758.GH3008@twins.programming.kicks-ass.net>
 <CABPqkBTxovrj11sskW50TZzf6e_V0tObT-qDPAbxHcrpLJNNZg@mail.gmail.com>
 <20130730090202.GL3008@twins.programming.kicks-ass.net>
 <CABPqkBRX-A5i26w1aMBmjb7GVmYUBS6k03ePN6qoASS9Z9xkmg@mail.gmail.com>
 <CABPqkBQeNEidngxK08O-eAA4aJhqe8R-F-8Vk8DA-Z1qtKdU_Q@mail.gmail.com>
 <20130730155212.GB32226@laptop.programming.kicks-ass.net>
 <CABPqkBQFpJjHLYuErcMdxTNKe4-JW_JZfYkEWrX5JHTZmWOqDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQFpJjHLYuErcMdxTNKe4-JW_JZfYkEWrX5JHTZmWOqDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 06:09:15PM +0200, Stephane Eranian wrote:
> On Tue, Jul 30, 2013 at 5:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Jul 30, 2013 at 04:21:41PM +0200, Stephane Eranian wrote:
> >> Peter,
> >>
> >> One thing that bothers me with the MMAP2 approach is that
> >> it forces integration into perf.
> >
> > This is a good (TM) thing, yes? ;-)
> >
> 
> Well, that's one way to look at it. But I'd like the API to
> be able to support more than one tool easily. If the barrier
> for any advanced analysis is too high from the raw kernel
> API then we will only have one tool. I don't think that sane.

Sure, but any half-way usable profiling will need the existing sideband
data. So I don't think that relying on it for this particular feature is
too much.
