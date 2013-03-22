Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3CVLRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:17:32 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62744 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3CVLRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAP245DWx_C0wcW-9SCfR0ViqyyqNbAeZnWfeMiXSgRGupo9jWQ@mail.gmail.com>
References: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org>
	<CAP245DWx_C0wcW-9SCfR0ViqyyqNbAeZnWfeMiXSgRGupo9jWQ@mail.gmail.com>
Date: Fri, 22 Mar 2013 16:47:29 +0530
Message-ID: <CAKohpo=bOcPLESk6p88gjHq=i-D8zFhhEL_4pgZUtjRYZnD_7w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Robin Randhawa <robin.randhawa@arm.com>,
        linux-pm@vger.kernel.org, Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Steve Bannister <Steve.Bannister@arm.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 16:42, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Fri, Mar 22, 2013 at 3:43 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> In cpufreq_stats_free_sysfs() we aren't balancing calls to cpufreq_cpu_get()
>> with cpufreq_cpu_put(). This will never let us have ref count to policy->kobj as
>> zero.
>
> Rafael,
>
> Since this prevents booting on our hardware (we unregister and
> re-register the cpufreq driver to account for virtual cores), will
> this be considered as a hotfix for 3.9?
>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Acked-by: Amit Kucheria <amit.kucheria@linaro.org>

Sorry i forgot to mention, this should be pushed for next rc.
