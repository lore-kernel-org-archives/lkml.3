Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab3CVLzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:55:15 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42232 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab3CVLzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <38998218.UX7TkEXzYs@vostro.rjw.lan>
References: <234906745c34fb72b0c450d897f261a22ed18d40.1363947023.git.viresh.kumar@linaro.org>
	<CAP245DWx_C0wcW-9SCfR0ViqyyqNbAeZnWfeMiXSgRGupo9jWQ@mail.gmail.com>
	<38998218.UX7TkEXzYs@vostro.rjw.lan>
Date: Fri, 22 Mar 2013 17:25:13 +0530
Message-ID: <CAKohpo=TFO5CEtO_tDxTthC3K01yh08v9h7hXr2Oq4zffgb2OQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: stats: do cpufreq_cpu_put() corresponding to cpufreq_cpu_get
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <robin.randhawa@arm.com>, linux-pm@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Steve Bannister <Steve.Bannister@arm.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 17:29, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Sure.  Can you please remind me what hardware is that, though?

Not yet upstreamed: big LITTLE :)

But, this is broken for all other platforms too.. You just need to compile
your driver as module and insmod/remove it to call
cpufreq_driver_unregister().
