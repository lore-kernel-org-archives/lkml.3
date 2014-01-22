Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaAVSn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:43:28 -0500
Received: from one.firstfloor.org ([193.170.194.197]:36810 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaAVSn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:43:27 -0500
Date: Wed, 22 Jan 2014 19:43:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Jan Kiszka <jan.kiszka@siemens.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Inconsistent xAPIC synchronization in arch_irq_work_raise?
Message-ID: <20140122184325.GY20765@two.firstfloor.org>
References: <52DE6FCE.2050708@siemens.com>
 <20140121140113.GL30183@twins.programming.kicks-ass.net>
 <20140121145105.GE3694@twins.programming.kicks-ass.net>
 <1390346420.23634.5.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390346420.23634.5.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Huang Ying, can you explain to Jan why you do the wait afterwards?
> 
> I borrow the code from the original MCE report event code.
> 
> Andi, could you help us to explain it?

I don't recall all the details, but I believe i also just copied 
it from the APIC code. I don't think I did any particular ordering
intentionally.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
