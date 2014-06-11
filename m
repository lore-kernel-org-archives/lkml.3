Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaFKMGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:06:01 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54082 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaFKMGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:06:00 -0400
Date: Wed, 11 Jun 2014 13:05:57 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, acme@kernel.org,
        mingo@redhat.com, paulus@samba.org, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
Message-ID: <20140611120557.GC26290@console-pimps.org>
References: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
 <20140611085448.GI3213@twins.programming.kicks-ass.net>
 <20140611115413.GE3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611115413.GE3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun, at 01:54:13PM, Peter Zijlstra wrote:
> 
> Matt found in the MSR listing for GLOBAL_STATUS:
> 
> 63 CondChg: status bits of this register has changed.  If CPUID.0AH: EAX[7:0] > 0
> 
> Which brings us to a grand total of 3 different names for this bit.

Right, I'm flinging emails around to get this fixed in the SDM, so that
the answer to,

Q: "How many kernel developers does it take to find the definition of
this bit?"

is less than 4.

-- 
Matt Fleming, Intel Open Source Technology Center
