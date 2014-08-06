Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaHFURj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:17:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51956 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753151AbaHFURi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:17:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Anand Moon <moon.linux@yahoo.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq_opp.c: Fixed the __might_sleep by changing GFP_KERNEL to GFP_ATOMIC.
Date: Wed, 06 Aug 2014 22:36:19 +0200
Message-ID: <1959694.afxgG1N4Rp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140806150227.GA32301@codeaurora.org>
References: <1407183283-21921-1-git-send-email-moon.linux@yahoo.com> <CAKohpo=VQEtmSLE5-fQ8=zb-kkRYN8kZeaBPzMV5rF=WxxmeDg@mail.gmail.com> <20140806150227.GA32301@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 06, 2014 08:02:27 AM Stephen Boyd wrote:
> On 08/06, Viresh Kumar wrote:
> > On 6 August 2014 05:05, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > >> https://lkml.org/lkml/2014/7/16/815
> > >>
> > >> @Rafael: Have you already applied patch from above link?
> > >
> > > No, I haven't.  Do we need it after all?
> > 
> > I think yes, Right Stephen? :)
> 
> Yes.

OK, queued up for the next pull request, thanks!

