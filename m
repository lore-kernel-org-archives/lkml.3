Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab3LHAVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 19:21:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49372 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752811Ab3LHAVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 19:21:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH V4] cpufreq: suspend governors on system suspend/hibernate
Date: Sun, 08 Dec 2013 01:34:36 +0100
Message-ID: <3466098.C5M665z3nb@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1386429849.9737.7.camel@x41.thuisdomein>
References: <28d493f20239a242a7b26dfe1efed40d83bf1e10.1385523340.git.viresh.kumar@linaro.org> <87vbz0j55p.fsf@nemi.mork.no> <1386429849.9737.7.camel@x41.thuisdomein>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 07, 2013 04:24:09 PM Paul Bolle wrote:
> On Sat, 2013-12-07 at 12:01 +0100, Bjørn Mork wrote:
> > Sorry to be making noise here again, but I was eager to verify that the
> > fixes in v3.13-rc3 were OK on my system.  Unfortunately it seems this
> > patch completely broke suspend for me.  Hibernete ended up with a blank
> > console and no visible activity, without ever writing any image to disk.
> > 
> > There really weren't that many suspects between v3.13-rc2 and v3.13-rc3,
> > so I went directly to reverting 5a87182aa21d ("cpufreq: suspend
> > governors on system suspend/hibernate") which fixed the problem. I
> > didn't bother debugging it further from there. I don't think there is
> > anything magic about my system which should make this problem specific
> > to it.
> > 
> > I am still using the acpi-cpufreq driver on an old x86_64 laptop if that
> > matters.
> 
> On an x86 (32 bits) laptop hibernate also broke in v3.13-rc3. On that
> machine hibernation itself worked, or at least seemed to work, but the
> machine would basically stop after thawing (directly after loading the
> hibernation image).
> 
> And reverting commit 5a87182aa21d ("cpufreq: suspend governors on system
> suspend/hibernate"), on top of v3.13-rc3, also lead to a successful
> hibernation/thaw cycle.

OK, reverted.

I'll send a pull request with that revert shortly.

Thanks,
Rafael

