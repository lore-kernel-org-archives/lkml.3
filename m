Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3BGB4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:56:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:55245 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549Ab3BGB4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:56:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: next-20130206 cpufreq - WARN in sysfs_add_one
Date: Thu, 07 Feb 2013 03:03:01 +0100
Message-ID: <40027556.U5lg3c4VjV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1729273.hgXged98n0@vostro.rjw.lan>
References: <9180.1360172675@turing-police.cc.vt.edu> <30908.1360198558@turing-police.cc.vt.edu> <1729273.hgXged98n0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 07, 2013 02:12:17 AM Rafael J. Wysocki wrote:
> On Wednesday, February 06, 2013 07:55:58 PM Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 06 Feb 2013 22:24:39 +0100, "Rafael J. Wysocki" said:
> > > On Wednesday, February 06, 2013 12:44:35 PM Valdis Kletnieks wrote:
> > > > Seen in dmesg.  next-20130128 was OK. Haven't done a bisect, but can
> > > > do so if the offender isn't obvious...
> > >
> > > I suppose this is 73bf0fc "cpufreq: Don't remove sysfs link for policy->cpu".
> > >
> > > Can you test the linux-pm.git/pm-cpufreq branch alone, please, and see
> > > if that's this one (top-most commit)?
> > 
> > Color me mystified.  I can't find that commit by either number or
> > the description:
> > 
> > [/usr/src/linux-next] git log | egrep -i 'cpufreq.*remove.*link'
> > [/usr/src/linux-next] git log | grep -i 73bf0fc
> > [/usr/src/linux-next]
> > 
> > Was that a very recent commit that may have gotten pushed too late
> > for the next-20130206 merge?
> 
> Well, sorry, next-20130206 didn't include that commit.
> 
> Can you please test the linux-pm.git/pm-cpufreq branch, then?

To be precise, I mean the pm-cpufreq branch of the tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git

which is based on v3.8-rc6.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
