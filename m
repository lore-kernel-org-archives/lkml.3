Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161582Ab3FUPKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:10:31 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52637 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3FUPKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:10:30 -0400
Date: Fri, 21 Jun 2013 17:10:27 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dirk Schmidt <derschmied@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Amd Phenom 2 X6 Cool&Quiet Issue.
Message-ID: <20130621151027.GB526@x4>
References: <51C4600E.6030005@gmx.de>
 <20130621141906.GA526@x4>
 <51C4665A.8010802@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C4665A.8010802@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.06.21 at 16:42 +0200, Dirk Schmidt wrote:
> Hello.
> 
> Am 21.06.2013 16:19, schrieb Markus Trippelsdorf:
> > On 2013.06.21 at 16:15 +0200, Dirk Schmidt wrote:
> >> Amd Phenom 2 X6 Cool&Quiet Issue.
> >>
> >> Problem:
> >>
> >> dmesg | grep power
> >> [   10.622426] powernow-k8: This CPU is not supported anymore, using
> >> acpi-cpufreq instead.
> >>
> >> modprobe acpi_cpufreq
> >> ERROR: could not insert 'acpi_cpufreq': No such device
> >
> > Please post your kernel .config.
> >
> 
> config attached.
> 
> #
> # x86 CPU frequency scaling drivers
> #
> # CONFIG_X86_INTEL_PSTATE is not set
> CONFIG_X86_PCC_CPUFREQ=m
> CONFIG_X86_ACPI_CPUFREQ=m
> CONFIG_X86_ACPI_CPUFREQ_CPB=y
> CONFIG_X86_POWERNOW_K8=m
> # CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
> CONFIG_X86_SPEEDSTEP_CENTRINO=m
> CONFIG_X86_P4_CLOCKMOD=m

Does it work if you disable everything under "x86 CPU frequency scaling
drivers" and build CONFIG_X86_ACPI_CPUFREQ directly into the kernel?

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ_CPB is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set


-- 
Markus
