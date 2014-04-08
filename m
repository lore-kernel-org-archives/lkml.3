Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaDHGvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:51:39 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56642 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbaDHGvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:51:37 -0400
Message-ID: <53439C6C.4050409@gmail.com>
Date: Tue, 08 Apr 2014 14:51:24 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers:cpufreq:unicore32: fix typo issue for 'clk'
References: <53429445.5000005@gmail.com>	<CAKohpok189SxuJoGNvgshwEaUozMDM9mzA8wse5COkN8MBUaPg@mail.gmail.com>	<53434A4E.2050407@gmail.com>	<CAKohponSStjFJyKt7Yy7EX1wfk3xbJxoXpt47qStcSGfQVK7aw@mail.gmail.com>	<53437D91.8070504@gmail.com> <CAKohpokFiuP0JFu0seOFL8PQXSE9dv+NxypKzRgUjq0wYMvw6g@mail.gmail.com>
In-Reply-To: <CAKohpokFiuP0JFu0seOFL8PQXSE9dv+NxypKzRgUjq0wYMvw6g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/08/2014 01:29 PM, Viresh Kumar wrote:
> On 8 April 2014 10:09, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> OK, I will/should try within this week, thanks.
> 
> Rafael has already applied this patch and has mentioned stable in
> 'Cc:' field. And it looks it will be applied automatically and you don't
> need to do anything now :)
> 

OK, thank all of you!!

:-)

> 
> commit b4ddad95020e65cfbbf9aee63d3bcdf682794ade
> Author: Chen Gang <gang.chen.5i5j@gmail.com>
> Date:   Mon Apr 7 20:04:21 2014 +0800
> 
>     cpufreq: unicore32: fix typo issue for 'clk'
> 
>     Need use 'clk' instead of 'mclk', which is the original removed local
>     variable.
> 
>     The related original commit:
> 
>       "652ed95 cpufreq: introduce cpufreq_generic_get() routine"
> 
>     The related error with allmodconfig for unicore32:
> 
>         CC      drivers/cpufreq/unicore2-cpufreq.o
>       drivers/cpufreq/unicore2-cpufreq.c: In function 'ucv2_target':
>       drivers/cpufreq/unicore2-cpufreq.c:48: error: 'struct
> cpufreq_policy' has no member named 'mclk'
>       make[2]: *** [drivers/cpufreq/unicore2-cpufreq.o] Error 1
>       make[1]: *** [drivers/cpufreq] Error 2
>       make: *** [drivers] Error 2
> 
>     Fixes: 652ed95d5fa6 (cpufreq: introduce cpufreq_generic_get() routine)
>     Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>     Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>     Cc: 3.14+ <stable@vger.kernel.org> # 3.14+
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
