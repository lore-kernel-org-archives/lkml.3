Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3GaEjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:39:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63326 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3GaEjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130731014328.5270.4248@quantum>
References: <1373247868-21444-1-git-send-email-mturquette@linaro.org>
	<1373247868-21444-4-git-send-email-mturquette@linaro.org>
	<CAOh2x=kAM98Qta5RquVVByR8jJ3=t+6fNZ4o4WSroVCCZi+0Cg@mail.gmail.com>
	<20130731014328.5270.4248@quantum>
Date: Wed, 31 Jul 2013 10:09:03 +0530
Message-ID: <CAKohpom-8KXixJ0ZbQ7Poh3uqJCqo7LFyYEfYeMyp+yZx9QmHA@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] cpufreq: cpufreq-cpu0: clk rate-change notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mike Turquette <mturquette@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2013 07:13, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Viresh Kumar (2013-07-07 21:10:54)
>> On Mon, Jul 8, 2013 at 7:14 AM, Mike Turquette <mturquette@linaro.org> wrote:
>> > Removes direct handling of OPP tables and voltage regulators by calling
>> > of_clk_cpufreq_notifier_handler, introduced by commit "clk: cpufreq
>> > helper for voltage scaling".
>> >
>> > In the future this can help consolidate code found across similar
>> > CPUfreq drivers.
>> >
>> > Signed-off-by: Mike Turquette <mturquette@linaro.org>
>> > ---
>> >  drivers/cpufreq/cpufreq-cpu0.c | 125 ++++++++---------------------------------
>> >  1 file changed, 22 insertions(+), 103 deletions(-)
>>
>> Good patch, really gets lots of stuff out from cpufreq drivers.
>>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Viresh,
>
> Thanks for the Ack. I received no comments on this series besides your
> own, so I plan to merge it. Do you want to take patch #3, or do you want
> me to take it, or should I give you and Rafael a stable branch instead?

Its only related to cpufreq-cpu0 and to handle dependencies well they
should go through a single tree.. Probably your tree is the right place for
now. Rafael?
