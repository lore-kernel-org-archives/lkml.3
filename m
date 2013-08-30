Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3H3EaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:30:19 -0400
Received: from ra.se.axis.com ([195.60.68.13]:55789 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab3H3EaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:30:14 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2013 00:30:13 EDT
From: Mikael Starvik <mikael.starvik@axis.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jespern@axis.com>, John Crispin <blogic@openwrt.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Miao Steven <realmz6@gmail.com>, Dave Jones <davej@redhat.com>
Date: Fri, 30 Aug 2013 06:21:19 +0200
Subject: Re: [Query] CPUFreq: Does these machines have separate clock
 domains for CPUs?
Thread-Topic: [Query] CPUFreq: Does these machines have separate clock
 domains for CPUs?
Thread-Index: Ac6lOGDwP0vPriWnRt+qUEwuWw3S5Q==
Message-ID: <D9E0917B-058A-4F22-87EF-15F26ED46F35@axis.com>
References: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
In-Reply-To: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
Accept-Language: sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cris are also UP

29 aug 2013 kl. 12:16 skrev "Viresh Kumar" <viresh.kumar@linaro.org>:

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
> 
> drivers/cpufreq/at32ap-cpufreq.c
> drivers/cpufreq/blackfin-cpufreq.c
> drivers/cpufreq/cris-artpec3-cpufreq.c
> drivers/cpufreq/cris-etraxfs-cpufreq.c
> drivers/cpufreq/davinci-cpufreq.c
> drivers/cpufreq/e_powersaver.c
> drivers/cpufreq/elanfreq.c
> drivers/cpufreq/longhaul.c
> drivers/cpufreq/loongson2_cpufreq.c
> drivers/cpufreq/pmac32-cpufreq.c
> drivers/cpufreq/powernow-k6.c
> drivers/cpufreq/powernow-k7.c
> drivers/cpufreq/pxa2xx-cpufreq.c
> drivers/cpufreq/pxa3xx-cpufreq.c
> drivers/cpufreq/sc520_freq.c
> drivers/cpufreq/sh-cpufreq.c
> drivers/cpufreq/sparc-us2e-cpufreq.c
> drivers/cpufreq/sparc-us3-cpufreq.c
> 
> --
> Viresh
