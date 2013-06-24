Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3FXKLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:11:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48888 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3FXKLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:11:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show accumulated data of CPUs
Date: Mon, 24 Jun 2013 12:20:57 +0200
Message-ID: <3966081.PYqoVoQ0Wq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=q+2ULzOSeipjb8xS6NZBJLbR8AMptVcufD1vzULJGGw@mail.gmail.com>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com> <24083337.GLRAoa2hpo@vostro.rjw.lan> <CAKohpo=q+2ULzOSeipjb8xS6NZBJLbR8AMptVcufD1vzULJGGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 03:11:15 PM Viresh Kumar wrote:
> On 24 June 2013 15:09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, June 24, 2013 11:48:22 AM Viresh Kumar wrote:
> >> On 21 June 2013 18:43, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > Well, to be honest, I don't like the whole thing.  The more changes you need
> >> > to make to the common code to support it, the worse.
> >>
> >> You meant you didn't like this patch completely? Or the idea that
> >> I gave?
> >
> > Well, kind of both ...
> >
> >> Getting the new frequency would be very useful IMHO. That would
> >> give us a relation between old/new freq and load on each cpu at
> >> that time. That's why I suggested it.
> >
> > Where "us" is user space or what?
> 
> User space as well as the developers who are accessing this information.

My impression was that that new interface wouldn't be useful on all platforms
supported by cpufreq.  If that's the case, I'd rather not make changes in the
core code that are needed only to implement that new interface, at least to
start with.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
