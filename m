Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3FREug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:50:36 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:51246 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3FREue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon3Tc+dSycv-QeLg9vwjXijaZrtjzw0-tHVAqX6moBUjA@mail.gmail.com>
References: <68ae523282b494da0e8f67536af1df874c326675.1370422554.git.viresh.kumar@linaro.org>
	<1855098.3p2j9hWHoD@vostro.rjw.lan>
	<CAKohpon3Tc+dSycv-QeLg9vwjXijaZrtjzw0-tHVAqX6moBUjA@mail.gmail.com>
Date: Tue, 18 Jun 2013 10:20:33 +0530
Message-ID: <CAKohpokwbLyCiL88i+6hKaLiKciZ0mZhOqenSzOJ7oBfgsCpZg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: userspace: Simplify governor
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        chenxg.marvell@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2013 18:38, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> To be honest with the amount of experience I have now, my log was
> poor :(
>
> I have used following log in the attached patch:
>
> Subject: [PATCH] cpufreq: userspace: Simplify governor
>
> Userspace governor has got more code than what it needs for its functioning.
> Lets simplify it. Portions of code removed are:
> - Extra header files which aren't required anymore (rearranged them as well)
> - cpu_{max|min|cur|set}_freq, as they are always same as policy->{max|min|cur}
> - userspace_cpufreq_notifier_block as we don't need to set cpu_cur_freq anymore
> - cpus_using_userspace_governor as it was for notifier code
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Hi Rafael,

Are you happy with the log & description of this patch now?
