Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965214AbaD2WJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:09:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65002 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965174AbaD2WJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:09:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>, linux-doc@vger.kernel.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>, Sekhar Nori <nsekhar@ti.com>,
        Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
Date: Wed, 30 Apr 2014 00:26:07 +0200
Message-ID: <1621123.rMC9JtD3Mo@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <535FCDBD.6080500@semaphore.gr>
References: <535AC247.3070907@semaphore.gr> <CAKohpok-74uK5k-adxjmEy71=vF8V7MaBwdCD1Vb2ats7FHi_A@mail.gmail.com> <535FCDBD.6080500@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 07:05:17 PM Stratos Karafotis wrote:
> On 29/04/2014 07:17 πμ, Viresh Kumar wrote:
> > On 26 April 2014 01:45, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> >> This patch set introduces two freq_table helper macros which
> >> can be used for iteration over cpufreq_frequency_table and
> >> makes the necessary changes to cpufreq core and drivers that
> >> use such an iteration procedure.
> >>
> >> The motivation was a usage of common procedure to iterate over
> >> cpufreq_frequency_table across all drivers and cpufreq core.
> >>
> >> This was tested on a x86_64 platform.
> >> Most files compiled successfully but unfortunately I was not
> >> able to compile sh_sir.c pasemi_cpufreq.c and ppc_cbe_cpufreq.c
> >> due to lack of cross compiler.
> >>
> >> Changelog
> >>
> >> v4 -> v5
> >>         - Fix warnings in printk format specifier for 32 bit
> >>           architectures in freq_table.c, longhaul, pasemi, ppc_cbe
> > 
> > Doesn't look much has changed and so it stays as is:
> > 
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > 
> 
> Thank you very much!

I've applied the series to my bleeding-edge branch, will move it to linux-next
after build testing later this week.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
