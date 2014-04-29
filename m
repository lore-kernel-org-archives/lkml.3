Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbaD2Vpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:45:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50532 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932885AbaD2Vpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:45:42 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Date: Wed, 30 Apr 2014 00:02:11 +0200
Message-ID: <2040966.2iIHa1DVAN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140429105002.GG2639@e103034-lin>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <1586415.tT6O0p7OWR@vostro.rjw.lan> <20140429105002.GG2639@e103034-lin>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 11:50:02 AM Morten Rasmussen wrote:
> On Sun, Apr 27, 2014 at 02:23:24PM +0100, Rafael J. Wysocki wrote:

[cut]

> > The same applies to the maximum sustainable power draw limit more or less.
> > While it generally changes between "on battery" and "on AC power", it may also
> > depend on other factors like the capacity of the available power supply for a
> > data center.
> 
> I haven't given maximum power draw much thought, but it is a third
> objective independent of energy efficiency even though methods for
> improving energy efficiency (such as disabling expensive DVFS states)
> might be useful for this as well.

Yes, it is an independent objective.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
