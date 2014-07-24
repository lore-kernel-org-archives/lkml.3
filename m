Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbaGXRSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:18:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:34739 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750843AbaGXRSY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:18:24 -0400
Date: Thu, 24 Jul 2014 13:18:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: =?ISO-8859-1?B?TeVucyBSdWxsZ+VyZA==?= <mans@mansr.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>, paul.gortmaker@windriver.com,
        gang.chen.5i5j@gmail.com, yongjun_wei@trendmicro.com.cn,
        Dan Carpenter <dan.carpenter@oracle.com>, tomas.winkler@intel.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
Message-ID: <20140724131821.30c4519d@gandalf.local.home>
In-Reply-To: <CAPDOMVgziyYTX41xZVB9FLHUKFRPPm19jo0A_WfbLqaaKbxPqg@mail.gmail.com>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
	<20140724144725.GA32669@home.goodmis.org>
	<20140724105132.3cf221c2@gandalf.local.home>
	<yw1x38dqag24.fsf@unicorn.mansr.com>
	<CAPDOMVgswyopjGxdRFW-bFRrTcpcNnkY=PqTCT9HbjjA=EZ1iw@mail.gmail.com>
	<yw1xy4vi90n6.fsf@unicorn.mansr.com>
	<CAPDOMVia0OXydg_hRH0t63xUaxKEkVc6D20vAZiyugkMXAEsJQ@mail.gmail.com>
	<yw1xtx669002.fsf@unicorn.mansr.com>
	<CAPDOMVgziyYTX41xZVB9FLHUKFRPPm19jo0A_WfbLqaaKbxPqg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014 12:50:31 -0400
Nick Krause <xerofoify@gmail.com> wrote:

\
> > Most kernel devs most certainly did NOT get started by spamming lkml
> > with unnecessary and incorrect patches despite being repeatedly told to
> > go away and stop wasting everybody's time.

Mans, shut up! That is uncalled for.


> >
> > --
> > Måns Rullgård
> > mans@mansr.com
> 
> 
> 
> FIne , I give up. You want me to leave this then I wiil.

No, that's not what I said.

> I am have this discussion with other kernel developers and just
> because I send out one patch as a newbie like this doesn't mean I
> don't known C.  

It's not just one patch, and I didn't say you don't know C. I said you
don't understand C enough for kernel development.

Look, I really do like you enthusiasm, and I'm sorry that you are being
attacked the way you were. Some of the attacks are uncalled for, and I
even regret some of my own previous emails to you, as they too were
uncalled for. But I do not regret my reply in this thread.

I worked in various jobs for 6 years before touching the kernel. It was
2 years after that that I started doing trivial patches (fixing
off-by-one bugs and such). Then I started out doing real time
development outside of the mainline kernel for several more years
before I starting writing code for mainline.

That is, you don't just jump into kernel development before having a
solid foundation of programming skills.

The patch I replied to didn't just have a mistake. It really was wrong
on several levels that it couldn't be right. Getting such a simple patch
so wrong really shows that you need more experience.

Please, start working with some userspace projects first, where you can
easily walk through the code using gdb to understand how things work.
Spend a year or two doing that kind of work. There's even paying jobs
out there that require this. There's tons of opensource projects that
need help. The Linux kernel is really the biggest opensource project
and very intense. A "newbie" here means you haven't done much with the
kernel, but you have done a lot of coding in the past. It doesn't mean
"newbie" to development in general.

I've been told by my wife that I'm very blunt and say what's on my
mind. I'm not very tactful, as I hate beating around the bush. I hate
it when people beat around the bush with me, I usually just tell them to
"spit it out!" Thus, I treat people as I want to be treated, that is
"in-your-face truth".

Again, don't "go away" and never come back. "go away, learn a bit more,
then come back".

A lot of us are overworked and staring at code all day. We get grumpy,
and when someone comes along and starts spamming us with nonsense
changes, we sometimes bite back. Don't take it personally. I'm serious
when I say, just spend some time on userspace projects, then work you
way to some drivers, and then you can be more active, and more
importantly, more useful to the Linux kernel project :-)

-- Steve
