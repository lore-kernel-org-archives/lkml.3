Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3AaLGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:06:30 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46461 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3AaLGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:06:25 -0500
Date: Thu, 31 Jan 2013 12:06:13 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governors: clean timer init and exit code
Message-ID: <20130131110613.GD30667@balto.lan>
References: <1359554017-28620-1-git-send-email-fabio.baltieri@linaro.org>
 <CAKohpomTNkEOrnyQWKJ8siajg67-fpe4EnYxiipgmN8STMSwAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomTNkEOrnyQWKJ8siajg67-fpe4EnYxiipgmN8STMSwAQ@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 04:23:06PM +0530, Viresh Kumar wrote:
> On 30 January 2013 19:23, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > Drop unused arguments from dbs_timer_init and clean dbs_timer_exit and
> > cpufreq_governor_dbs to remove non necessary special cases.
> >
> > Reported-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> As discussed over IRC, you will fix following in few days:
> - Code redundancy within governors
> - Removing second_time: label and cdbs->enable field
> - Fixing params to timer init and exit to make them more efficient.

That's the plan, I'd leave it up to Rafael to decide if further cleanup
patches should be included in 3.9 merge window or skip to the following
one... I understand that we are starting to be late on the -rc and I
also prefer to focus on fixup.

Thanks,
Fabio

> And here is my ack for this patch:
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Fabio Baltieri
