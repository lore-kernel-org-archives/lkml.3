Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaEHLjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 07:39:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64152 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753391AbaEHLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 07:39:39 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: mingo@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/idle: Reflow cpuidle_idle_call()
Date: Thu, 08 May 2014 13:56:18 +0200
Message-ID: <1591569.1rC3xo6G18@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1877683.4pfeUuvFZ2@vostro.rjw.lan>
References: <tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org> <1877683.4pfeUuvFZ2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 08, 2014 01:39:14 PM Rafael J. Wysocki wrote:
> On Thursday, May 08, 2014 03:47:40 AM tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  37352273ad48f2d177ed1b06ced32d5536b773fb
> > Gitweb:     http://git.kernel.org/tip/37352273ad48f2d177ed1b06ced32d5536b773fb
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Fri, 11 Apr 2014 13:55:48 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Thu, 8 May 2014 09:16:59 +0200
> > 
> > sched/idle: Reflow cpuidle_idle_call()
> > 
> > Apply goto to reduce lines and nesting levels.
> 
> Well, I have a couple of patches that will conflict with this.
> 
> This one in particular:
> 
> https://patchwork.kernel.org/patch/4071541/
> 
> which unfortunately already is in my linux-next branch, because I was
> unaware of this work.
> 
> I wonder how we can resolve this?

The cpuidle patches I have queued up so far are on this separate branch

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-cpuidle

in case you'd like to pull from there.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
