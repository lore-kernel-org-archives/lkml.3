Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3INE37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:29:59 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51966 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3INE35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <9715082.jFAchu7UKu@vostro.rjw.lan>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
	<5197493.kSPF7VUWqc@vostro.rjw.lan>
	<CAKohpom8d89OtJOs-_eCu+RiVA+B0bt7rtgNcJn=D=y95+jdQg@mail.gmail.com>
	<9715082.jFAchu7UKu@vostro.rjw.lan>
Date: Sat, 14 Sep 2013 09:59:57 +0530
Message-ID: <CAKohpokVxksc-BSU87oAWN_uNaZtCXnTJ70RnYVrYMVmeTkLmQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2013 05:18, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> OK, I'll think about that, but not today and probably not within the next
> few days, because I'm heading to New Orleans in several hours and really
> have other stuff to take care of now.  Sorry about that.

No issues..
