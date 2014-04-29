Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaD2ERu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:17:50 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55679 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaD2ERs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:17:48 -0400
MIME-Version: 1.0
In-Reply-To: <535AC247.3070907@semaphore.gr>
References: <535AC247.3070907@semaphore.gr>
Date: Tue, 29 Apr 2014 09:47:47 +0530
Message-ID: <CAKohpok-74uK5k-adxjmEy71=vF8V7MaBwdCD1Vb2ats7FHi_A@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] Introduce new cpufreq helper macros
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2014 01:45, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> This patch set introduces two freq_table helper macros which
> can be used for iteration over cpufreq_frequency_table and
> makes the necessary changes to cpufreq core and drivers that
> use such an iteration procedure.
>
> The motivation was a usage of common procedure to iterate over
> cpufreq_frequency_table across all drivers and cpufreq core.
>
> This was tested on a x86_64 platform.
> Most files compiled successfully but unfortunately I was not
> able to compile sh_sir.c pasemi_cpufreq.c and ppc_cbe_cpufreq.c
> due to lack of cross compiler.
>
> Changelog
>
> v4 -> v5
>         - Fix warnings in printk format specifier for 32 bit
>           architectures in freq_table.c, longhaul, pasemi, ppc_cbe

Doesn't look much has changed and so it stays as is:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
