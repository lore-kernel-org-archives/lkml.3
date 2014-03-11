Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaCKDqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:46:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33107 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaCKDqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 23:46:23 -0400
MIME-Version: 1.0
In-Reply-To: <3114708.oz7nbHtIzQ@vostro.rjw.lan>
References: <92837e0c0ed734bb82d3c7d78f58beb31b4e0c1f.1394446335.git.viresh.kumar@linaro.org>
	<3114708.oz7nbHtIzQ@vostro.rjw.lan>
Date: Tue, 11 Mar 2014 11:46:22 +0800
Message-ID: <CAKohpokSTM9tUYEK2ggSOwrgK=RfLmmKRdtzaRQ1q=d2jrUzWQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: SPEAr: Instantiate as platform_driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 March 2014 09:04, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, March 10, 2014 03:43:18 PM Viresh Kumar wrote:
>> As multiplatform build is being adopted by more and more ARM platforms, initcall
>> function should be used very carefully. For example, when SPEAr cpufreq driver
>> is enabled on a kernel booted on a non-SPEAr board, we will get following boot
>> time error:
>>
>>       spear_cpufreq: Invalid cpufreq_tbl
>>
>> To eliminate this undesired the effect, the patch changes SPEAr driver to have
>> it instantiated as a platform_driver. Then it will only run on platforms that
>> create the platform_device "spear-cpufreq".
>>
>> This patch also creates platform node for SPEAr13xx boards.
>>
>> Reported-by: Josh Cartwright <joshc@codeaurora.org>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Whoever maintains the SPEAr platform, I need an ACK from that person in order
> to take this patch.

Okay, here you go:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

:)
