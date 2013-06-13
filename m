Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab3FMVkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 17:40:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41406 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759300Ab3FMVkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 17:40:12 -0400
Date: Thu, 13 Jun 2013 23:40:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130613214007.GA32127@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com>
 <7661669.NhG4BEI8zO@vostro.rjw.lan>
 <51B64BC6.6040400@semaphore.gr>
 <16929930.1G36b4NkSe@vostro.rjw.lan>
 <51BA380A.1040009@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51BA380A.1040009@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 12:22:18AM +0300, Stratos Karafotis wrote:
> Please let me share some more test results using aim9 benchmark suite:
> https://docs.google.com/spreadsheet/ccc?key=0AnMfNYUV1k0ddDdGdlJyUHpqT2xGY1lBOEt2UEVnNlE&usp=sharing
> 
> Each test was running for 10sec. 
> Total execution time with and without the patch was almost identical, which is
> expected since the tests in aim9 run for a specific period.
> The energy during the test run was increased by 0.43% with the patch.
> The performance was increased by 1.25% (average) with this patch.

Not bad. However, exec_test and fork_test are kinda unexpected with such
a high improvement percentage. Happen to have an explanation?

FWIW, if we don't find any serious perf/power regressions with
this patch, I'd say it is worth applying even solely for the code
simplification it brings.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
