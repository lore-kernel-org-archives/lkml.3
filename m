Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaLaKXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 05:23:33 -0500
Received: from sauhun.de ([89.238.76.85]:43306 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaLaKXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 05:23:31 -0500
Date: Wed, 31 Dec 2014 11:23:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 05/28] cpufreq: drop owner assignment from
 platform_drivers
Message-ID: <20141231102326.GA1461@katana>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-6-git-send-email-wsa@the-dreams.de>
 <CAKohpok_G3Gf3XbcK06ELM3ocWQmNPepx1i72VXR8sNbK1L81Q@mail.gmail.com>
 <2262992.pVJSfL5P4D@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2262992.pVJSfL5P4D@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:39:32PM +0100, Rafael J. Wysocki wrote:
> On Monday, December 22, 2014 07:14:56 AM Viresh Kumar wrote:
> > On 22 December 2014 at 02:44, Wolfram Sang <wsa@the-dreams.de> wrote:
> > > This platform_driver does not need to set an owner, it will be populated by the
> > > driver core.
> > >
> > > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> > > ---
> > > Generated with coccinelle. SmPL file is in the introductory msg. The big
> > > cleanup was pulled in this merge window. This series catches the bits fallen
> > > through. The patches shall go in via the subsystem trees.
> > >
> > >  drivers/cpufreq/ls1x-cpufreq.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/drivers/cpufreq/ls1x-cpufreq.c b/drivers/cpufreq/ls1x-cpufreq.c
> > > index 25fbd6a1374f..f0913eee2f50 100644
> > > --- a/drivers/cpufreq/ls1x-cpufreq.c
> > > +++ b/drivers/cpufreq/ls1x-cpufreq.c
> > > @@ -210,7 +210,6 @@ out:
> > >  static struct platform_driver ls1x_cpufreq_platdrv = {
> > >         .driver = {
> > >                 .name   = "ls1x-cpufreq",
> > > -               .owner  = THIS_MODULE,
> > >         },
> > >         .probe          = ls1x_cpufreq_probe,
> > >         .remove         = ls1x_cpufreq_remove,
> > 
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > --
> 
> OK
> 
> Wolfram, please feel free to push this through whatever tree you think is
> appropriate.

I'd prefer if you take it. However, I'll send all leftover ones to Greg,
so you can decide.

