Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3ITBbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 21:31:55 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47737 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3ITBbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 21:31:53 -0400
MIME-Version: 1.0
In-Reply-To: <11319698.mBBnJVdnIk@vostro.rjw.lan>
References: <1379563520-7221-1-git-send-email-yinghai@kernel.org>
	<CAKohpomt+sASL=2i-v=HSkhOZhbPmnFesEfPoEqSE+WKcCfnmw@mail.gmail.com>
	<11319698.mBBnJVdnIk@vostro.rjw.lan>
Date: Thu, 19 Sep 2013 18:31:52 -0700
X-Google-Sender-Auth: I0mIPnH198NoXM_hwXCc-TlWky0
Message-ID: <CAE9FiQXP3DARdJYHBS8w0ATVM78Q9tGTd=8CeMJiwozBU0F_OA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: return EEXIST instead of EBUSY for second registering
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 3:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, September 19, 2013 09:38:32 AM Viresh Kumar wrote:
>> On 19 September 2013 09:35, Yinghai Lu <yinghai@kernel.org> wrote:
>> > System that cpu support intel_pstate, acpi_cpufreq fail to
>> > load, and udev keep trying until trace get filled up and
>> > kernel crash.
>> >
>> > The root cause is driver return ret from cpufreq_register_driver
>> > and when some other driver take over before, it would return
>> > EBUSY, then udev will keep trying...
>> >
>> > cpufreq_register_driver should return EEXIST instead.
>> > then system could boot without appending intel_pstate=disable
>> > and still use intel_pstate.
>> >
>> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Applied, thanks!

Sorry,  looks like this one is not enough.

please let me know if you prefer me send addon patch
or revised one.

Thanks

Yinghai
