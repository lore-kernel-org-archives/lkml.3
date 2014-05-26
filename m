Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaEZLan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:30:43 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49366 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751591AbaEZLal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:30:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
Date: Mon, 26 May 2014 13:47:44 +0200
Message-ID: <9956935.0oj56vcaUh@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpomam0qKdkMMMRDOfWN9QnZ3DzCviV=RuZ5f_7JbmYNDNw@mail.gmail.com>
References: <20140521073457.GD31687@pengutronix.de> <9956925.Qsz2bH3rDg@vostro.rjw.lan> <CAKohpomam0qKdkMMMRDOfWN9QnZ3DzCviV=RuZ5f_7JbmYNDNw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 26, 2014 04:37:13 PM Viresh Kumar wrote:
> On 26 May 2014 16:52, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > I agree as far as the 64-bit thing goes, but is switching to Hz really
> > necessary?
> 
> Don't really know that.. It seems that there will always be problems with
> close enough frequencies whenever rounding is done.

Well, rounding errors are a problem, but question is if that is enough of
a problem to justify expanding the storage size twice.  Also, that'd be
a performance hit on 32-bit systems.

> More can be elaborated by Soren.

OK

Rafael

