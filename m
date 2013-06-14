Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3FNMoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:44:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38973 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab3FNMoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:44:05 -0400
Date: Fri, 14 Jun 2013 14:44:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130614124400.GA8693@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com>
 <1645236.hTWQPUhyIx@vostro.rjw.lan>
 <20130613223740.GE32112@pd.tnic>
 <1469773.K3KVgsTfzW@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1469773.K3KVgsTfzW@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 02:46:38PM +0200, Rafael J. Wysocki wrote:
> OK, so here's a deal. After 3.10-rc1 goes out, I'll put this into
> linux-next

Yeah, you mean 3.11-rc1 here...

> for 3.12, so that people have a few more weeks to complain. If they
> don't, it'll go into 3.12.

but yep, sounds like a deal.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
