Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaBZXw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:52:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56164 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752691AbaBZXw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:52:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: josh@joshtriplett.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v3] drivers: cpufreq: Mark function as static in cpufreq.c
Date: Thu, 27 Feb 2014 01:07:28 +0100
Message-ID: <2246444.oMnRuKn9p2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140226221651.GA24021@cloud>
References: <20140226154625.GA10701@rashika> <16591432.HQVTHU5NYJ@vostro.rjw.lan> <20140226221651.GA24021@cloud>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 26, 2014 02:16:51 PM josh@joshtriplett.org wrote:
> On Wed, Feb 26, 2014 at 10:56:45PM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, February 26, 2014 10:12:42 PM Rashika Kheria wrote:
> > > Mark function as static in cpufreq.c because it is not
> > > used outside this file.
> > > 
> > > This eliminates the following warning in cpufreq.c:
> > > drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for ‘show_boost’ [-Wmissing-prototypes]
> > > 
> > > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > 
> > v2 has been Reviewed-by: Josh already, right?
> 
> Feel free to forward-propagate to v3 as well, if that helps.

OK

Applied, thanks!

> > > ---
> > > Changes since v1:
> > > Incorrect Fix
> > > Changes since v2:
> > > Show Changelog
> > > 
> > >  drivers/cpufreq/cpufreq.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > > index 08ca8c9..54fd670 100644
> > > --- a/drivers/cpufreq/cpufreq.c
> > > +++ b/drivers/cpufreq/cpufreq.c
> > > @@ -352,7 +352,7 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
> > >  /*********************************************************************
> > >   *                          SYSFS INTERFACE                          *
> > >   *********************************************************************/
> > > -ssize_t show_boost(struct kobject *kobj,
> > > +static ssize_t show_boost(struct kobject *kobj,
> > >  				 struct attribute *attr, char *buf)
> > >  {
> > >  	return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
> > > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
