Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab3GHDNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 23:13:09 -0400
Received: from mout.gmx.net ([212.227.15.19]:64414 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab3GHDNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 23:13:07 -0400
Message-ID: <1373253148.7203.3.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Mon, 08 Jul 2013 05:12:28 +0200
In-Reply-To: <51DA28D2.9030104@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
	 <20130702085202.GA23916@twins.programming.kicks-ass.net>
	 <51D29EE5.8080307@linux.vnet.ibm.com>
	 <20130704091339.GK18898@dyad.programming.kicks-ass.net>
	 <51D5428D.7080805@linux.vnet.ibm.com>
	 <1372934013.9046.16.camel@marge.simpson.net>
	 <51D633DB.5010508@linux.vnet.ibm.com>
	 <1372997318.7315.23.camel@marge.simpson.net>
	 <51D64C84.5080100@linux.vnet.ibm.com>
	 <1373002865.8318.11.camel@marge.simpson.net>
	 <51D664B9.7010407@linux.vnet.ibm.com>
	 <1373179405.19316.41.camel@marge.simpson.net>
	 <51DA28D2.9030104@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:b3I3OuoDbfyUQSTGFtl9K+i0bEH2+fcAJE4qACaxN8rMdmagLiN
 iKBaDoSra6dEXdF5/nG5CFTLKB9xb1NHX50TJqq9W2nVfex1XzyX9R0D6F9iex+Ao8DbXkm
 MBDjFwFuazCJwpMGuZi6BDbnZynpNYrAMOKoV3avKDubJSCUOPVLi/Nu7WWijPnRELBE66c
 MyzpeZK04c4Ty2Cm60lLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 10:49 +0800, Michael Wang wrote:

> BTW, could you please show me the '/proc/cpuinfo' of your box? I'd like
> to collect some data for analyse later ;-)

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
stepping        : 11
microcode       : 0xba
cpu MHz         : 1600.000
cache size      : 4096 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dtherm tpr_shadow vnmi flexpriority
bogomips        : 4784.89
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

-Mike

