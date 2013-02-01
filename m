Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3BACbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:31:52 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39803 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3BACbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:31:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130131225114.GA6433@balto.lan>
References: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
	<118c59263751862b1750ed9f96639a4e70069e66.1359653181.git.viresh.kumar@linaro.org>
	<20130131185004.GB20164@balto.lan>
	<1730121.raxo9SGZyf@vostro.rjw.lan>
	<20130131225114.GA6433@balto.lan>
Date: Fri, 1 Feb 2013 08:01:49 +0530
Message-ID: <CAKohpomdOzuXXGAr2r0LFULhr5AYLHWyhDON+9AKjMv9L6zkAg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: governors: Remove code redundancy between governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Shawn Guo <shawn.guo@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2013 04:21, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> On Thu, Jan 31, 2013 at 11:23:54PM +0100, Rafael J. Wysocki wrote:
>> This time I was *really* confused as to what patches I was supposed to take,
>> from whom and in what order, so I applied a number of them in the order given
>> by patchwork.  That worked well enough, because (almost) all of them applied
>> for me without conflicts.  That said I would appreciate it if you could look
>> into the bleeding-edge branch of my tree and see if there's anything missing
>> or something that shouldn't be there (cpufreq-wise).
>
> Sorry for the confusion, your current bleeding-edge branch (eed52da)
> looks good to me.  I also did a quick build and run and it works fine on
> my setup.

Really!! I see bleeding edge as df0e3f4 and i don't see the $(subject) patch
in it :)
