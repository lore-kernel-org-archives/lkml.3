Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3JUWsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:48:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55284 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753582Ab3JUWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:47:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] cpufreq: s3c64xx: Rename index to driver_data
Date: Tue, 22 Oct 2013 00:58:58 +0200
Message-ID: <14557635.AKI3PpiVcs@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpom-KBME6fa3BUmKfZSgJxYngD7RG+CD3vHHKdtWtrtOxA@mail.gmail.com>
References: <1381775807-20144-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <CAKohpom-KBME6fa3BUmKfZSgJxYngD7RG+CD3vHHKdtWtrtOxA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 21, 2013 12:59:30 PM Viresh Kumar wrote:
> On 15 October 2013 00:06, Charles Keepax
> <ckeepax@opensource.wolfsonmicro.com> wrote:
> > The index field of cpufreq_frequency_table has been renamed to driver
> > data in this commit:
> >
> > commit 5070158804b5339c71809f5e673cea1cfacd804d
> > cpufreq: rename index as driver_data in cpufreq_frequency_table
> >
> > This patch updates the s3c64xx driver to match.
> >
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/cpufreq/s3c64xx-cpufreq.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
> > index 8a72b0c..15631f9 100644
> > --- a/drivers/cpufreq/s3c64xx-cpufreq.c
> > +++ b/drivers/cpufreq/s3c64xx-cpufreq.c
> > @@ -166,7 +166,7 @@ static void __init s3c64xx_cpufreq_config_regulator(void)
> >                 if (freq->frequency == CPUFREQ_ENTRY_INVALID)
> >                         continue;
> >
> > -               dvfs = &s3c64xx_dvfs_table[freq->index];
> > +               dvfs = &s3c64xx_dvfs_table[freq->driver_data];
> >                 found = 0;
> >
> >                 for (i = 0; i < count; i++) {
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> @Rafael: Can you please get this in 3.12 as a bug fix?

It went in already, didn't it?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
