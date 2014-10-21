Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaJUJDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:03:35 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:42329 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaJUJDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1413515616-15874-1-git-send-email-B29983@freescale.com>
	<CAKohpokotKSvQ13uU4MnCer+qzBUUbGVTd19y7xswCAEKk3nGQ@mail.gmail.com>
	<6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
Date: Tue, 21 Oct 2014 14:33:31 +0530
Message-ID: <CAKohpokSuKOwZ3-OWFtU0z7E1fsMg4tyPiUoFUfw26pD9Py=MA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ platforms
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Yuantian Tang <Yuantian.Tang@freescale.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 14:29, Yuantian Tang <Yuantian.Tang@freescale.com> wrote:
> If I do so, menuconfig will display like this(on PPC):
>         PowerPC CPU frequency scaling drivers  ----
>     QorIQ CPU Frequency scaling  --->
>                 <*> CPU frequency scaling driver for Freescale QorIQ SoCs
> On ARM, there should be a similar problem.
> Isn't weird?

Similar is true for cpufreq-cpu0 driver as well.. Maybe we can create a
Kconfig.drivers configuration and include it from all architecture specific
ones ?

@ Rafael ?
