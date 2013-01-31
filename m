Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3AaWv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:51:29 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52799 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3AaWv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:51:28 -0500
Date: Thu, 31 Jan 2013 23:51:14 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 2/2] cpufreq: governors: Remove code redundancy between
 governors
Message-ID: <20130131225114.GA6433@balto.lan>
References: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
 <118c59263751862b1750ed9f96639a4e70069e66.1359653181.git.viresh.kumar@linaro.org>
 <20130131185004.GB20164@balto.lan>
 <1730121.raxo9SGZyf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1730121.raxo9SGZyf@vostro.rjw.lan>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Thu, Jan 31, 2013 at 11:23:54PM +0100, Rafael J. Wysocki wrote:
> On Thursday, January 31, 2013 07:50:04 PM Fabio Baltieri wrote:
> > On Thu, Jan 31, 2013 at 10:58:02PM +0530, Viresh Kumar wrote:
> > > With the inclusion of following patches:
> > > 
> > > 9f4eb10 cpufreq: conservative: call dbs_check_cpu only when necessary
> > > 772b4b1 cpufreq: ondemand: call dbs_check_cpu only when necessary
> > > 
> > > code redundancy is introduced again. Get rid of it.
> > > 
> > > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > ---
> > 
> > Hi,
> > 
> > Tested-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> 
> OK
> 
> Fabio, Viresh, Shawn,
> 
> This time I was *really* confused as to what patches I was supposed to take,
> from whom and in what order, so I applied a number of them in the order given
> by patchwork.  That worked well enough, because (almost) all of them applied
> for me without conflicts.  That said I would appreciate it if you could look
> into the bleeding-edge branch of my tree and see if there's anything missing
> or something that shouldn't be there (cpufreq-wise).

Sorry for the confusion, your current bleeding-edge branch (eed52da)
looks good to me.  I also did a quick build and run and it works fine on
my setup.

Many thanks,
Fabio

-- 
Fabio Baltieri
