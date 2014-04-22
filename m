Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaDVXUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:20:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56707 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751323AbaDVXUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:20:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched / idle: Make cpuidle_idle_call() void
Date: Wed, 23 Apr 2014 01:36:42 +0200
Message-ID: <107574725.ErYUTC83FZ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140422114930.GH11182@twins.programming.kicks-ass.net>
References: <4717784.WmVEpDoliM@vostro.rjw.lan> <20140422114930.GH11182@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 01:49:30 PM Peter Zijlstra wrote:
> On Mon, Apr 21, 2014 at 01:26:58AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The only value ever returned by cpuidle_idle_call() is 0 and its
> > only caller ignores that value anyway, so make it void.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Thanks!

OK, thanks, so should it go through my tree or through tip?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
