Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaLVWRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:17:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56407 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755762AbaLVWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:17:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 05/28] cpufreq: drop owner assignment from platform_drivers
Date: Mon, 22 Dec 2014 23:39:32 +0100
Message-ID: <2262992.pVJSfL5P4D@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpok_G3Gf3XbcK06ELM3ocWQmNPepx1i72VXR8sNbK1L81Q@mail.gmail.com>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de> <1419196495-9626-6-git-send-email-wsa@the-dreams.de> <CAKohpok_G3Gf3XbcK06ELM3ocWQmNPepx1i72VXR8sNbK1L81Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 22, 2014 07:14:56 AM Viresh Kumar wrote:
> On 22 December 2014 at 02:44, Wolfram Sang <wsa@the-dreams.de> wrote:
> > This platform_driver does not need to set an owner, it will be populated by the
> > driver core.
> >
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> > ---
> > Generated with coccinelle. SmPL file is in the introductory msg. The big
> > cleanup was pulled in this merge window. This series catches the bits fallen
> > through. The patches shall go in via the subsystem trees.
> >
> >  drivers/cpufreq/ls1x-cpufreq.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/ls1x-cpufreq.c b/drivers/cpufreq/ls1x-cpufreq.c
> > index 25fbd6a1374f..f0913eee2f50 100644
> > --- a/drivers/cpufreq/ls1x-cpufreq.c
> > +++ b/drivers/cpufreq/ls1x-cpufreq.c
> > @@ -210,7 +210,6 @@ out:
> >  static struct platform_driver ls1x_cpufreq_platdrv = {
> >         .driver = {
> >                 .name   = "ls1x-cpufreq",
> > -               .owner  = THIS_MODULE,
> >         },
> >         .probe          = ls1x_cpufreq_probe,
> >         .remove         = ls1x_cpufreq_remove,
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> --

OK

Wolfram, please feel free to push this through whatever tree you think is
appropriate.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
