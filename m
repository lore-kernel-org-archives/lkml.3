Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaBZQNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:13:37 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40500 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaBZQNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:13:35 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 26 Feb 2014 08:13:26 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] drivers: cpufreq: Remove unused function in cpufreq.c
Message-ID: <20140226161325.GA17358@thin>
References: <20140226154625.GA10701@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140226154625.GA10701@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 09:16:25PM +0530, Rashika Kheria wrote:
> Remove unused function show_boost() in drivers/cpufreq/cpufreq.c.
> 
> This eliminates the following warning in drivers/cpufreq/cpufreq.c:
> drivers/cpufreq/cpufreq.c:355:9: warning: no previous prototype for ‘show_boost’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/cpufreq/cpufreq.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 08ca8c9..6dce474 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -352,12 +352,6 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
>  /*********************************************************************
>   *                          SYSFS INTERFACE                          *
>   *********************************************************************/
> -ssize_t show_boost(struct kobject *kobj,
> -				 struct attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
> -}
> -
>  static ssize_t store_boost(struct kobject *kobj, struct attribute *attr,
>  				  const char *buf, size_t count)
>  {
> -- 
> 1.7.9.5
> 
