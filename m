Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab3FNMpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:45:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37285 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3FNMpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:45:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, Borislav Petkov <bp@suse.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target frequency
Date: Fri, 14 Jun 2013 14:55:06 +0200
Message-ID: <2227190.21dzlq2WhC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130614124400.GA8693@pd.tnic>
References: <q46r5iepl3sunqe5eemv66hk.1370694869222@email.android.com> <1469773.K3KVgsTfzW@vostro.rjw.lan> <20130614124400.GA8693@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 14, 2013 02:44:01 PM Borislav Petkov wrote:
> On Fri, Jun 14, 2013 at 02:46:38PM +0200, Rafael J. Wysocki wrote:
> > OK, so here's a deal. After 3.10-rc1 goes out, I'll put this into
> > linux-next
> 
> Yeah, you mean 3.11-rc1 here...

Sure, sorry for the confusion.

> > for 3.12, so that people have a few more weeks to complain. If they
> > don't, it'll go into 3.12.
> 
> but yep, sounds like a deal.

Cool, thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
