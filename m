Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab3FMWG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:06:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36618 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757866Ab3FMWGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:06:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target frequency
Date: Fri, 14 Jun 2013 00:15:36 +0200
Message-ID: <1645236.hTWQPUhyIx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130613214007.GA32127@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <51BA380A.1040009@semaphore.gr> <20130613214007.GA32127@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 13, 2013 11:40:08 PM Borislav Petkov wrote:
> On Fri, Jun 14, 2013 at 12:22:18AM +0300, Stratos Karafotis wrote:
> > Please let me share some more test results using aim9 benchmark suite:
> > https://docs.google.com/spreadsheet/ccc?key=0AnMfNYUV1k0ddDdGdlJyUHpqT2xGY1lBOEt2UEVnNlE&usp=sharing
> > 
> > Each test was running for 10sec. 
> > Total execution time with and without the patch was almost identical, which is
> > expected since the tests in aim9 run for a specific period.
> > The energy during the test run was increased by 0.43% with the patch.
> > The performance was increased by 1.25% (average) with this patch.
> 
> Not bad. However, exec_test and fork_test are kinda unexpected with such
> a high improvement percentage. Happen to have an explanation?
> 
> FWIW, if we don't find any serious perf/power regressions with
> this patch, I'd say it is worth applying even solely for the code
> simplification it brings.

May I take this as an ACK? ;-)

Well, that's my opinion too, actually.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
