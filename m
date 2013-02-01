Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3BADwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:52:38 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57020 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3BADwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:52:36 -0500
MIME-Version: 1.0
In-Reply-To: <20130131184449.GA20164@balto.lan>
References: <09a94ff044ff6a6f7a5d953c3b1f3102c1dc50cf.1359653181.git.viresh.kumar@linaro.org>
	<20130131184449.GA20164@balto.lan>
Date: Fri, 1 Feb 2013 09:22:35 +0530
Message-ID: <CAKohponyY1goyV_5U3f3ZFVuMqp2XsrAevNCvZ9Juoyg53LjnA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: governors: Get rid of dbs_data->enable field
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2013 00:14, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Hello Viresh, thanks for getting this done... looks much cleaner now!
>
> I tested both patches on my ux500 setup (dual Cortex-A9) and it seems to
> run correctly on both CPU load changes and CPU hotplug, so:
>
> Tested-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Thanks.

> As a sidenote, I noticed just now that since:
>
> bc92bea cpufreq: Notify governors when cpus are hot-[un]plugged
>
> governor's sampling_rate gets reset to default every time you hotplug a
> CPU (the one you read/write on
> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate).
>
> If you need further tests, I'll be back on Monday.

I will have a look.
