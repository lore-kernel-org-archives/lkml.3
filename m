Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbaD3WuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:50:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50591 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759586AbaD3WuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:50:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v4 5/8] mfd: db8500-prcmu: Use cpufreq_for_each_entry macro for iteration
Date: Thu, 01 May 2014 01:06:34 +0200
Message-ID: <1853484.NiSvS4ksI8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4646665.ZmnOyyFeHY@vostro.rjw.lan>
References: <534DB213.7080802@semaphore.gr> <20140422112717.GA21613@lee--X1> <4646665.ZmnOyyFeHY@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 01:49:31 PM Rafael J. Wysocki wrote:
> On Tuesday, April 22, 2014 12:27:17 PM Lee Jones wrote:
> > On Tue, 22 Apr 2014, Rafael J. Wysocki wrote:
> > 
> > > On Tuesday, April 22, 2014 08:15:41 AM Lee Jones wrote:
> > > > > The cpufreq core now supports the cpufreq_for_each_entry macro helper
> > > > > for iteration over the cpufreq_frequency_table, so use it.
> > > > > 
> > > > > It should have no functional changes.
> > > > 
> > > > > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> > > > > ---
> > > > 
> > > > It would be good to have a changelog which describes the differences
> > > > between the versions, so we can keep track.
> > > > 
> > > > >  drivers/mfd/db8500-prcmu.c | 19 ++++++++-----------
> > > > >  1 file changed, 8 insertions(+), 11 deletions(-)
> > > > 
> > > > So it looks like I already applied v2 of this patch to my tree. What
> > > > changed in v3 and v4? Should I remove that patch from MFD and apply
> > > > this one instead?
> > > 
> > > The reason why v4 was sent is because I asked for it.
> > > 
> > > And if you applied [5/8] without [1/8], it won't work, because the macro is
> > > introduced by that patch.
> > 
> > That's right, which is why I mailed you about it:
> > 
> >   > > > Applied untested by me.
> >   > >
> >   > > Wouldn't build. Let it go via Rafael.
> >   >
> >   > Rafael, would you mind creating a branch from this patch set that we
> >   > can both pull from please?
> > 
> > > If that's the case, please drop [5/8] and let me handle the entire series.
> > 
> > I'm happy for you to apply the series and send me a pull-request for
> > either a) the entire series or b) just the patches which touch MFD and
> > any subsequent decencies. Or I can apply them and send you one.
> 
> OK, I'll create a separate branch with those patches and will let you know
> where it is.

This material is on the cpufreq-macros branch of the linux-pm.git tree now, so

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git cpufreq-macros

will be safe to pull from going forward.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
