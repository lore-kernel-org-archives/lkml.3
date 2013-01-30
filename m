Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3A3Vhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:37:51 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34352 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab3A3Vht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:37:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>
Subject: Re: [PATCH v7 1/4] cpufreq: handle SW coordinated CPUs
Date: Wed, 30 Jan 2013 22:44 +0100
Message-ID: <1691889.6OP5HVPKVS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130130165739.GA21329@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org> <CAKohpoms9AK+j+Au53cwbLn=ds0AsJn+ApUMgMxe2dVhC7McVw@mail.gmail.com> <20130130165739.GA21329@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 30, 2013 05:57:39 PM Fabio Baltieri wrote:
> On Wed, Jan 30, 2013 at 10:21:03PM +0530, Viresh Kumar wrote:
> > > I'm not sure about the name through, I like mentioning sw coordination in it
> > > because that's the comment in the declaration:
> > >
> > >         cpumask_var_t           cpus;   /* CPUs requiring sw coordination */
> > >         cpumask_var_t           related_cpus; /* CPUs with any coordination */
> > >
> > > And those two are already confusing as a starting point.
> > 
> > I will fix these comments with a patch of mine.
> 
> Great!
> 
> > 
> > > Anyway, this sounds fine to me.  If you think this is useful I can send
> > > a patch, or feel free to include it in your patches if you plan to do
> > > further cleanup work on this code.
> > >
> > > /me tries to also keep that ->cpu field in mind.
> > 
> > You can make it part of your patchsets v8.
> 
> I'm not sending a v8 as Rafael already asked for incremental, but I'll
> send a patch with that soon.

Yes, please.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
