Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3EJUVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 16:21:06 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47240 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3EJUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 16:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <51818334.7020201@fold.natur.cuni.cz>
References: <51818334.7020201@fold.natur.cuni.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 10 May 2013 14:20:41 -0600
Message-ID: <CAErSpo4x4Y3sJdvaYyTXT1pPAehrnD5ExA+qzpgkbNiqiU2yVA@mail.gmail.com>
Subject: Re: 3.9-linux-next-20130501: OOPS in intel_pstate_sample
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Toshi Kani <toshi.kani@hp.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Viresh, Srinivas, Dirk, cpufreq list]

On Wed, May 1, 2013 at 3:03 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> Hi,
>   I opened yet another bug https://bugzilla.kernel.org/show_bug.cgi?id=57411 .
>
> This is maybe a dupe of bug https://bugzilla.kernel.org/show_bug.cgi?id=57401
> (which is vanilla 3.9) but happened on linux-next-20130501 after I did "dmesg | less".
>
> ? pid_param_set
> intel_pstate_timer_func
> call_timer_fn
> ? __internal_add_timer
> ? pid_param_set
> run_timer_softirq
> __do_softirq
> irq_exit
> smp_apic_timer_interrupt
> apic_timer_interrupt
> ? sysret_check
>
> A camera picture of the stacktrace is attached to the bug https://bugzilla.kernel.org/show_bug.cgi?id=57411
> Please forward this to the appropriate person.
> Thanks,
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
