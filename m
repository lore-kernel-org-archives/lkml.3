Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3HLGHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:07:53 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49963 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab3HLGHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130810082333.GA27640@samfundet.no>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
	<c70729588f2f21d10fa5d53e5189890af4248a93.1376116345.git.viresh.kumar@linaro.org>
	<20130810082333.GA27640@samfundet.no>
Date: Mon, 12 Aug 2013 11:37:45 +0530
Message-ID: <CAKohpon63d40c8eGKqY9EHZhb18ipKHhvBffo=buLLpP=CP0rA@mail.gmail.com>
Subject: Re: [PATCH 11/44] cpufreq: at32ap: Use generic cpufreq routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 August 2013 13:53, Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:
> Around Sat 10 Aug 2013 12:14:07 +0530 or thereabout, Viresh Kumar wrote:
>> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
>> and .attr. So its better if we have generic routines for them which can be used
>> by cpufreq drivers then.
>>
>> This patch uses these generic routines for this driver.
>
> Nice, thanks for cleaning up (-:
>
>> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

Thanks for your Ack but I have to NACK it :)

My patch was wrong.. It was based on the assumption that everybody who
had implemented a .target() also implements a frequency table and exposes
it.. And the generic routines I have exposed depend on that frequency table.
And this cpufreq driver doesn't expose that freq table...

And so this patch is dropped :(

--
viresh
