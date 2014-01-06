Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaAFUhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:37:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50476 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754769AbaAFUhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:37:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] powernow-k6: fixes for the frequency driver
Date: Mon, 06 Jan 2014 21:51:05 +0100
Message-ID: <2372881.ND9u0a4YHW@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 11, 2013 07:37:48 PM Mikulas Patocka wrote:
> Hi
> 
> Here I'm sending three patches for k6 frequency governor.
> 
> 1. the processor doesn't respond to cache snoops when changing the 
> frequency, so we need to disable cache while doing the change.
> 
> 2. it is impossible to read the default multiplier. After reset, the 
> register always reports zero regardless of the current multiplier. So we 
> set the multiplier based on current frequency and allow the user to 
> override it with module parameter.
> 
> 3. reorder frequencies from the highest to the lowest.

I've queued up this series (and the speedstep-smi patch) for 3.14, but I don't
want it to go to stable upfront, so I removed the "Cc: stable" tags.  Please
send a stable inclusion request to Greg & Co after it spends a few weeks in
the Linus' tree.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
