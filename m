Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3K1UTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:19:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57017 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753855Ab3K1UTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 15:19:02 -0500
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
Date: Thu, 28 Nov 2013 21:31:53 +0100
Message-ID: <1591147.c0NqbMglPZ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpomDu0Xh8Q1PEo3n+JwE26GkJTxhdezGPs7aJwJXjaTvLQ@mail.gmail.com>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org> <2065797.S0ijuuXCoe@vostro.rjw.lan> <CAKohpomDu0Xh8Q1PEo3n+JwE26GkJTxhdezGPs7aJwJXjaTvLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 28, 2013 07:44:02 PM Viresh Kumar wrote:
> On 28 November 2013 19:42, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, November 28, 2013 07:11:17 PM Viresh Kumar wrote:
> >> Okay.. So wouldn't it be better that we add this special flag only when we
> >> face a real problem? Otherwise this flag might stay unused for long time
> >> and then we might end up removing it..
> 
> What about this one?

Well, so are you saying that the problem is only theoretical now?

> > SKIP_INITIAL_FREQUENCY_CHECK ?
> 
> Looks fine.. In case this is required, you want this to be set initially for any
> driver?

That depends on what is less work and code churn.  How many platforms/drivers
have this problem today?  Which ones are they?

Rafael

