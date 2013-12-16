Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3LPQej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:34:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34760 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3LPQeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:34:36 -0500
Date: Mon, 16 Dec 2013 11:33:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Jiang Liu <liuj97@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@kernel.org>,
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
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v3 [resend] 14/18] smp, x86, xen: kill SMP single
 function call interrupt
Message-ID: <20131216163334.GC20165@phenom.dumpdata.com>
References: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
 <1387125400-28849-15-git-send-email-liuj97@gmail.com>
 <20131216030040.GB7180@pegasus.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923350142ABC2@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350142ABC2@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:24:41AM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Mon, Dec 16, 2013 at 12:36:36AM +0800, Jiang Liu wrote:
> >> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> >> similar to smp_call_function_single()" has unified the way to handle
> >> single and multiple cross-CPU function calls. Now only one interrupt
> >> is needed for architecture specific code to support generic SMP
> >> function 
> >> call interfaces, so kill the redundant single function call
> >> interrupt. 
> >> 
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: Shaohua Li <shli@kernel.org>
> >> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >> Cc: Steven Rostedt <rostedt@goodmis.org>
> >> Cc: Jiri Kosina <trivial@kernel.org>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > I presume this has been tested?
> > 
> 
> I have just test Jiang's patch, it works fine for dom0 booting.

Excellent! Please add Acked-by from me.

Thanks!

> 
> Thanks,
> Jinsong
> 
> 
