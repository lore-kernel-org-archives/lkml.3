Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3FKWZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:25:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34488 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab3FKWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:25:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Hansen <dave@sr71.net>
Cc: Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: cpu hotplug:  possible_cpus broken (again?) next-20130607
Date: Wed, 12 Jun 2013 00:34:51 +0200
Message-ID: <27437213.QrmAtijARn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51B7A1F8.6080507@sr71.net>
References: <51B79BE5.80804@sr71.net> <1637965.BN0HgQKvFj@vostro.rjw.lan> <51B7A1F8.6080507@sr71.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 11, 2013 03:17:28 PM Dave Hansen wrote:
> On 06/11/2013 03:05 PM, Rafael J. Wysocki wrote:
> > On Tuesday, June 11, 2013 02:51:33 PM Dave Hansen wrote:
> >> possible_cpus looks broken again.  I'm booting with:
> >>
> >>  maxcpus=10 possible_cpus=160
> >>
> >> But I only get 0-9 in sysfs:
> >>
> >>> # ls /sys/devices/system/cpu/
> >>> cpu0  cpu2  cpu4  cpu6  cpu8  cpufreq  kernel_max  offline  possible  probe    uevent
> >>> cpu1  cpu3  cpu5  cpu7  cpu9  cpuidle  modalias    online   present   release
> > 
> > Can you please test the acpi-hotplug branch of the linux-pm.git tree?
> 
> That branch seems to work happily.

In that case the problem may have been reintroduced by a merge conflict fix in
linux-next.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
