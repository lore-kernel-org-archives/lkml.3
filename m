Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433Ab3ECT2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:28:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57078 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763076Ab3ECT2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:28:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: linux-acpi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost ACPI functionality
Date: Fri, 03 May 2013 21:36:54 +0200
Message-ID: <3715884.H8PIhhjRXL@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5183EC09.9080208@gmx.de>
References: <5183EC09.9080208@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 03, 2013 06:55:37 PM Toralf Förster wrote:
> The following file doesn't exists at my Gentoo Linux
> /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
> in 3.9.0 if I activate CONFIG_X86_INTEL_PSTATE=y 
> 
> That means, that a command like
> 
> $> echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
> 
> in /etc/rc.local is now no longer working.
> A high fan +  high temperature are the result, even if just the BOINC client
> is run with low prio (nice 19) in the back ground.
> 
> Manually loading the missing module won't work too :
> 
> $> modprobe acpi_cpufreq
> modprobe: ERROR: could not insert 'acpi_cpufreq': Device or resource busy
> 
> Is the behaviour a bug or a feature ?

The thermal management problem is not an intentional outcome, definitely.

> In the later case: How can I achieve the previous behaviour back ?
> 
> This issue might affect the RH EL kernel too [1] where I observed a similar behaviour.
> 
> 
> [1] http://elrepo.org/bugs/view.php?id=379

Dirk, is this the problem we were talking about recently or something else?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
