Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688Ab3DBNgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:36:12 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50119 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760958Ab3DBNgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:36:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] cpufreq: Correct header guards typo
Date: Tue, 02 Apr 2013 15:43:45 +0200
Message-ID: <5885599.2UWpPkOcaY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAOh2x=nJTcaEAe5eS4JzHLY_vUx0HJo9pDD7exoq0OffMqzJDQ@mail.gmail.com>
References: <1364905575-10234-1-git-send-email-bp@alien8.de> <CAOh2x=nJTcaEAe5eS4JzHLY_vUx0HJo9pDD7exoq0OffMqzJDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 02, 2013 06:41:20 PM Viresh Kumar wrote:
> On Tue, Apr 2, 2013 at 5:56 PM, Borislav Petkov <bp@alien8.de> wrote:
> > From: Borislav Petkov <bp@suse.de>
> >
> > It should be "governor".
> >
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > ---
> >  drivers/cpufreq/cpufreq_governor.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> > index 513cc8234e5e..65937697cab3 100644
> > --- a/drivers/cpufreq/cpufreq_governor.h
> > +++ b/drivers/cpufreq/cpufreq_governor.h
> > @@ -14,8 +14,8 @@
> >   * published by the Free Software Foundation.
> >   */
> >
> > -#ifndef _CPUFREQ_GOVERNER_H
> > -#define _CPUFREQ_GOVERNER_H
> > +#ifndef _CPUFREQ_GOVERNOR_H
> > +#define _CPUFREQ_GOVERNOR_H
> >
> >  #include <linux/cpufreq.h>
> >  #include <linux/kobject.h>
> > @@ -263,4 +263,4 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> >                 struct common_dbs_data *cdata, unsigned int event);
> >  void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
> >                 unsigned int delay, bool all_cpus);
> > -#endif /* _CPUFREQ_GOVERNER_H */
> > +#endif /* _CPUFREQ_GOVERNOR_H */
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
