Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaBLSP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:15:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46090 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaBLSPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:15:25 -0500
Date: Wed, 12 Feb 2014 19:15:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Too many rescheduling interrupts (still!)
Message-ID: <20140212181517.GE27965@twins.programming.kicks-ass.net>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
 <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
 <20140212101324.GC3545@laptop.programming.kicks-ass.net>
 <CAFTL4hyJtUHaT39NmM71=Ho4fp28PJ+-KezQryXJE_gTEMaHqA@mail.gmail.com>
 <20140212164356.GB27965@twins.programming.kicks-ass.net>
 <20140212174637.GC5496@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212174637.GC5496@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 06:46:39PM +0100, Frederic Weisbecker wrote:
> Ok but if the target is idle, dynticks and not polling, we don't have the choice
> but to send an IPI, right? I'm talking about this kind of case.

Yes; but Andy doesn't seem concerned with such hardware (!x86).

Anything x86 (except ancient stuff) is effectively polling and wakes up
from the TIF_NEED_RESCHED write.

