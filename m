Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3INE3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:29:22 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55034 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3INE3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <10372288.T6XyLE5FeS@vostro.rjw.lan>
References: <cover.1379062834.git.viresh.kumar@linaro.org>
	<10372288.T6XyLE5FeS@vostro.rjw.lan>
Date: Sat, 14 Sep 2013 09:59:15 +0530
Message-ID: <CAKohponbmEDmq3c85h=oSNKTfy+BcS0SLVdGp42osOrGQJha9g@mail.gmail.com>
Subject: Re: [PATCH 0/2] cpufreq: fix transition_ongoing count for powernow-k8
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2013 05:12, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, September 13, 2013 06:29:37 PM Viresh Kumar wrote:
>> This has been running in my mind since few days... That we have fixed cpufreq
>> core and all other drivers for transition serialization but what about
>> powernow-k8? It is somewhat special (even more than exynos5440).. It queues a
>> work from ->target() and may or maynot send notifications at all..
>>
>> Finally I have got a solution now (detailed logs in the patch)..
>> These must go with following patchset:
>
> The "must go" here is a totally wrong way of speaking about things, because I'm
> not sure I'll take this patch series yet.
>
>> https://lkml.org/lkml/2013/9/12/173

The "must go" was about keeping all four patches together, rather than
forcing you to take them all..

Sorry for the confusion..
