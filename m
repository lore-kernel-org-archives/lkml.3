Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3FSFPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:15:12 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52167 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3FSFPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:15:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpont42JcdLH-TawNWVDJeiLNHeAWx4fgvAkyerOD=64MLQ@mail.gmail.com>
References: <1371606191-5618-1-git-send-email-chenxg@marvell.com>
	<CAKohpont42JcdLH-TawNWVDJeiLNHeAWx4fgvAkyerOD=64MLQ@mail.gmail.com>
Date: Wed, 19 Jun 2013 13:15:08 +0800
Message-ID: <CAFgnuDcxS53FS0w31w8k4JzyhKadfO+P12jOy5hyfVKf6pEPWg@mail.gmail.com>
Subject: Re: [PATCH v6] Cpufreq: Fix governor start/stop race condition
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoguang Chen <chenxg@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/19 Viresh Kumar <viresh.kumar@linaro.org>:
> On 19 June 2013 07:13, Xiaoguang Chen <chenxg@marvell.com> wrote:
>> There are 4 CPUs and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
>> The normal sequence is as below:
>
> I thought Rafael asked to write cpu0 as CPU0, ...

I changed "cpus" to "CPUs" as Rafael suggested(Please spell cpus as
"CPUs".  And please start sequences from capitals.)
do I need to change other "cpu" to "CPU"?
