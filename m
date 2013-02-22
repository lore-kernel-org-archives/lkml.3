Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3BVCIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:08:18 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:45245 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3BVCIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:08:13 -0500
MIME-Version: 1.0
In-Reply-To: <3793606.bilcxohA80@vostro.rjw.lan>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
	<ece24bb874ad1834fc43b83f053b2560db8c25d3.1360568193.git.viresh.kumar@linaro.org>
	<3793606.bilcxohA80@vostro.rjw.lan>
Date: Fri, 22 Feb 2013 07:38:12 +0530
Message-ID: <CAKohpom8HiBEXE54BL72s-nWaeXzSRTrp7=MQKrJcon17T9tXQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] cpufreq: Add per policy governor-init/exit infrastructure
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 05:05, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, February 11, 2013 01:20:00 PM Viresh Kumar wrote:

>> This patch is inclined towards providing this infrastructure. Because we are
>> required to allocate governor's resources dynamically now, we must do it at
>> policy creation and end. And so got CPUFREQ_GOV_POLICY_INIT/EXIT.
>
> Are those new events NOPs now?

No. These are used atleast for ondemand & conservative.

>> +#define CPUFREQ_GOV_POLICY_INIT      4
>> +#define CPUFREQ_GOV_POLICY_EXIT      4
>
> Why don't you use different values here?
>
> If you need only one value, one #define should be sufficient.

Naah, something happened... I got fixed this locally but couldn't
get that into the commit somehow. EXIT should have 5 here.
