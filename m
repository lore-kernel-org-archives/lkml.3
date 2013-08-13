Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3HMBDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 21:03:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32100 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab3HMBDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 21:03:42 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F0my4ousGMIA:10 a=t7CeM3EgAAAA:8 a=PCqPzcZwi1q9O-lKYIUA:9 a=CjuIK1q_8ugA:10 a=2e6ZYRoF4I4A:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 12 Aug 2013 21:03:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
Message-ID: <20130812210341.4fa2165b@gandalf.local.home>
In-Reply-To: <CAP=VYLrd_ZU94Nf0X+FtT3M2Xx85t9FF13o-hV+_xHi7EjTf=w@mail.gmail.com>
References: <20130812163413.GI23040@linutronix.de>
	<20130812154810.433858a5@gandalf.local.home>
	<CAP=VYLrd_ZU94Nf0X+FtT3M2Xx85t9FF13o-hV+_xHi7EjTf=w@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 20:47:18 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> On Mon, Aug 12, 2013 at 3:48 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 12 Aug 2013 18:34:13 +0200
> > Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> >
> >> Dear RT folks!
> >>
> >> I'm pleased to announce the v3.10.6-rt3 patch set.
> >
> >
> > Does this mean that I can drop 3.6-rt in favor of 3.8-rt?
> 
> I'd guess that the trade-off would be 3.0-rt against 3.8-rt.
> The above comment assumes 3.0 is aged out vs. 3.6 kernel.

Not at all. I've always said that I would support -rt as long as the
base was supported by the official stable. 3.6 is not supported, and I
only supported it because it was the "latest" stable -rt. When 3.8-rt
comes out, it would also be the latest. But it too is not supported by
the official stable release. I'll only be doing that one until 3.10
becomes stable again. Luckily, 3.8 is being supported by Kamal, and
I'll probably just base my work off of his.

3.0-rt wont last long, as IIRC, Greg will be letting that go off to
ashes in a few months.

> 
> >
> > I'm just about finished with a 3.6 stable, which I'll finish, add -rt
> > to it, and then call it "unsupported" after that. Well, I may take bug
> > fixes if people find any in the near future.
> >
> > I'm behind on 3.4-rt, 3.2-rt and of course 3.0-rt. Hopefully, I'll get
> > them all out this week.
> 
> I expect that the 3.10-rt kernel will replace the older RT kernels.

No, it will just enter the realm of the official stable releases.

-- Steve
