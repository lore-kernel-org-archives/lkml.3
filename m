Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3GEV6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:58:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35496 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab3GEV6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:58:37 -0400
Date: Fri, 5 Jul 2013 23:58:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alex Shi <alex.shi@intel.com>, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
Message-ID: <20130705215829.GB29025@pd.tnic>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
 <20130704075840.GH18898@dyad.programming.kicks-ass.net>
 <CAFTL4hy24+=2++CN5rBhn9v+pvxR+tTja9Z-wRLSS__LGQBWaQ@mail.gmail.com>
 <20130705143833.GT23916@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1307051718430.32106@ionos.tec.linutronix.de>
 <20130705212235.GU23916@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1307052345330.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307052345330.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:50:05PM +0200, Thomas Gleixner wrote:
> Yeah, but our well justified paranoia still prevents us from trusting
> these CPU flags. Maybe some day BIOS is going to be replaced by
> something useful. You know: Hope springs eternal....

Not in the next 10 yrs at least if one took a look at the
overengineered, obese at birth and braindead crap by the name of UEFI.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
