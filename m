Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3IKHuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:50:44 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:53102 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3IKHum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:50:42 -0400
MIME-Version: 1.0
In-Reply-To: <1525010.ijhgMNYcdJ@vostro.rjw.lan>
References: <CAKohpom90VAMYHkp3stbJJ-7H3y3zrVoQ+1q=Vza2Q0JhG8bNw@mail.gmail.com>
	<20130910141603.6225fe4e@amdc308.digital.local>
	<1525010.ijhgMNYcdJ@vostro.rjw.lan>
Date: Wed, 11 Sep 2013 13:20:41 +0530
Message-ID: <CAKohpo=4sg9AkXuwBwLVuj7_sdAdwap7a0Yp41KSEHvNMyWaTQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] cpufreq:boost: CPU Boost mode support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is some important piece of information that might be useful for
others and so cc'ing LKML and other lists..

On 11 September 2013 01:06, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, September 10, 2013 02:16:03 PM Lukasz Majewski wrote:
>> For my curiosity - what is the difference between bleeding-edge and
>> linux-next branches at kernel_pm?
>
> linux-next are patches that I'm going to push to Linus in the future and that
> have passed automated build testing.  I still may drop one of them occasionally
> or add tags to commits and rebase the branch as a result, though.
>
> bleeding-edge is linux-next plus patches under automated build testing, but it
> may contain some purely experimental stuff too.  During a merge window, like
> for example today, it also may contain material for the second next release
> (like 3.13 at the moment).
>
> In addition to those, there are topic branches like pm-cpufreq, acpica etc.
> that are only material either in the Linus' tree already or going to be pushed
> to Linus going forward and I don't rebase them.
>
> So if you want a stable branch to work on top of, either use one of the topic
> branches (but please note that they may be somewhat behind Linus sometimes), or
> ask me for one directly.
>
> Thanks,
> Rafael
>
