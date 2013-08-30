Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3H3Gsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:48:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62533 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3H3Gsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:48:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
References: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
Date: Fri, 30 Aug 2013 15:48:28 +0900
Message-ID: <CANqRtoTSO2yyP35naDe4y6a7rL99=cSs4-bJAWOxR5HL2gbpuw@mail.gmail.com>
Subject: Re: [Query] CPUFreq: Does these machines have separate clock domains
 for CPUs?
From: Magnus Damm <magnus.damm@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Eric Miao <eric.y.miao@gmail.com>, linux-cris-kernel@axis.com,
        SH-Linux <linux-sh@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Miao Steven <realmz6@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Mikael Starvik <starvik@axis.com>, Paul Mundt <lethal@linux-sh.org>,
        sparclinux@vger.kernel.org, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>, John Crispin <blogic@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, Aug 29, 2013 at 7:15 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Hi,
>
> I have been doing some CPUFreq cleanup work and
> wanted to know if the below mentioned machines have separate
> clock domains for their CPUs or all share the same domain?
>
> So, that we can use some generic routines for these drivers which
> would eventually do:
>
> cpumask_setall(policy->cpus);
>
> And I wanted to make sure that this doesn't break them.. :)
>
> ......
>
> The drivers are:
...
> drivers/cpufreq/sh-cpufreq.c
...

The above SH cpufreq driver seems to be written with SMP in mind, but
I would say SMP is a very rare case for SH. So I believe it can be
considered as UP-only at this point. If Paul disagrees I'm quite sure
he will tell us.

Cheers,

/ magnus
