Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaEILKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:10:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56117 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752724AbaEILKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:10:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH] PM / suspend: Always use deepest C-state in the "freeze" sleep state
Date: Fri, 09 May 2014 13:26:47 +0200
Message-ID: <2485687.UrJORvS9e7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140509073835.GB4965@xo-6d-61-c0.localdomain>
References: <2548502.zJ1no3NhRc@vostro.rjw.lan> <20140509073835.GB4965@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 09:38:35 AM Pavel Machek wrote:
> On Mon 2014-05-05 00:51:54, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > If freeze_enter() is called, we want to bypass the current cpuidle
> > governor and always use the deepest available (that is, not disabled)
> > C-state, because we want to save as much energy as reasonably possible
> > then and runtime latency constraints don't matter at that point, since
> > the system is in a sleep state anyway.
> 
> Would there be way to pass the parameter "go to deepest" instead of adding
> global state for this?

I'm not sure what you mean?  A parameter of what in particular?  And where
to pass it?

Rafael

