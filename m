Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab3AaNAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:00:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36106 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab3AaNAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:00:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governors: clean timer init and exit code
Date: Thu, 31 Jan 2013 14:06:17 +0100
Message-ID: <1560132.gKXbKl82oR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130131110613.GD30667@balto.lan>
References: <1359554017-28620-1-git-send-email-fabio.baltieri@linaro.org> <CAKohpomTNkEOrnyQWKJ8siajg67-fpe4EnYxiipgmN8STMSwAQ@mail.gmail.com> <20130131110613.GD30667@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 31, 2013 12:06:13 PM Fabio Baltieri wrote:
> On Thu, Jan 31, 2013 at 04:23:06PM +0530, Viresh Kumar wrote:
> > On 30 January 2013 19:23, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > > Drop unused arguments from dbs_timer_init and clean dbs_timer_exit and
> > > cpufreq_governor_dbs to remove non necessary special cases.
> > >
> > > Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > 
> > As discussed over IRC, you will fix following in few days:
> > - Code redundancy within governors
> > - Removing second_time: label and cdbs->enable field
> > - Fixing params to timer init and exit to make them more efficient.
> 
> That's the plan, I'd leave it up to Rafael to decide if further cleanup
> patches should be included in 3.9 merge window or skip to the following
> one... I understand that we are starting to be late on the -rc and I
> also prefer to focus on fixup.

The deadline for 3.9 merge window patches is about 2 days before 3.8-rc7
(assuming that there will be -rc7) and by that time they need to be in
linux-next.  Whatever doesn't make it will have to go after 3.9-rc1 or be
postponed until the 3.10 merge window.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
