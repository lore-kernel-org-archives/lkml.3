Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3BSGR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 01:17:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab3BSGR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 01:17:58 -0500
Message-ID: <1361254665.5804.32.camel@marge.simpson.net>
Subject: Re: [PREEMPT RT] SLUB and split softirq lock for v3.2-rt
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>
Date: Tue, 19 Feb 2013 07:17:45 +0100
In-Reply-To: <1361246801.23152.195.camel@gandalf.local.home>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
	 <1360776274.23152.7.camel@gandalf.local.home> <5122DB72.7030100@huawei.com>
	 <5122DBC1.6010507@huawei.com>
	 <1361246801.23152.195.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:A5TDyFWSI/bTz//kW2yYCaHcDWeGsXyZvTMHGw2XXKI
 YDCiBed4nchGA/kqj8j45HVy12RLGqiSdJNGGD6tVcbm+SPEOF
 SEAguLBBipvJdX6n9UlreGQl5qEKmTcDKO2bDR02mVGF+hodkb
 r5Kt5GthVb0atdZZC+uRt2JZCAJ4dtDcaRoNVdAR5Iei3q05ox
 YDYeqwkwHyFHEg1VzJLG3k84oM2XGTG1VnqJtMDqVsZcmgFVkc
 i9njUwFcyJCQyveo5j+yQYAKC1pgRSc3K589XM3ib5VetBETTC
 jM1RmUAz/1bufDPsE6xJsauo/aLj5rRBh8esNGgHPWNJNl60sP
 RMe0PHAwTr9ywBsZ9oyJihJy8NihAiKpy/+mWT7zXJeuG1lLzZ
 rSl49ujXqo0sw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 23:06 -0500, Steven Rostedt wrote: 
> On Tue, 2013-02-19 at 09:56 +0800, Li Zefan wrote:
> 
> > Oh ignore me. Just saw the patchset for 3.4-rt.
> 
> Note, I already have part of the 3.4-feature (softirq backport) tested
> and ready. What I'm waiting on is trying to figure out the best way to
> process it.
> 
> I already know I'll have a v3.4-features branch, but I'm thinking about
> patches and tarballs, if it should be posted as well, or just be in git?

If I had a vote, it'd be for git only.

Extracting patches or using git directly is trivial.  The less time
maintainers spend on trivial crud, the more time they have for hard
stuff.  Git only is a win for maintainers _and_ us greedy users :)

-Mike

