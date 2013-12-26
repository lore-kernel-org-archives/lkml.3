Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3LZAm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 19:42:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55118 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752440Ab3LZAm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 19:42:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
Date: Thu, 26 Dec 2013 01:56:25 +0100
Message-ID: <3682408.uVrpujAYh7@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131225223907.GA13593@amd.pavel.ucw.cz>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <6050176.zVNbf5pomE@vostro.rjw.lan> <20131225223907.GA13593@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 25, 2013 11:39:07 PM Pavel Machek wrote:
> Hi!
> 
> > > > Well, disabling it for the whole duration of suspend/resume and/or hibernation
> > > > may not be the right approach entirely, unless we force the pax perf of the
> > > 
> > > s/pax/max ?
> > 
> > Yes.
> 
> I'm not sure max frequency is a good idea. In particular, early
> athlon64 notebooks could not run on max frequency on battery power.
> 
> IMO it would be good to keep governors running during hibernation.

The idea of using PM notifiers for cpufreq suspend/resume has been abandoned
already.

Thanks,
Rafael

