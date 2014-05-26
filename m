Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaEZXKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:10:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63108 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751498AbaEZXKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:10:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: viresh.kumar@linaro.org, svaidy@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive bursty workloads
Date: Tue, 27 May 2014 01:27:54 +0200
Message-ID: <2902116.OdbNv5KQzQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

On Tuesday, May 27, 2014 02:23:38 AM Srivatsa S. Bhat wrote:
> Cpufreq governors like the ondemand governor calculate the load on the CPU
> periodically by employing deferrable timers. A deferrable timer won't fire
> if the CPU is completely idle (and there are no other timers to be run), in
> order to avoid unnecessary wakeups and thus save CPU power.
> 
> However, the load calculation logic is agnostic to all this, and this can
> lead to the problem described below.

This is subtle enough that I need some more time to chew on it, but since the
merge window is coming, I'm not sure when that's going to happen honestly.

Rafael

