Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3LPEYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:24:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:18287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab3LPEYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:24:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,493,1384329600"; 
   d="scan'208";a="425165998"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH v3 [resend] 14/18] smp, x86, xen: kill SMP single
 function call interrupt
Thread-Topic: [PATCH v3 [resend] 14/18] smp, x86, xen: kill SMP single
 function call interrupt
Thread-Index: AQHO+gtCEcbarGQnr0yxjfG5Uv34gppWOSrQ
Date: Mon, 16 Dec 2013 04:24:41 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350142ABC2@SHSMSX101.ccr.corp.intel.com>
References: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
 <1387125400-28849-15-git-send-email-liuj97@gmail.com>
 <20131216030040.GB7180@pegasus.dumpdata.com>
In-Reply-To: <20131216030040.GB7180@pegasus.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Mon, Dec 16, 2013 at 12:36:36AM +0800, Jiang Liu wrote:
>> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
>> similar to smp_call_function_single()" has unified the way to handle
>> single and multiple cross-CPU function calls. Now only one interrupt
>> is needed for architecture specific code to support generic SMP
>> function 
>> call interfaces, so kill the redundant single function call
>> interrupt. 
>> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Shaohua Li <shli@kernel.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Jiri Kosina <trivial@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> I presume this has been tested?
> 

I have just test Jiang's patch, it works fine for dom0 booting.

Thanks,
Jinsong


