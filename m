Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3K0ON2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:13:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50949 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756489Ab3K0OJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:09:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
Date: Wed, 27 Nov 2013 15:22:01 +0100
Message-ID: <4759452.7dXrrSTGCc@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpokjAuUA-o4cJi=N7mO93kTwrmfVqtL-zOHAs6awKoXn1A@mail.gmail.com>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org> <2309056.KUZA1Fnj0Y@vostro.rjw.lan> <CAKohpokjAuUA-o4cJi=N7mO93kTwrmfVqtL-zOHAs6awKoXn1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 08:31:02 AM Viresh Kumar wrote:
> On 27 November 2013 01:51, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > I was talking about the case when your
> >
> > __cpufreq_driver_target(policy, policy->cur - 1, CPUFREQ_RELATION_L);
> >
> > fails.  The other case is not really interesting.
> 
> Okay.. I actually thought the context of this chat is about "not fixing the
> frequency silently". That's what Dirk pointed out, if I am not wrong.

In that case you can simply print a message bashing the boot loader. :-)

> And hence I also support the new pr_warn I have added in those cases.

Sure.

> But yes a WARN_ON() can be printed out in case
> __cpufreq_driver_target() fails.

And here my question was: Is it safe to continue at all in that case?

Rafael

