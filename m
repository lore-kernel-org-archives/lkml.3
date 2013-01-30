Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3A3Q5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:57:55 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:42598 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab3A3Q5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:57:52 -0500
Date: Wed, 30 Jan 2013 17:57:39 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>
Subject: Re: [PATCH v7 1/4] cpufreq: handle SW coordinated CPUs
Message-ID: <20130130165739.GA21329@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
 <1359550803-18577-2-git-send-email-fabio.baltieri@linaro.org>
 <CAKohponwQFFtC3MKh72Z0bqYksV_P6D07VivQUYjai1qPB_J9g@mail.gmail.com>
 <20130130162225.GB30559@balto.lan>
 <CAKohpoms9AK+j+Au53cwbLn=ds0AsJn+ApUMgMxe2dVhC7McVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpoms9AK+j+Au53cwbLn=ds0AsJn+ApUMgMxe2dVhC7McVw@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 10:21:03PM +0530, Viresh Kumar wrote:
> > I'm not sure about the name through, I like mentioning sw coordination in it
> > because that's the comment in the declaration:
> >
> >         cpumask_var_t           cpus;   /* CPUs requiring sw coordination */
> >         cpumask_var_t           related_cpus; /* CPUs with any coordination */
> >
> > And those two are already confusing as a starting point.
> 
> I will fix these comments with a patch of mine.

Great!

> 
> > Anyway, this sounds fine to me.  If you think this is useful I can send
> > a patch, or feel free to include it in your patches if you plan to do
> > further cleanup work on this code.
> >
> > /me tries to also keep that ->cpu field in mind.
> 
> You can make it part of your patchsets v8.

I'm not sending a v8 as Rafael already asked for incremental, but I'll
send a patch with that soon.

Thanks,
Fabio

-- 
Fabio Baltieri
