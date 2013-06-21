Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422872Ab3FUOPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:15:45 -0400
Received: from mout.gmx.net ([212.227.15.15]:59429 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161447Ab3FUOPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:15:44 -0400
X-Authenticated: #783749
X-Provags-ID: V01U2FsdGVkX188LFBrxVk8lFy+aHTXvRz7DE9FlWyBfjYKPJA7h7
	1dt770ZBPvBzAH
Message-ID: <51C4600E.6030005@gmx.de>
Date: Fri, 21 Jun 2013 16:15:42 +0200
From: Dirk Schmidt <derschmied@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Amd Phenom 2 X6 Cool&Quiet Issue.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amd Phenom 2 X6 Cool&Quiet Issue.

Hello.

Problem:

dmesg | grep power
[   10.622426] powernow-k8: This CPU is not supported anymore, using 
acpi-cpufreq instead.

modprobe acpi_cpufreq
ERROR: could not insert 'acpi_cpufreq': No such device

uname -a
Linux box 3.10.0-rc6 #1 SMP Sun Jun 16 10:56:41 CEST 2013 x86_64 GNU/Linux

cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 10
model name	: AMD Phenom(tm) II X6 1055T Processor
stepping	: 0
microcode	: 0x10000dc
cpu MHz		: 1999.892
cache size	: 512 KB
physical id	: 0
siblings	: 6
core id		: 0
cpu cores	: 6
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips	: 3999.78
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

Its running only at 2 Ghz as I have defined so in the BIOS.

With kind regards
Dirk Schmidt


