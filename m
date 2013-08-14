Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3HNOhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:37:47 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:54191 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3HNOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130814143535.GB3263@samfundet.no>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
	<6fe9b31a6e199052e0a91b38c8f6d110e9f57b28.1376486713.git.viresh.kumar@linaro.org>
	<20130814143535.GB3263@samfundet.no>
Date: Wed, 14 Aug 2013 20:07:44 +0530
Message-ID: <CAKohpo=n9o+EKkboc1hw7ms_NkNwbsJ4VvEA2cB0R7gUi-U94A@mail.gmail.com>
Subject: Re: [PATCH 04/37] cpufreq: at32ap: don't initialize part of policy
 that is set by core too
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2013 20:05, Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:
> Around Wed 14 Aug 2013 19:01:53 +0530 or thereabout, Viresh Kumar wrote:
>> Many common initializations of struct policy are moved to core now and hence
>> this driver doesn't need to do it. This patch removes such code.
>>
>> Most recent of those changes is to call ->get() in the core after calling
>> ->init().
>
> It would be easier to review if you add me to CC on the new APIs you
> implement as well. Now I had to look up what the ->get() call did.

I know my track record hasn't been impressive on this subject but I am
sure I am following this since sometime now :)

https://lkml.org/lkml/2013/8/14/285
