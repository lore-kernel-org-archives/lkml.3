Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaD1TUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:20:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:8643 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaD1TTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:19:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,945,1389772800"; 
   d="scan'208";a="502450139"
Date: Mon, 28 Apr 2014 03:51:57 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: intel_rapl: No such device
Message-ID: <20140428035157.6e9458e6@jacob-desktop>
In-Reply-To: <201404261224.45353@pali>
References: <201404261224.45353@pali>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2014 12:24:45 +0200
Pali Rohár <pali.rohar@gmail.com> wrote:

> Hello,
> 
> on intel haswell mobile cpu it is not possible to load intel_rapl 
> driver. Modprobe will show this error message:
> 
> intel_rapl.ko': -1 No such device
> intel_rapl: driver does not support CPU family 6 model 60
> 
> Is not intel mobile cpu supported by intel_rapl?
> 
> 
intel_rapl should support this model. I just haven't got a chance to
test on this particular part.
I will send out a patch soon and CC you.

Thanks,

Jacob
> Here is info from /proc/cpuinfo
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 60
> model name      : Intel(R) Core(TM) i5-4300M CPU @ 2.60GHz
> stepping        : 3
> microcode       : 0x17
> cpu MHz         : 2585.375
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 4
> core id         : 0
> cpu cores       : 2
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep 
> mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss 
> ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon 
> pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu 
> pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma 
> cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt 
> tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat 
> epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid 
> fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
> bogomips        : 5187.99
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 39 bits physical, 48 bits virtual
> power management:
> 
> 
> And from /sys/devices/system/cpu/modalias
> 
> cpu:type:x86,ven0000fam0006mod003C:feature:,0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,0015,0016,0017,0018,0019,001A,001B,001C,001D,001F,002B,0034,003A,003B,003D,0068,006B,006C,006D,006F,0070,0072,0074,0075,0076,0078,007C,007D,0080,0081,0082,0083,0084,0085,0086,0087,0088,0089,008B,008C,008D,008E,008F,0091,0093,0094,0095,0096,0097,0098,0099,009A,009B,009C,009D,009E,00C0,00C5,00E0,00E1,00E3,00E4,00E5,00E6,00E7,0100,0101,0102,0103,0104,0120,0121,0123,0124,0125,0127,0128,0129,012A,012B,012D
> 

[Jacob Pan]
