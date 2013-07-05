Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab3GEWSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:18:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:46825 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3GEWR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:17:59 -0400
Date: Sat, 6 Jul 2013 00:17:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alex Shi <alex.shi@intel.com>, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
In-Reply-To: <20130705215829.GB29025@pd.tnic>
Message-ID: <alpine.DEB.2.02.1307060016370.32106@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <20130704075840.GH18898@dyad.programming.kicks-ass.net> <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com> <20130705143833.GT23916@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1307051718430.32106@ionos.tec.linutronix.de> <20130705212235.GU23916@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1307052345330.32106@ionos.tec.linutronix.de> <20130705215829.GB29025@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Borislav Petkov wrote:
> On Fri, Jul 05, 2013 at 11:50:05PM +0200, Thomas Gleixner wrote:
> > Yeah, but our well justified paranoia still prevents us from trusting
> > these CPU flags. Maybe some day BIOS is going to be replaced by
> > something useful. You know: Hope springs eternal....
> 
> Not in the next 10 yrs at least if one took a look at the
> overengineered, obese at birth and braindead crap by the name of UEFI.

Good news! 10 years is way less than eternity and just before
retirement :)
