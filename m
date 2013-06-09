Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3FIVOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 17:14:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44033 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3FIVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 17:14:53 -0400
Date: Sun, 9 Jun 2013 23:14:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130609211449.GA5517@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com>
 <20130609162653.GA5004@pd.tnic>
 <51B4C497.2030308@semaphore.gr>
 <7661669.NhG4BEI8zO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7661669.NhG4BEI8zO@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 10:58:51PM +0200, Rafael J. Wysocki wrote:
> Can you possibly prepare a graph showing both the execution time
> and energy consumption for several different loop durations in your
> program (let's keep the 5000 us sleep for now), including multiples of
> sampling_rate as well as some other durations?

Judgind by the times in C0 one of the cores spent, this small program
is single-threaded and is a microbenchmark. And you know how optimizing
against a microbenchmark doesn't really make a lot of sense.

I wonder if lmbench or aim9 or whatever would make more sense to try
here...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
