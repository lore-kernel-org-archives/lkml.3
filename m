Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3FLD7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 23:59:42 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39046 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3FLD7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 23:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <65302617.R4ibdJPShF@vostro.rjw.lan>
References: <1683304a60f5188dc7f94e1a7797f12a4d1b47ab.1370581794.git.viresh.kumar@linaro.org>
	<65302617.R4ibdJPShF@vostro.rjw.lan>
Date: Wed, 12 Jun 2013 09:29:39 +0530
Message-ID: <CAKohpok0JrLv_i6=Gm5oM8PDP_i5pVyD-EphVPd0hT1THwfgbg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: stats: Remove CONFIG_CPU_FREQ_STAT_DETAILS
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cw00.choi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 03:52, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, June 07, 2013 10:42:57 AM Viresh Kumar wrote:
>> Current cpufreq stats has got three parts: time_in_state, total_trans and
>> trans_table.
>>
>> trans_table was present under a separate macro's from others:
>> CONFIG_CPU_FREQ_STAT_DETAILS
>
> And the reason why is exactly what is given in the documentation - it violates
> the sysfs interface rules.  So the option is "Do you want to have a sysfs file
> violating the rules and containing some more fine grained cpufreq stats?"
>
> I don't think we can just pretend that it doesn't violate the rules from now
> on, so I'm not going to apply this.

Ok.. thanks.
